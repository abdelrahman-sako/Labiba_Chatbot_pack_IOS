//
//  FeedbackDialog.swift
//  ImagineBot
//
//  Created by AhmeDroid on 10/23/16.
//  Copyright © 2016 Suhayb Al-Absi. All rights reserved.
//

import UIKit
import CoreLocation
import MobileCoreServices
import AVFoundation

//func Image(named: String) -> UIImage?
//{
//
//    let bundle = Bundle(for: UserTextInput.self)
//    return UIImage(named: named, in: bundle, compatibleWith: nil)
//}

@objc protocol UserTextInputDelegate
{

    @objc optional func userTextInputRequiresBottomSize(_ dialog: UserTextInput, withHeight height: CGFloat)

    func userTextInput(_ dialog: UserTextInput, didSubmitText text: String)
    func userTextInput(_ dialog: UserTextInput, didSubmitImage image: UIImage)
    func userTextInput(_ dialog: UserTextInput, didSubmitLocation location: CLLocationCoordinate2D)
    func userTextInput(_ dialog: UserTextInput, didSubmitVoice voice: String)
    func UserTextType(TextType: UITextView)
}

class UserTextInput: UserInput, UITextViewDelegate, LocationSelectViewControllerDelegate
{

    @IBOutlet weak var gradientView: GradientView!
   // var MaximumCount = 2000
    weak var mostTopView = getTheMostTopView()


    class func create() -> UserTextInput
    {

        return UIView.loadFromNibNamedFromDefaultBundle("UserTextInput") as! UserTextInput
    }

    static let HEIGHT: CGFloat = 55

    var delegate: UserTextInputDelegate?

   // @IBOutlet weak var textView: UITextView!
    var placeholderLabel: UILabel!

   // @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var container: UIView!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        let root = getTheMostTopView()!
        let r = root.frame
        let w = r.size.width
        let y = r.size.height
        self.frame = CGRect(x: 0, y: y, width: w, height: UserTextInput.HEIGHT)

//        self.sendButton.tintColor = Labiba._UserInputColors.tintColor
        sendButton.tintColor = Labiba.UserInputView.tintColor

        self.textView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = localString("al-feedback-placeholder")
        placeholderLabel.font = UIFont.systemFont(ofSize: (textView.font?.pointSize)!)
        placeholderLabel.sizeToFit()

        self.textView.textAlignment = LbLanguage.isArabic ? .right : .left
        self.textView.addSubview(placeholderLabel)

        let tvw = self.textView.frame.size.width
        let tvh = self.textView.frame.size.height

        var plr = placeholderLabel.frame
        let ply = (tvh - plr.size.height) / 2

        plr.origin = LbLanguage.isArabic
                ? CGPoint(x: tvw - plr.size.width - 8, y: ply)
                : CGPoint(x: 8, y: ply)

        placeholderLabel.frame = plr
        placeholderLabel.textColor = UIColor(white: 0, alpha: 0.3)
        placeholderLabel.isHidden = !textView.text.isEmpty

        self.gradientView.isHidden = true
        self.gradientView.colors = [
            UIColor(white: 1, alpha: 0),
            UIColor(white: 1, alpha: 0.9),
        ]

        self.gradientView.locations = [0.3, 1]
        self.gradientView.start = CGPoint(x: 0, y: 0)
        self.gradientView.end = CGPoint(x: 0, y: 1)

        self.container.layer.cornerRadius = 22
        sendButton.layer.cornerRadius = 22

        self.container.applyDarkShadow(opacity: 0.2, offset: CGSize(width: 1, height: 1), radius: 2)
        sendButton.applyDarkShadow(opacity: 0.2, offset: CGSize(width: 1, height: 1), radius: 2)

    }

    private var _originY: CGFloat = 0

    func textViewDidChange(_ textView: UITextView)
    {

        self.resizeInputBox()
    }

    func originalFrameY() -> CGFloat
    {
        let insets = topViewC.safeAreaInsets
        return self.frame.origin.y + insets.bottom
    }

    func resizeInputBox() -> Void
    {
        placeholderLabel.isHidden = !textView.text.isEmpty
        if let text = self.textView.text
        {

            let tw = self.textView.frame.size.width - 2
            let font = self.textView.font ?? UIFont.systemFont(ofSize: 15)
            let th = text.heightWithConstrainedWidth(tw, font: font)

            _originY = self.frame.size.height == UserTextInput.HEIGHT ? self.originalFrameY() : _originY

            var ty: CGFloat = 0
            switch th
            {
            case 0..<18:
                ty = UserTextInput.HEIGHT
            case 0..<35.9:
                ty = UserTextInput.HEIGHT + 20
            case 0..<53.8:
                ty = UserTextInput.HEIGHT + 40
            default:
                ty = self.frame.size.height
            }

            self.reconfigure(y: _originY - (ty - UserTextInput.HEIGHT), height: ty)

            let keyboardHeight = self.lastKeyboardFrame?.height ?? 0
            self.delegate?.userTextInputRequiresBottomSize?(self, withHeight: keyboardHeight + ty)
        }
    }

    private let topViewC = getTheMostTopViewController()!

    func reconfigure(y: CGFloat) -> Void
    {
        let insets = topViewC.safeAreaInsets

        var f = self.frame
        f.origin.y = y - insets.bottom
        self.frame = f
    }

    func reconfigure(y: CGFloat, height: CGFloat) -> Void
    {

        let insets = topViewC.safeAreaInsets

        var f = self.frame
        f.origin.y = y - insets.bottom
        f.size.height = height
        self.frame = f
    }

    func popUp() -> Void
    {

        popUp(on: getTheMostTopView())
    }

    func popUp(on view: UIView) -> Void
    {

        let root = view
        root.addSubview(self)

        let ty = root.frame.height - self.frame.size.height

        self.reconfigure(y: ty)
        self.delegate?.userTextInputRequiresBottomSize?(self, withHeight: self.frame.size.height)
       
      

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(ChangeKeyboardType(_:)),
                name: Constants.NotificationNames.ChangeTextViewKeyboardType, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)),
                name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillhide(notification:)),
                name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeKebord(notification:)),
