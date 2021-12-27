//
//  UserTextInputNoLocalNoLocal.swift
//  DubaiPoliceBotFramework
//
//  Created by Yehya Titi on 5/2/19.
//  Copyright © 2019 Yehya Titi. All rights reserved.
//

import UIKit
import CoreLocation
import MobileCoreServices
import AVFoundation
enum keyboardEvents{
    case willShow
    case willHide
}
func Image(named: String) -> UIImage?
{
    
    let bundle = Bundle(for: UserTextInputNoLocal.self)
    return UIImage(named: named, in: bundle, compatibleWith: nil)
}

@objc protocol UserTextInputNoLocalDelegate
{
    
    @objc optional func userTextInputRequiresBottomSize(_ dialog: UserTextInputNoLocal, withHeight height: CGFloat)
    
    func userTextInput(_ dialog: UserTextInputNoLocal, didSubmitText text: String)
    func userTextInput(_ dialog: UserTextInputNoLocal, didSubmitImage image: UIImage)
    func userTextInput(_ dialog: UserTextInputNoLocal, didSubmitFile Url: URL)
    func userTextInput(_ dialog: UserTextInputNoLocal, didSubmitLocation location: CLLocationCoordinate2D)
    func userTextInput(_ dialog: UserTextInputNoLocal, didSubmitVoice voice: String)
    func UserTextType(TextType: UITextView)
    func keyboardWillShow( notification:NSNotification)
    func keyboardWillHide( notification:NSNotification)
    func changeFromKeybordToVoiceType()
}

class UserTextInputNoLocal: UserInput, UITextViewDelegate, LocationSelectViewControllerDelegate , AttachmentsMenuViewControllerDelegate, UIDocumentPickerDelegate
{
   
    
    
    
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var requestAttachmentButton: UIButton!
    @IBOutlet weak var hightConsIpad: NSLayoutConstraint!
    @IBOutlet weak var heightCons: NSLayoutConstraint!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var sideMarginsCons: [NSLayoutConstraint]!
    
  //  var MaximumCount = 2000
    weak var rootView = getTheMostTopView()
    
    
    class func create() -> UserTextInputNoLocal
    {
         let podBundle = Bundle(for: ConversationViewController.self)
         return podBundle.loadNibNamed(String(describing: UserTextInputNoLocal.self), owner: nil, options: nil)![0] as! UserTextInputNoLocal
       //original //  return UIView.loadFromNibNamedFromDefaultBundle("UserTextInputNoLocal") as! UserTextInputNoLocal
    }
    
    static var HEIGHT: CGFloat  {
        switch UIScreen.current {
        case .ipad ,.iPad10_5 ,.iPad12_9 ,.iPad9_7:
            return 55
        default:
            return 44
        }
    }
    
    
    var delegate: UserTextInputNoLocalDelegate?
    
   // @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    
   // @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var container: UIView!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.layoutIfNeeded()
        if Labiba.Bot_Type == .voiceAndKeyboard || Labiba.Bot_Type == .voiceToVoice {
            micButton.isHidden = false
        }else{
            micButton.isHidden = true
        }
        sideMarginsCons.forEach { (cons) in
            cons.constant += (ipadMargin - cons.constant)*ipadFactor
        }
//        container.backgroundColor = Labiba._UserInputColors.background
//        textView.textColor = Labiba._UserInputColors.textColor
//        self.sendButton.tintColor = Labiba._SendButtonTintColor
//        self.sendButton.backgroundColor = Labiba._SendButtonBackgroundColor ?? .white
        
        container.backgroundColor = Labiba.UserInputView.backgroundColor
        textView.textColor = Labiba.UserInputView.textColor
        self.sendButton.tintColor = Labiba.UserInputView.sendButton.tintColor
        self.sendButton.backgroundColor = Labiba.UserInputView.sendButton.backgroundColor
        
        self.textView.delegate = self
        placeholderLabel.text = ""//"al-feedback-placeholder".localBasedOnChoosenLangCode
        placeholderLabel.font = applyBotFont(size: textView.font?.pointSize ?? 13)//UIFont.systemFont(ofSize: (textView.font?.pointSize)!)
       // placeholderLabel.sizeToFit()
        
        //self.textView.textAlignment = LbLanguage.isArabic ? .right : .left
        self.textView.font = applyBotFont(size: 13)
        self.textView.addSubview(placeholderLabel)
        
//        placeholderLabel.textColor = Labiba._UserInputColors.hintColor//UIColor(white: 0, alpha: 0.3)
        placeholderLabel.textColor = Labiba.UserInputView.textColor
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        
      
