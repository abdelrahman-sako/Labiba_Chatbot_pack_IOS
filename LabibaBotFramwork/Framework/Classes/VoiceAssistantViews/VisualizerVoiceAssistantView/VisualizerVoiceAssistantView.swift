//
//  VisualizerVoiceAssistantView.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman on 7/5/20.
//  Copyright © 2020 Abdul Rahman. All rights reserved.
//

import UIKit
import AVFoundation
import Accelerate
// protocol VisualizerVoiceAssistantViewDelegate:VoiceRecognitionProtocol
//{
//    func visualizerVoiceAssistantView(_ dialog: VisualizerVoiceAssistantView, didSubmitText text: String)
//    func visualizerKeyboardWillShow(keyboardHight:CGFloat)
//    func visualizerKeyboardWillHide()
//}


class VisualizerVoiceAssistantView: UIView {
    
    static func create() ->VisualizerVoiceAssistantView {
        return Labiba.bundle.loadNibNamed("VisualizerVoiceAssistantView", owner: nil, options: nil)?.first as! VisualizerVoiceAssistantView
    }
    
    //MARK: User Input Outlets
    @IBOutlet weak var placeholderLbl: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var userInputContainerView: UIView!
    @IBOutlet weak var sendImageView: UIImageView!
    @IBOutlet weak var sendButton: UIButton!
    // constraint must  be a strong refrence because I'm setting them active and inactive
    @IBOutlet var userInputBottomConst: NSLayoutConstraint!
    @IBOutlet var userInputExpandedBottonConst: NSLayoutConstraint!
    @IBOutlet weak var userInputHightConst: NSLayoutConstraint!
    
    //MARK: Voice Assistant Outlets
    @IBOutlet weak var audioVisualizerView: AudioVisualizerView!
    @IBOutlet weak var floatingBubbleVisualizer: FloatingBubblesVisualizer!
    @IBOutlet weak var micContainerView: UIView!
    @IBOutlet weak var startRecordingBtn: UIButton!
    
