//
//  VoiceExperienceView.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman Qasem on 4/26/20.
//  Copyright © 2020 Abdul Rahman. All rights reserved.
//

import UIKit

class VoiceExperienceView: UIView {
    
    class func create() -> VoiceExperienceView
    {
        return Labiba.bundle.loadNibNamed(String(describing: VoiceExperienceView.self), owner: nil, options: nil)![0] as! VoiceExperienceView
    }
    
    //MARK: User Input Outlets
    @IBOutlet weak var placeholderLbl: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var userInputContainerView: UIView!
    @IBOutlet weak var sendImageView: UIImageView!
    @IBOutlet weak var sendButton: UIButton!
    
    
    @IBOutlet weak var swiftyWavesView: SwiftyWaveView!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet var userInputBottomConst: NSLayoutConstraint!
    @IBOutlet var userInputExpandedBottonConst: NSLayoutConstraint!
    @IBOutlet weak var userInputHightConst: NSLayoutConstraint!
    //@IBOutlet weak var previewLbl: UILabel!
    
    var MaximumCount = 2000
    var orginalBottomMargin:CGFloat = 100
    let sendImage = LbLanguage.isArabic ? "ic_send" : "ic_send_r"
    
    
    var delegate:VoiceAssistantKeyboardDelegate?
    let speechToTextManager = SpeechToTextManager.shared
    var isAnimating:Bool = false
    var currentLang:String?
    var userInputMask: CACornerMask = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner ,.layerMinXMaxYCorner ,.layerMinXMinYCorner]
