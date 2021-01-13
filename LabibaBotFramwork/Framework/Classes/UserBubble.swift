//
//  BotBubble.swift
//  ImagineBot
//
//  Created by Suhayb Al-Absi on 10/22/16.
//  Copyright © 2016 Suhayb Al-Absi. All rights reserved.
//

import UIKit

//let UserBubbleColor = Labiba._userBubbleBackgroundColor
var UserBubbleColor:UIColor {
    switch  Labiba.UserChatBubble.background {
    case .solid(color: let color):
        return color
    case .gradient(gradientSpecs: let grad):
        return grad.colors[0]
    }
}

class UserBubble: BubbleView
{

    override class func createBubble(withWidth width: CGFloat) -> BubbleView
    {
        
        let bubble = UIView.loadFromNibNamedFromDefaultBundle("UserBubble") as! UserBubble
        bubble.maxWidth = width
        bubble.source = .outgoing
        // bubble.considersAvatar = Labiba._userAvatar != nil
        bubble.considersAvatar = Labiba.UserChatBubble.avatar != nil
        //bubble.textLabel.textColor = Labiba._userBubbleTextColor
        bubble.textLabel.textColor = Labiba.UserChatBubble.textColor
        // bubble.layer.cornerRadius = Labiba._userBubbleCorner
        bubble.layer.cornerRadius = Labiba.UserChatBubble.cornerRadius
        if SharedPreference.shared.botLangCode == .ar {
            //            if  !Labiba._userBubbleCornerMask.contains(.layerMaxXMinYCorner){
            //                Labiba._userBubbleCornerMask.insert(.layerMaxXMinYCorner)
            //                Labiba._userBubbleCornerMask.remove(.layerMinXMinYCorner)
            if  !Labiba.UserChatBubble.CornerMask.contains(.layerMaxXMinYCorner){
                Labiba.UserChatBubble.CornerMask.insert(.layerMaxXMinYCorner)
                Labiba.UserChatBubble.CornerMask.remove(.layerMinXMinYCorner)
            }
        }else{
            //  if  !Labiba._userBubbleCornerMask.contains(.layerMinXMinYCorner){
            //                Labiba._userBubbleCornerMask.insert(.layerMinXMinYCorner)
            //                Labiba._userBubbleCornerMask.remove(.layerMaxXMinYCorner)
            if  !Labiba.UserChatBubble.CornerMask.contains(.layerMinXMinYCorner){
                Labiba.UserChatBubble.CornerMask.insert(.layerMinXMinYCorner)
                Labiba.UserChatBubble.CornerMask.remove(.layerMaxXMinYCorner)
            }
        }
        // bubble.layer.maskedCorners = Labiba._userBubbleCornerMask
        bubble.layer.maskedCorners = Labiba.UserChatBubble.CornerMask
        //bubble.alpha = Labiba._userBubbleAlpha
        bubble.alpha = Labiba.UserChatBubble.alpha
        //        if let grad = Labiba._userBubbleBackgroundGradient
//        {
//
//            let gview = GradientView(frame: bubble.bounds)
//            gview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//            gview.setGradient(grad)
//            gview.isUserInteractionEnabled = false
//            bubble.insertSubview(gview, at: 0)
//
//
//        }
//        else
//        {
//
//            bubble.backgroundColor =  Labiba._userBubbleBackgroundColor
//        }
        switch Labiba.UserChatBubble.background {
        case .solid(color: let color):
            bubble.backgroundColor = color
        case .gradient(gradientSpecs: let gradientSpec):
            let gview = GradientView(frame: bubble.bounds)
            gview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            gview.setGradient(gradientSpec)
            gview.isUserInteractionEnabled = false
            bubble.insertSubview(gview, at: 0)
        }

        return bubble
    }
}