        requestAttachmentButton.tintColor = Labiba.UserInputView.attachmentButton.tintColor
        requestAttachmentButton.setImage(Labiba.UserInputView.attachmentButton.icon, for: .normal)
        requestAttachmentButton.isHidden = Labiba.UserInputView.attachmentButton.isHidden
//        self.micButton.tintColor = Labiba._UserInputColors.tintColor
        self.micButton.tintColor = Labiba.UserInputView.tintColor
        self.container.applyDarkShadow(opacity: 0.2, offset: CGSize(width: 1, height: 1), radius: 2)
        self.sendButton.applyDarkShadow(opacity: 0.2, offset: CGSize(width: 1, height: 1), radius: 2)
        self.applySemanticAccordingToBotLang()
        self.container.applySemanticAccordingToBotLang()
        self.stackView.applySemanticAccordingToBotLang()
        if SharedPreference.shared.botLangCode == .ar {
           sendButton.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
      
        setNeedsDisplay()
        
    }
    
    override func draw(_ rect: CGRect) {
        print("draw" , self.sendButton.frame.height/2)
        self.container.layer.cornerRadius = self.sendButton.frame.height/2
        self.sendButton.layer.cornerRadius = self.sendButton.frame.height/2
    }
 
    
    @IBAction func requestAttachment(_ sender: Any) {
        
        AttachmentsMenuViewController.present(withDelegate: self )
        animateAttachmentButton(withImage: Image(named: "baseline_cancel_black_24pt"))
        //requestAttachmentButton.setImage(Image(named: "baseline_cancel_black_24pt"), for: .normal)
    }
    