    //MARK: Variables
    var delegate:VoiceAssistantKeyboardDelegate?
    var userInputMask: CACornerMask = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner ,.layerMinXMaxYCorner ,.layerMinXMinYCorner]
    var isUserTyping:Bool = false
    static var INPUT_HEIGHT: CGFloat  {
        switch UIScreen.current {
        case .ipad ,.iPad10_5 ,.iPad12_9 ,.iPad9_7:
            return 55
        default:
            return 44
        }
    }
    var MaximumCount = 2000
    var orginalBottomMargin:CGFloat = 100
    let sendImage = LbLanguage.isArabic ? "ic_send" : "ic_send_r"
    
    let speechToTextManager = SpeechToTextManager.shared
    var isAnimating:Bool = false
    var count = 0
    override func awakeFromNib(){
        super.awakeFromNib()
        // general
        orginalBottomMargin = userInputBottomConst.constant
        self.textView.delegate = self
        addKeyboardObservers()
         speechToTextManager.delegate = self
        // add corner mask
        if SharedPreference.shared.botLangCode == .ar {
            userInputMask.remove(.layerMinXMaxYCorner)
        }else{
            userInputMask.remove(.layerMaxXMaxYCorner)
        }
        userInputContainerView.layer.maskedCorners = userInputMask
        
        // theme
       // userInputContainerView.backgroundColor = Labiba._UserInputColors.background
        userInputContainerView.backgroundColor = Labiba.UserInputView.backgroundColor
        textView.font = applyBotFont(size: 13)
//        textView.textColor = Labiba._UserInputColors.textColor
        textView.textColor = Labiba.UserInputView.textColor
        placeholderLbl.text = "startSpeakingOrTyping".localForChosnLangCodeBB
        placeholderLbl.font = applyBotFont(size: 13)
      //  placeholderLbl.textColor = Labiba._UserInputColors.hintColor
        placeholderLbl.textColor = Labiba.UserInputView.hintColor
//        sendImageView.tintColor = Labiba._UserInputColors.tintColor
        sendImageView.tintColor = Labiba.UserInputView.tintColor
        //audioVisualizerView.colors = [ UIColor(argb: 0xffffcf01), UIColor(argb: 0xffc61d23)]
        audioVisualizerView.isHidden = true
        // gif
//        floatingBubbleVisualizer.stopAnimation(completionHandler: {})
        // apply semantic
        self.applySemanticAccordingToBotLang()
        self.userInputContainerView.applySemanticAccordingToBotLang()
        
    }
    
    override func draw(_ rect: CGRect) {
        self.userInputContainerView.layer.cornerRadius = userInputContainerView.frame.height/2
    }
    
    func deInitialize() {
      //  speechToTextManager = nil
        speechToTextManager.removerObservers()
    }
    
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChangeKeyboardType(_:)),
                                               name: Constants.NotificationNames.ChangeTextViewKeyboardType, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillhide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
   
    func popUp(on view: UIView) -> Void {
        let root = view
        root.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        var bottomConstant = -5
        switch UIScreen.current {
        case .iPhone6_1 ,.iPhone6_5 ,.iPhone5_8 :
            bottomConstant = -15
        default:
            break
        }
        self.bottomAnchor.constraint(equalTo: root.bottomAnchor, constant: CGFloat(bottomConstant)).isActive = true
        self.leadingAnchor.constraint(equalToSystemSpacingAfter: root.leadingAnchor, multiplier: 1).isActive = true
        self.trailingAnchor.constraint(equalToSystemSpacingAfter: root.trailingAnchor, multiplier: 1).isActive = true
        self.heightAnchor.constraint(greaterThanOrEqualToConstant: VisualizerVoiceAssistantView.INPUT_HEIGHT).isActive = true
    }
    func dismiss() -> Void
       {
           self.removeFromSuperview()
       }
    func resizeInputBox() -> Void
    {
        placeholderLbl.isHidden = !textView.text.isEmpty
        if self.textView.text != nil
        {
            let size = CGSize(width: textView.bounds.width, height: .infinity)
            let estimatedHight = textView.sizeThatFits(size)
            
            if textView.numberOfLines() > 4 {
                textView.isScrollEnabled = true
            }else{
                textView.isScrollEnabled = false
                if estimatedHight.height <= 50 {
                    self.userInputHightConst.constant = 44
                }else{
                    self.userInputHightConst.constant = estimatedHight.height + 10
                }
                //                if estimatedHight.height <= 60 {
                //                    self.hightConsIpad.constant = 55
                //                }else{
                //                    self.hightConsIpad.constant = estimatedHight.height + 10
                //                }
            }
        }
    }
    
    func startRecordingAnimation()  {
        audioVisualizerView.stop()
        DispatchQueue.main.asyncAfter(deadline: .now() + (isAnimating ? 0.2 : 0)) {
            UIView.animate(withDuration: 0.2, animations: {
              //  self.micButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }) { (result) in
                self.audioVisualizerView.isHidden = false
              //  self.micButton.isHidden = true
               // self.keyboardButton.isHidden = true
                self.isAnimating = false
              //  self.micButton.isEnabled = true
            }
        }
        
        isAnimating = true
        audioVisualizerView.start()
    }
        
    @objc func keyboardWillhide(notification: NSNotification)
    {
        print("KB will hide")
       // isUserTyping = false
        Labiba.Temporary_Bot_Type = .visualizer
        self.delegate?.voiceAssistantKeyboardWillHide()
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            userInputExpandedBottonConst.isActive = false
            userInputBottomConst.isActive = true
            UIView.animate(withDuration:  0.3) {
                self.superview?.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification)
    {
        print("KB will show")
       // isUserTyping = true
        Labiba.Temporary_Bot_Type = .keyboardType
        NotificationCenter.default.post(name: Constants.NotificationNames.StopSpeechToText, object: nil)
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.delegate?.voiceAssistantKeyboardWillShow(keyboardHight: keyboardSize.height)
            var newValue = -keyboardSize.height + orginalBottomMargin
            var addedValue:CGFloat = 0
            switch UIScreen.current{
            case .iPhone5_8 ,.iPhone6_1 ,.iPhone6_5:
                addedValue = 20
                newValue += addedValue
            default:
               break
            }
            userInputExpandedBottonConst.constant = keyboardSize.height - addedValue
            userInputBottomConst.isActive = false
            userInputExpandedBottonConst.isActive = true
            UIView.animate(withDuration:  0.3) {
                self.superview?.layoutIfNeeded()
            }
        }
    }
    
    @objc func ChangeKeyboardType(_ sender: Notification)
      {
          let txt = sender.object as? String ?? ""
          textView.isUserInteractionEnabled = true
          sendButton.isEnabled = true
          MaximumCount = 2000
          if txt == "N"
          {
              textView.keyboardType = .numberPad
            //  MaximumCount = 15
              return
          }
          else if txt == "N_CHAR"
          {
              textView.keyboardType = .default
              return
          }
          else if txt == "N_CHAR_AR"
          {
              textView.keyboardType = .default
              return
          }
          else if txt == "CHAR_AR"
          {
              textView.keyboardType = .default
              return
          }
          else if txt == "CHAR"
          {
              textView.keyboardType = .default
              return
          }
          else if txt == "user_phone_number"
          {
              textView.keyboardType = .phonePad
             // MaximumCount = 15
              return
          }
          else if txt == "NUMBER"
          {
              textView.keyboardType = .numberPad
            //  MaximumCount = 15
              return
          }
          else if txt == "user_email"
          {
              textView.keyboardType = .emailAddress
              return
          }
          else if txt == "Disable"
          {
              textView.isUserInteractionEnabled = false
              sendButton.isEnabled = false
              return
          }
          else
          {
              textView.keyboardType = .default
              return
          }
      }
    
    @objc func keyboardWillChangeFrame(notification: NSNotification){
        
       }

    @IBAction func sendAction(_ sender: UIButton) {
        if  let text = self.textView.text , !(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
            self.textView.text = ""
            sendImageView.image = Labiba._KeyboardButtonIcon
            self.resizeInputBox()
            self.delegate?.voiceAssistantKeyboard(self, didSubmitText: text)
            self.textView.endEditing(true)
        }
    }
    
    @IBAction func startRecording(_ sender: UIButton) {
        if self.speechToTextManager.isRecording  {
            NotificationCenter.default.post(name: Constants.NotificationNames.StopSpeechToText, object: nil)
            return
        }
        floatingBubbleVisualizer.stopAnimation {
            self.startRecordingAnimation()
            self.speechToTextManager.start()
        }
    }
}


