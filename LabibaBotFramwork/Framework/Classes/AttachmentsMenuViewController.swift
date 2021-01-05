//
//  AttachmentsMenuViewController.swift
//  LabibaBotClient
//
//  Created by Suhayb Ahmad on 8/14/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//
//arm64 arm64e armv7 armv7s i386 x86_64


import UIKit

enum AttachmentType {
   // case camera
    case photoLibrary
   // case voice
    case calendar
    case file
}

protocol AttachmentsMenuViewControllerDelegate :  class {
    
    func attachmentsMenu( _ menu:AttachmentsMenuViewController, didSelectType type:AttachmentType) ->  Void
    func dismissAttachmentsMenu()
}



class AttachmentsMenuViewController: UIViewController {
    
    static func present(withDelegate delegate:AttachmentsMenuViewControllerDelegate?) -> Void {
        
        if let topVC = getTheMostTopViewController(),
            let attachVC = Labiba.storyboard.instantiateViewController(withIdentifier: "attachMenuVC") as? AttachmentsMenuViewController {
            
            attachVC.delegate = delegate
            attachVC.modalPresentationStyle = .overCurrentContext
            topVC.present(attachVC, animated: false, completion: nil)
        }
    }
    
    
    weak var delegate:AttachmentsMenuViewControllerDelegate?
    let sign:CGFloat = LbLanguage.isArabic ? 1 : -1
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var leadingCons: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.background.alpha = 0
        leadingCons.constant = ipadMargin
        self.background.applySemanticAccordingToBotLang()
        self.background.layoutIfNeeded()
         self.view.layoutIfNeeded()
        for i in 0 ..< self.stackView.arrangedSubviews.count {
            
            let view = self.stackView.arrangedSubviews[i]
            
            view.tintColor = Labiba._AttachmentMenuTintColor 
            view.backgroundColor = Labiba._AttachmentMenuBackgroundColor
            view.layer.cornerRadius = view.frame.height/2
            view.applyDarkShadow(opacity: 0.4, offsetY: 1, radius: 2)
            
            view.transform = CGAffineTransform(translationX: sign * 200, y: 0)
            view.alpha = 0
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
       
        UIView.animate(withDuration: 0.3) {
            self.background.alpha = 1
        }
        
        for i in 0 ..< self.stackView.arrangedSubviews.count {
            
            let s = Double(i)
            let view = self.stackView.arrangedSubviews[i]
            
            UIView.animate(withDuration: 0.5,
                           delay: s * 0.1,
                           usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
                            
                            view.transform = CGAffineTransform.identity
                            view.alpha = 1
                            
            }, completion: nil)
        }
    }
    
    @IBAction func voiceRecognition(_ sender: Any) {
        
       // self.dismissWithType(.voice)
    }
    
    @IBAction func photoLibrarySelected(_ sender: Any) {
        
        self.dismissWithType(.photoLibrary)
    }
    
//    @IBAction func cameraSelected(_ sender: Any) {
//        
//        self.dismissWithType(.camera)
//    }
    
    @IBAction func fileAttachmentSelected(_ sender: UIButton) {
        self.dismissWithType(.file)
    }
    
    @IBAction func backViewDidTap(_ sender: Any) {
        
        self.dismissWithType(nil)
    }
    
    @IBAction func calendarSelected(_ sender: Any) {
        
        self.dismissWithType(.calendar)
    }
    
    func dismissWithType( _ type:AttachmentType? ) -> Void {
        
        UIView.animate(withDuration: 0.3) {
            self.background.alpha = 0
        }
        delegate?.dismissAttachmentsMenu()
        for i in 0 ..< self.stackView.arrangedSubviews.count {
            
            let s = Double(i)
            let view = self.stackView.arrangedSubviews[i]
            
            UIView.animate(withDuration: 0.2, delay: s * 0.1, options: .curveEaseOut, animations: {
                
                view.transform = CGAffineTransform(translationX: self.sign * 200, y: 0)
                view.alpha = 0
                
            }) { (finish) in
                
                if i == (self.stackView.arrangedSubviews.count - 1) {
                    
                    self.dismiss(animated: false, completion: {
                        
                        if let tp = type {
                            self.delegate?.attachmentsMenu(self, didSelectType: tp)
                        }
                    })
                }
            }
        }
    }
}