    func attachmentsMenu(_ menu: AttachmentsMenuViewController, didSelectType type: AttachmentType) {
        let topVC:UIViewController = getTheMostTopViewController()
        
        switch type {
//        case .camera:
//
//            if UIImagePickerController.isSourceTypeAvailable(.camera) {
//
//                let imagePicker = UIImagePickerController()
//                imagePicker.delegate = self
//                imagePicker.sourceType = .camera
//                imagePicker.allowsEditing = false
//
//                topVC.present(imagePicker, animated: true, completion: nil)
//            } else {
//
//                showErrorMessage("camera-inaccessible".local)
//            }
            
        case .photoLibrary:
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {

                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = false

                topVC.present(imagePicker, animated: true, completion: nil)
            } else {

                showErrorMessage("library-inaccessible".local)
            }
//        case .location:
//            break
//           // LocationSelectViewController.present(withDelegate: self)
            
        case .calendar:
            
            DatePickerViewController.present(withDelegate: self, mode: .date)
            
        case .file:
            let topVC = getTheMostTopViewController()
            let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypePDF].map({ $0 as String }), in: .import)
                       documentPicker.delegate = self
            topVC?.present(documentPicker, animated: true, completion: nil)
        }
       
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        controller.dismiss(animated: true, completion: nil)
        //self.delegate?.userTextInput(<#T##dialog: UserTextInputNoLocal##UserTextInputNoLocal#>, didSubmitFile: <#T##URL#>)
    }
    
    func dismissAttachmentsMenu() {
       // requestAttachmentButton.setImage(Image(named: "ic_more_vert_black_24pt"), for: .normal)
        animateAttachmentButton(withImage: Labiba.UserInputView.attachmentButton.icon)
    }
    
    func animateAttachmentButton(withImage image:UIImage?)  {
        UIView.animate(withDuration: 0.15, animations: {
            self.requestAttachmentButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        }) { (result) in
            self.requestAttachmentButton.setImage(image, for: .normal)
            UIView.animate(withDuration: 0.15, animations: {
                 self.requestAttachmentButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
            
        }
    }
    
    
    
    
    
   // private var _originY: CGFloat = 0
    
    func textViewDidChange(_ textView: UITextView)
    {
      self.resizeInputBox()
    }
    
//    func originalFrameY() -> CGFloat
//    {
//        let insets = topViewC.safeAreaInsets
//        return self.frame.origin.y + insets.bottom
//    }
    
    
    
    func resizeInputBox() -> Void
    {
        placeholderLabel.isHidden = !textView.text.isEmpty
        if let text = self.textView.text
        {
            
            let size = CGSize(width: textView.bounds.width, height: .infinity)
            let estimatedHight = textView.sizeThatFits(size)
            
            if textView.numberOfLines() > 4 {
                textView.isScrollEnabled = true
            }else{
                textView.isScrollEnabled = false
                if estimatedHight.height <= 50 {
                  self.heightCons.constant = 44
                }else{
                self.heightCons.constant = estimatedHight.height + 10
                }
                if estimatedHight.height <= 60 {
                  self.hightConsIpad.constant = 55
                }else{
                self.hightConsIpad.constant = estimatedHight.height + 10
                }
            }
            
            return

        }
    }
    
    private let topViewC = getTheMostTopViewController()!
    

    func popUp() -> Void
    {
        
        popUp(on: getTheMostTopView())
    }
    
    func popUp(on view: UIView) -> Void
    {
        
        let root = view
//        let r = root.frame
//        let w = r.size.width
//        let y = r.size.height
//        self.frame = CGRect(x: 0, y: y, width: w, height: UserTextInputNoLocal.HEIGHT)
//        rootView = root
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
        self.heightAnchor.constraint(greaterThanOrEqualToConstant: UserTextInputNoLocal.HEIGHT).isActive = true
        micButtonAnimation()
       
//        let ty = root.frame.height - self.frame.size.height
//
//        self.reconfigure(y: ty)
//        self.delegate?.userTextInputRequiresBottomSize?(self, withHeight: self.frame.size.height)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChangeKeyboardType(_:)),
                                               name: Constants.NotificationNames.ChangeTextViewKeyboardType, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillhide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeKebord(notification:)),
        //                                               name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
    }
    
    func micButtonAnimation()  {
        if Labiba.Bot_Type == .voiceAndKeyboard ||  Labiba.Bot_Type == .voiceToVoice {
            let sign:CGFloat = LbLanguage.isArabic ? -1 : 1
            self.micButton.transform = CGAffineTransform(translationX: (screenWidth / 2  - 55) * sign , y: 0)
            self.placeholderLabel.alpha = 0
            UIView.animate(withDuration: 0.4, animations: {
                self.micButton.transform = CGAffineTransform.identity
                self.micButton.backgroundColor = .clear
                //self.micButton.tintColor = Labiba._UserInputColors.tintColor
                self.micButton.tintColor = Labiba.UserInputView.tintColor
            })
            UIView.animate(withDuration: 0.6, animations: {
                self.placeholderLabel.alpha = 1
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
               
                self.textView.becomeFirstResponder()
                
            }
        }
    }
    
    
    func dismiss() -> Void
    {
        self.removeFromSuperview()
    }
    
    private var isKeyboardVisible = false
    
//    @objc func ChangeKeyboardType(_ sender: Notification)
//    {
//        let txt = sender.object as? String ?? ""
//        textView.isUserInteractionEnabled = true
//        sendButton.isEnabled = true
//        MaximumCount = 2000
//        if txt == "N"
//        {
//            textView.keyboardType = .numberPad
//          //  MaximumCount = 15
//            return
//        }
//        else if txt == "N_CHAR"
//        {
//            textView.keyboardType = .default
//            return
//        }
//        else if txt == "N_CHAR_AR"
//        {
//            textView.keyboardType = .default
//            return
//        }
//        else if txt == "CHAR_AR"
//        {
//            textView.keyboardType = .default
//            return
//        }
//        else if txt == "CHAR"
//        {
//            textView.keyboardType = .default
//            return
//        }
//        else if txt == "user_phone_number"
//        {
//            textView.keyboardType = .phonePad
//           // MaximumCount = 15
//            return
//        }
//        else if txt == "NUMBER"
//        {
//            textView.keyboardType = .numberPad
//          //  MaximumCount = 15
//            return
//        }
//        else if txt == "user_email"
//        {
//            textView.keyboardType = .emailAddress
//            return
//        }
//        else if txt == "Disable"
//        {
//            textView.isUserInteractionEnabled = false
//            sendButton.isEnabled = false
//            return
//        }
//        else
//        {
//            textView.keyboardType = .default
//            return
//        }
//    }
//
    //    func textView(_ textView: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    //    {
    //        let characterLimit = MaximumCount
    //        let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: string)
    //        let numberOfChars = newText.count
    //        return numberOfChars < characterLimit
    //    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        let characterLimit = MaximumCount
        let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < characterLimit
    }
    
    @objc func keyboardWillhide(notification: NSNotification)
    {
        
        print("KB will hide")
        self.delegate?.keyboardWillHide(notification: notification)
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3) {
                self.transform = CGAffineTransform.identity
            }
            
        }
        //self.gradientView.isHidden = true
        self.isKeyboardVisible = false
        self.lastKeyboardFrame = nil
        self.close()
    }
    
    @objc func keyboardWillShow(notification: NSNotification)
    {
        
        print("KB will show")
        //self.delegate?.UserTextType(TextType: textView)
        // self.delegate?.UserTextType(TextType: textView)
       self.delegate?.keyboardWillShow(notification: notification)
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3) {
                switch UIScreen.current{
                case .iPhone5_8 ,.iPhone6_1 ,.iPhone6_5:
                    self.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height + 20)
                default:
                    self.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height + 5)
                }
                
            }
            
        }
        self.isKeyboardVisible = true
        
       // self.processFrame(notification)
       // self.gradientView.isHidden = false
        
    }
    
    
    @objc func keyboardWillChangeFrame(notification: NSNotification)
    {
        
        print("KB will change")
        
        if self.isKeyboardVisible
        {
            //   self.delegate?.UserTextType(TextType: textView)
           // self.processFrame(notification)
        }
    }
    