//                                               name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    }

    private var isKeyboardVisible = false


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
        self.gradientView.isHidden = true
        self.isKeyboardVisible = false
        self.lastKeyboardFrame = nil
        self.close()
    }

    @objc func keyboardWillShow(notification: NSNotification)
    {

        print("KB will show")
        //self.delegate?.UserTextType(TextType: textView)
        // self.delegate?.UserTextType(TextType: textView)
        self.isKeyboardVisible = true
        self.processFrame(notification)
        self.gradientView.isHidden = false
    }


    @objc func keyboardWillChangeFrame(notification: NSNotification)
    {

        print("KB will change")

        if self.isKeyboardVisible
        {
            //   self.delegate?.UserTextType(TextType: textView)
            self.processFrame(notification)
        }
    }

    func processFrame(_ notification: NSNotification) -> Void
    {

        if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            self.delegate?.UserTextType(TextType: textView)
            self.resizeView(keyboardFrame: keyboardRect)
        }
    }

    private var lastKeyboardFrame: CGRect?

    func resizeView(keyboardFrame: CGRect) -> Void
    {

        let rframe = getTheMostTopView()!.frame
        let height = self.frame.size.height
        let ty = rframe.height - keyboardFrame.height - height

        self.lastKeyboardFrame = keyboardFrame
        self.delegate?.userTextInputRequiresBottomSize?(self, withHeight: keyboardFrame.height + height)
        self.reconfigure(y: ty)
    }

    @IBAction func submitButtonTapped(_ sender: AnyObject)
    {

        let text = self.textView.text ?? ""
        self.delegate?.userTextInput(self, didSubmitText: text)
        self.textView.text = ""
        self.textView.endEditing(true)
        self.resizeInputBox()
    }

    func close() -> Void
    {

        self.delegate?.userTextInputRequiresBottomSize?(self, withHeight: self.frame.size.height)
        let rframe = getTheMostTopView()!.frame
        let ty = rframe.height - self.frame.size.height

        self.reconfigure(y: ty)
    }

    func locationSelectDidReceiveAddress(_ address: String, atCoordinates coordinates: CLLocationCoordinate2D)
    {

        DispatchQueue.main.async
        {

            self.delegate?.userTextInput(self, didSubmitLocation: coordinates)
        }
    }


}

extension UserTextInput: UIImagePickerControllerDelegate, UINavigationControllerDelegate, DatePickerViewControllerDelegate
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

//func convertAudioToMp4(_ audioURL: URL, completion: @escaping (String?) -> ())
//{
//
//    let avAsset = AVURLAsset(url: audioURL, options: nil)
//    if let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough)
//    {
//
//        let startDate = Date()
//        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let fileUrl = documentsDirectory.appendingPathComponent("converted-audio.ac3")
//        deleteFile(fileUrl)
//
//        exportSession.outputURL = fileUrl
//        exportSession.outputFileType = AVFileType.mp4
//        exportSession.shouldOptimizeForNetworkUse = true
//
//        let start = CMTimeMakeWithSeconds(0.0, 0)
//        let range = CMTimeRangeMake(start, avAsset.duration)
//
//        exportSession.timeRange = range
//        exportSession.exportAsynchronously(completionHandler: {
//
//            switch exportSession.status
//            {
//            case .failed:
//                print(exportSession.error!.localizedDescription)
//                completion(nil);
//            case .completed:
//
//                let endDate = Date()
//                print(endDate.timeIntervalSince(startDate))
//
//                completion(exportSession.outputURL?.path);
//
//            default:
//                completion(nil);
//            }
//        })
//    }
//    else
//    {
//
//        completion(nil);
//    }
//}
//
//func deleteFile(_ fileUrl: URL)
//{
//
//    guard FileManager.default.fileExists(atPath: fileUrl.path)
//    else
//    {
//        return
//    }
//
//    do
//    {
//
//        try FileManager.default.removeItem(atPath: fileUrl.path)
//
//    } catch
//    {
//
//        print("Unable to delete file: \(error.localizedDescription)")
//    }
//}testing.LabibaBotFramework
