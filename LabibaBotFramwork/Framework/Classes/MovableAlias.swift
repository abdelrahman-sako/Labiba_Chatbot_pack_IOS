//
//  MovableAlias.swift
//  LabibaBotClient_Example
//
//  Created by Suhayb Ahmad on 8/9/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

//import EasyAnimation

class MovableAlias: UIView
{

    @IBOutlet weak var imageView: UIImageView!
    private var vcContainerView = UIView()
    var bubbbleGestureHandler = BubbbleGestureHandler()
    var oldLocation:CGPoint = CGPoint(x: 0, y: 0)
    var convVC:ConversationViewController?
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.layer.cornerRadius = self.frame.height / 2.0
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 4)
        self.layer.shadowRadius = 7
        self.layer.shadowOpacity = 0.3

        self.imageView.layer.cornerRadius = self.imageView.frame.height / 2.0
        self.imageView.clipsToBounds = true

        let rf = UIScreen.main.bounds

        var af = self.frame
        af.origin = CGPoint(x: rf.width / 2.0, y: rf.height)
        self.frame = af

         let panGesture = UIPanGestureRecognizer(target: self, action: #selector( draggedView(_:) ))
          panGesture.cancelsTouchesInView = true

        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(panGesture)
        bubbbleGestureHandler.bubbleView = self
        bubbbleGestureHandler.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
         vcContainerView.roundCorners(corners: [.topLeft, .topRight], radius: 3.0)
    }

    @objc func draggedView(_ sender: UIPanGestureRecognizer)
    {
        if isOpened {
             self.isOpened = false
             self.isReOpened = true
             pauseChatBot()
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                self.vcContainerView.frame = self.frame
                self.vcContainerView.alpha = 0.1
                self.vcContainerView.layer.cornerRadius = self.frame.width / 2.0
            }, completion: { (finish) in
                self.vcContainerView.removeFromSuperview()
                 self.vcContainerView.alpha = 1
            })
        }
        bubbbleGestureHandler.bubbleDidMove(sender)
//        if let superView = self.superview
//        {
//
//            superView.bringSubviewToFront(self)
//
//            let translation = sender.translation(in: superView)
//            let loc = CGPoint(x: self.center.x + translation.x, y: self.center.y + translation.y)
//
//            sender.setTranslation(CGPoint.zero, in: superview)
//
//            UIView.setAnimationBeginsFromCurrentState(true)
//            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
//
//                self.center = loc
//
//            }, completion: nil)
//        }
//        if sender.state == .ended {
//            self.animatedOpening()
//        }
    
    }

    var isShown: Bool = false

    func show(position: CGPoint, animated: Bool) -> Void
    {

        if isShown
        {
            return
        }

        self.imageView.image = Labiba._BubbleChatImage
        getTheMostTopViewController().view.addSubview(self)
        convVC = ConversationViewController.create()
        var af = self.frame
        af.origin = position

        if animated
        {

            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {

                self.frame = af

            }, completion: { (finish) in

                self.isShown = true
            })

        }
        else
        {

            self.frame = af
            self.isShown = true
        }
    }

    var isOpened: Bool = false
    var isReOpened:Bool = false
    @IBAction func aliasDidTap(_ sender: Any)
    {
        if isOpened {
            conversationViewDidDismiss()
            return
        }
        oldLocation = self.center
        animatedOpening()
    }
    
    func animatedOpening(){
        let topView = getTheMostTopView()!
        let f = self.frame
        vcContainerView.backgroundColor = UIColor.white
        vcContainerView.frame = CGRect(x: f.origin.x, y: (f.origin.y + f.height ), width: f.width, height: f.height )
        
        vcContainerView.layer.cornerRadius = self.frame.width / 2.0
        vcContainerView.clipsToBounds = true
        let scaleParam:CGFloat = 10
        var of = self.convert(self.imageView.frame, to: topView)
        of.size = CGSize(width: of.width + scaleParam, height: of.height + scaleParam)
        
        topView.addSubview(self.vcContainerView)
        of.origin = CGPoint(x: LbLanguage.isArabic ? topView.frame.width - of.width - 15 : 15, y: 33)
        
        let bubbleHeightWithOffset = of.origin.y + of.height
        let margine:CGFloat = 5
        let containerFrame = CGRect(x: 0, y: bubbleHeightWithOffset + margine, width: topView.bounds.width , height: topView.bounds.height - bubbleHeightWithOffset - margine  )
        
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.65,
                       initialSpringVelocity: 0, options: [], animations: {
                        self.vcContainerView.layer.cornerRadius = 0
                        self.vcContainerView.frame = containerFrame//topView.bounds
                        self.frame = of
                        self.vcContainerView.roundCorners(corners: [.topLeft , .topRight], radius: 15)
        }, completion: { (finish) in
            
            if let topVC = getTheMostTopViewController()
            {
                guard let convVC = self.convVC else {
                    return
                }
                topVC.addChild(convVC)
             //   convVC.closeHandler = self.conversationViewDidDismiss
                convVC.animatesClosing = false
                //                topVC.present(convVC, animated: false, completion: nil)
                convVC.view.frame = self.vcContainerView.bounds
                self.vcContainerView.addSubview(convVC.backgroundView)
                self.vcContainerView.clipsToBounds = true
                convVC.didMove(toParent: topVC)
                self.isOpened = true
            }
        })
    }

    
    func conversationViewDidDismiss()
    {
        guard let topView = getTheMostTopView() else {
            return
        }
        pauseChatBot()
        isReOpened = false
        topView.bringSubviewToFront(self)
        UIView.animate(withDuration: 0.19, delay: 0, options: .curveEaseIn, animations: {
            self.vcContainerView.frame = self.frame
            self.vcContainerView.layer.cornerRadius = self.frame.width / 2.0
            if let convVC = self.convVC{
                convVC.didMove(toParent: nil)
            }
        }, completion: { (finish) in
            UIView.animate(withDuration: 0.4,
                           delay: 0,
                           usingSpringWithDamping: 0.65,
                           initialSpringVelocity: 0, options: [], animations: {
                            self.center = self.oldLocation
            }, completion: nil)
            self.vcContainerView.removeFromSuperview()
            self.isOpened = false
        })
    }
    
    func pauseChatBot() {
        NotificationCenter.default.post(name: Constants.NotificationNames.StopTextToSpeech,
                                        object: nil)
        NotificationCenter.default.post(name: Constants.NotificationNames.StopSpeechToText,
                                        object: nil)
        NotificationCenter.default.post(name: Constants.NotificationNames.StopMedia,
                                        object: nil)
    }
}

extension MovableAlias: BubbleDeletionDelegate {
    func deleteBubble() {
        self.isShown = false
        self.removeFromSuperview()
        convVC?.backgroundView?.removeFromSuperview()
        self.convVC?.shutDownBotChat()
    }
    
    func reopenBubble() {
        if isReOpened {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                self.animatedOpening()
            }
        }else {
            guard let topView = getTheMostTopView() else {
                return
            }
            let halfWidth = topView.bounds.width/2
            let hight = topView.bounds.height
            UIView.animate(withDuration: 0.4,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0, options: [], animations: {
                            self.center.x = halfWidth <= self.center.x ? halfWidth*2 - 25 :25
                            if self.frame.origin.y < 5 {
                                self.center.y = 40
                            }else if (self.frame.origin.y + self.frame.height) > (hight) {
                                self.center.y = hight - 40
                            }
            }, completion: nil)
        }
    }
    
    
}


