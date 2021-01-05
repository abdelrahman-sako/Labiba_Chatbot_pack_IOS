//
//  ImagePicking.swift
//  LabibaBotClient
//
//  Created by Suhayb Ahmad on 10/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

protocol ImageSelectorDelegate: class
{
    func imageSelectorDidSelectImage(_ image: UIImage, fromSource source: UIImagePickerController.SourceType) -> Void
}

class ImageSelector: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{

    static let shared = ImageSelector()

    private override init()
    {
        
    }

    private var currentSource: UIImagePickerController.SourceType?
    private weak var currentDelegate: ImageSelectorDelegate?

    func launch<Type: UIViewController & ImageSelectorDelegate>(onView vc: Type, source: UIImagePickerController.SourceType, allowEditing: Bool = false) -> Void
    {

        if UIImagePickerController.isSourceTypeAvailable(source)
        {

            self.currentSource = source
            self.currentDelegate = vc

            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = source
            imagePicker.allowsEditing = allowEditing
            //UIApplication.shared.setStatusBarColor(color: .clear)
            vc.present(imagePicker, animated: true, completion: nil)
        }
        else
        {

            let errorMsg = source == .camera ? "camera-inaccessible".local : "library-inaccessible".local
            showErrorMessage(errorMsg)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {

        self.currentSource = nil
        self.currentDelegate = nil
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any])
    {

        let key: String = picker.allowsEditing ? UIImagePickerController.InfoKey.editedImage.rawValue : UIImagePickerController.InfoKey.originalImage.rawValue

        if let image = info[key] as? UIImage
        {
            self.currentDelegate?.imageSelectorDidSelectImage(image, fromSource: self.currentSource!)
        }

        self.currentSource = nil
        self.currentDelegate = nil
        picker.dismiss(animated: true, completion: nil)
    }
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let key: String = picker.allowsEditing ? UIImagePickerController.InfoKey.editedImage.rawValue : UIImagePickerController.InfoKey.originalImage.rawValue
        
        if let image = info[.editedImage] as? UIImage
        {
            self.currentDelegate?.imageSelectorDidSelectImage(image, fromSource: self.currentSource!)
        }
        
        self.currentSource = nil
        self.currentDelegate = nil
        picker.dismiss(animated: true, completion: nil)
   
    
    }
}