//    func processFrame(_ notification: NSNotification) -> Void
//    {
//        
//        if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
//        {
//            self.delegate?.UserTextType(TextType: textView)
//            self.resizeView(keyboardFrame: keyboardRect)
//        }
//    }
//    
    private var lastKeyboardFrame: CGRect?
    
//    func resizeView(keyboardFrame: CGRect) -> Void
//    {
//
//        let rframe = getTheMostTopView()!.frame
//        let height = self.frame.size.height
//        let ty = rframe.height - keyboardFrame.height - height
//
//        self.lastKeyboardFrame = keyboardFrame
//        self.delegate?.userTextInputRequiresBottomSize?(self, withHeight: keyboardFrame.height + height)
//        self.reconfigure(y: ty)
//    }
    
    @IBAction func submitButtonTapped(_ sender: AnyObject)
    {
        
        let text = self.textView.text ?? ""
        self.textView.text = ""
        self.resizeInputBox()
        self.delegate?.userTextInput(self, didSubmitText: text)
        self.textView.endEditing(true)
        
    }
    
    @IBAction func voiceAssistanceAction(_ sender: Any) {
        self.textView.endEditing(true)
        delegate?.changeFromKeybordToVoiceType()
        if Labiba.Bot_Type == .voiceToVoice {
            Labiba.setEnableTextToSpeech(enable: true)
        }
    }
    func close() -> Void
    {
        
        self.delegate?.userTextInputRequiresBottomSize?(self, withHeight: self.frame.size.height)
//        let rframe = rootView!.frame
//        let ty = rframe.height - self.frame.size.height
//
//        self.reconfigure(y: ty)
    }
    
    func locationSelectDidReceiveAddress(_ address: String, atCoordinates coordinates: CLLocationCoordinate2D)
    {
        
        DispatchQueue.main.async
            {
                
                self.delegate?.userTextInput(self, didSubmitLocation: coordinates)
        }
    }
    
    
}

extension UserTextInputNoLocal: UIImagePickerControllerDelegate, UINavigationControllerDelegate, DatePickerViewControllerDelegate
{
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any])
    {
        
        DispatchQueue.main.async
            {
                if let image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage
                {
                    self.delegate?.userTextInput(self, didSubmitImage: image)
                }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        DispatchQueue.main.async
            {
                if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage  {
                    self.delegate?.userTextInput(self, didSubmitImage: image)
                }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func datePickerControllerDidClearSelection(_ datePickerVC: DatePickerViewController)
    {
    }
    
    func datePickerController(_ datePickerVC: DatePickerViewController, didSelectDate selectedDate: Date)
    {
        
        DispatchQueue.main.async
            {
                
                let df = DateFormatter()
                df.locale = Locale(identifier: "en_US")
                df.dateFormat = "MM-dd-yyyy"
                self.delegate?.userTextInput(self, didSubmitText: df.string(from: selectedDate))
        }
    }
}

func convertAudioToMp4(_ audioURL: URL, completion: @escaping (String?) -> ())
{
    
    let avAsset = AVURLAsset(url: audioURL, options: nil)
    if let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough)
    {
        
        let startDate = Date()
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileUrl = documentsDirectory.appendingPathComponent("converted-audio.ac3")
        deleteFile(fileUrl)
        
        exportSession.outputURL = fileUrl
        exportSession.outputFileType = AVFileType.mp4
        exportSession.shouldOptimizeForNetworkUse = true
        
        let start = CMTimeMakeWithSeconds(0.0, preferredTimescale: 0)
        let range = CMTimeRangeMake(start: start, duration: avAsset.duration)
        
        exportSession.timeRange = range
        exportSession.exportAsynchronously(completionHandler: {
            
            switch exportSession.status
            {
            case .failed:
                print(exportSession.error!.localizedDescription)
                completion(nil);
            case .completed:
                
                let endDate = Date()
                print(endDate.timeIntervalSince(startDate))
                
                completion(exportSession.outputURL?.path);
                
            default:
                completion(nil);
            }
        })
    }
    else
    {
        
        completion(nil);
    }
}

func deleteFile(_ fileUrl: URL)
{
    
    guard FileManager.default.fileExists(atPath: fileUrl.path)
        else
    {
        return
    }
    
    do
    {
        
        try FileManager.default.removeItem(atPath: fileUrl.path)
        
    } catch
    {
        
        print("Unable to delete file: \(error.localizedDescription)")
    }
}