extension VisualizerVoiceAssistantView:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView)
    {
        let previousImg = sendImageView.image
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            sendImageView.image = Labiba._KeyboardButtonIcon
        }else{
            sendImageView.image = Image(named: sendImage)
        }
        if previousImg != sendImageView.image{
            sendImageView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            UIView.animate(withDuration: 0.2) {
                self.sendImageView.transform = CGAffineTransform.identity
            }
        }
        self.resizeInputBox()
    }
}


extension VisualizerVoiceAssistantView : SpeechToTextDelegate {
    func speechToTextDidStartRecognition() {
        startRecordingAnimation()
    }
    func speechToText(didRecognizeText text: String) {
        
    }
    
    func speechToText(didFinishWithText text: String) {
        delegate?.finishRecognitionWithText(text: text)
        self.audioVisualizerView?.stop()
    }
    
    func speechToText(updateVoicePowerInDB dbPower: Float) {
       // self.audioVisualizerView?.voicePower = CGFloat(dbPower)
    }
    
    func speechToText(didInstallBuffer buffer: AVAudioPCMBuffer) {
      //  let level: Float = -50
        if count == 4 {
            count = 0
            return
        }
        count += 1
        let length: UInt32 = 1024
        buffer.frameLength = length
        let channels = UnsafeBufferPointer(start: buffer.floatChannelData, count: Int(buffer.format.channelCount))
        var value: Float = 0
        vDSP_meamgv(channels[0], 1, &value, vDSP_Length(length))
        var average: Float = ((value == 0) ? -100 : 20.0 * log10f(value))
        if average > 0 {
            average = 0
        } else if average < -100 {
            average = -100
        }
        
        let floats = UnsafeBufferPointer(start: channels[0], count: Int(buffer.frameLength))
        let frame = floats.map({ (f) -> Int in
            return Int(f * Float(Int16.max))
        })
        DispatchQueue.main.async {
            
            let len = self.audioVisualizerView.targetWaveforms.count
            for i in 0 ..< len {
                let idx = ((frame.count - 1) * i) / len
                let f: Float = sqrt(1.5 * abs(Float(frame[idx])) / Float(Int16.max))
                self.audioVisualizerView.targetWaveforms[i] = min(49, Int(f * 50))
            }
            //self.audioVisualizerView.reload()
        }
    }
    
    func speechToTextFinishRecording() {
        DispatchQueue.main.asyncAfter(deadline: .now() + (isAnimating ? 0.2 : 0)) {
            self.audioVisualizerView.isHidden = true
          
            UIView.animate(withDuration: 0.3, animations: {
//                self.micButton.isHidden = false
//                self.micButton.transform = CGAffineTransform(scaleX: 1, y:1)
            }) { (result) in
                self.isAnimating = false
            }
        }
        isAnimating = true
        self.audioVisualizerView?.stop()
        delegate?.didStopRecording()
    }
    
    
}