//     var HEIGHT: CGFloat = {
//        switch UIScreen.current {
//        case .iPhone5_8 ,.iPhone6_1 , .iPhone6_5:
//            return 150
//        case .iPhone5_5 :
//            return 140
//        case  .iPad9_7, .iPad10_5 ,.iPad12_9,.ipad:
//            return 120
//        default:
//            return 125
//        }
//    }()
    static var INPUT_HEIGHT: CGFloat  {
           switch UIScreen.current {
           case .ipad ,.iPad10_5 ,.iPad12_9 ,.iPad9_7:
               return 55
           default:
               return 44
           }
       }
    
    var totalHight:CGFloat {
        return VoiceExperienceView.INPUT_HEIGHT + userInputBottomConst.constant
    }
    
    override func awakeFromNib() {
        self.layoutIfNeeded()
        
        addKeyboardObservers()
        self.textView.delegate = self
        speechToTextManager.delegate = self
        
        swiftyWavesView.isHidden = true
        
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
       // textView.textColor = Labiba._UserInputColors.textColor
        textView.textColor = Labiba.UserInputView.textColor
        placeholderLbl.text = "startSpeakingOrTyping".localForChosnLangCodeBB
        placeholderLbl.font = applyBotFont(size: 13)
       // placeholderLbl.textColor = Labiba._UserInputColors.hintColor
        placeholderLbl.textColor = Labiba.UserInputView.hintColor
//        sendImageView.tintColor = Labiba._UserInputColors.tintColor
        sendImageView.tintColor = Labiba.UserInputView.tintColor
        
        micButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        micButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        micButton.layer.shadowRadius = 3
        micButton.layer.shadowOpacity = 3
        
       // previewLbl.font =  applyBotFont(size: 15)
//        micButton.tintColor = Labiba._MicButtonTintColor
//        micButton.backgroundColor = Labiba._MicButtonBackGroundColor
//        micButton.alpha = Labiba._MicButtonAlpha
        
        micButton.tintColor = Labiba.VoiceAssistantView.micButton.tintColor
        micButton.backgroundColor = Labiba.VoiceAssistantView.micButton.backgroundColor
        micButton.alpha = Labiba.VoiceAssistantView.micButton.alpha
        
        backgroundView.applySemanticAccordingToBotLang()
        self.userInputContainerView.applySemanticAccordingToBotLang()
        
       // setNeedsDisplay()
    }
    override func draw(_ rect: CGRect) {
        micButton.layer.cornerRadius = 30 + ipadFactor*5//micButton.frame.height/2
        self.userInputContainerView.layer.cornerRadius = userInputContainerView.frame.height/2
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
    
    
    func popUp(on view: UIView) -> Void
    {
        //        let root = view
        //        let r = root.frame
        //        let w = r.size.width
        //        let y = r.size.height
        //        self.frame = CGRect(x: 0, y: y , width: w, height: HEIGHT )
        //        root.addSubview(self)
        //        let ty = root.frame.height - self.frame.size.height
        //        self.reconfigure(y: ty)
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
        self.leadingAnchor.constraint(equalTo: root.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: root.trailingAnchor).isActive = true
        self.heightAnchor.constraint(greaterThanOrEqualToConstant: VoiceExperienceView.INPUT_HEIGHT).isActive = true
    }
    
    private let topViewC = getTheMostTopViewController()!
    
    func reconfigure(y: CGFloat) -> Void
    {
        let insets = topViewC.additionalSafeAreaInsets
        var f = self.frame
        f.origin.y = y - insets.bottom
        self.frame = f
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
    
    
    func startRecognitionAnimation()  {
        swiftyWavesView?.stop()
        DispatchQueue.main.asyncAfter(deadline: .now() + (isAnimating ? 0.2 : 0)) {
            UIView.animate(withDuration: 0.2, animations: {
                self.micButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }) { (result) in
                self.swiftyWavesView.isHidden = false
                self.micButton.isHidden = true
                self.isAnimating = false
            }
        }
        isAnimating = true
       // previewLbl.alpha = 1
        swiftyWavesView.start()
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
        let text = self.textView.text ?? ""
        self.textView.text = ""
      //  sendImageView.image = Labiba._KeyboardButtonIcon
        sendImageView.image = Labiba.VoiceAssistantView.keyboardButton.icon
        self.resizeInputBox()
        self.delegate?.voiceAssistantKeyboard(self, didSubmitText: text)
        self.textView.endEditing(true)
    }
       
    
    @IBAction func startRecording(_ sender: UIButton) {
        currentLang = nil
        delegate?.didStartSpeechToText()
        startRecognitionAnimation()
        speechToTextManager.start()
    }
    
    
}

extension VoiceExperienceView : SpeechToTextDelegate {
    
    func speechToTextDidStartRecognition() {
        startRecognitionAnimation()
    }
    
    func speechToText(didRecognizeText text: String) {
        print("reco")
        delegate?.didRecognizeText(text: text)
        if currentLang == nil {
            let string:String = text
            currentLang =  string.detectedLangauge()
        }
//        UIView.transition(with: previewLbl, duration: 0.3, options: .transitionCrossDissolve, animations: {
//            self.previewLbl.textAlignment = self.currentLang == "ar" ? .right : .left
//            self.previewLbl.text = text
//        }, completion: nil)
       
    }
    func speechToText(didFinishWithText text: String) {
        delegate?.finishRecognitionWithText(text: text)
        self.swiftyWavesView?.stop()
    }
    
    func speechToText(updateVoicePowerInDB dbPower: Float) {
        self.swiftyWavesView?.voicePower = CGFloat(dbPower)
    }
    func speechToTextFinishRecording() {
       
        DispatchQueue.main.asyncAfter(deadline: .now() + (isAnimating ? 0.2 : 0)) {
            self.swiftyWavesView.isHidden = true
            
            UIView.animate(withDuration: 0.3, animations: {
                self.micButton.isHidden = false
               // self.previewLbl.alpha = 0
                self.micButton.transform = CGAffineTransform(scaleX: 1, y:1)
            }) { (result) in
                //self.previewLbl.text = ""
                self.isAnimating = false
            }
        }
        isAnimating = true
        delegate?.didStopRecording()
    }
}



extension VoiceExperienceView:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView)
    {
        let previousImg = sendImageView.image
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
          //  sendImageView.image = Labiba._KeyboardButtonIcon
            sendImageView.image = Labiba.VoiceAssistantView.keyboardButton.icon
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

