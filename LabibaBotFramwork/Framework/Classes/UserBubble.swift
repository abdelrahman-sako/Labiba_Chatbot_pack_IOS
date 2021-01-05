//
//  BotBubble.swift
//  ImagineBot
//
//  Created by Suhayb Al-Absi on 10/22/16.
//  Copyright © 2016 Suhayb Al-Absi. All rights reserved.
//

import UIKit

let UserBubbleColor = Labiba._userBubbleBackgroundColor

class UserBubble: BubbleView
{

    override class func createBubble(withWidth width: CGFloat) -> BubbleView
    {

        let bubble = UIView.loadFromNibNamedFromDefaultBundle("UserBubble") as! UserBubble
        bubble.maxWidth = width
        bubble.source = .outgoing
        bubble.considersAvatar = Labiba._userAvatar != nil
        bubble.textLabel.textColor = Labiba._userBubbleTextColor
        bubble.layer.cornerRadius = Labiba._userBubbleCorner
        if SharedPreference.shared.botLangCode == .ar {
            if  !Labiba._userBubbleCornerMask.contains(.layerMaxXMinYCorner){
                Labiba._userBubbleCornerMask.insert(.layerMaxXMinYCorner)
                Labiba._userBubbleCornerMask.remove(.layerMinXMinYCorner)
            }
        }else{
            if  !Labiba._userBubbleCornerMask.contains(.layerMinXMinYCorner){
                Labiba._userBubbleCornerMask.insert(.layerMinXMinYCorner)
                Labiba._userBubbleCornerMask.remove(.layerMaxXMinYCorner)
            }
        }
        bubble.layer.maskedCorners = Labiba._userBubbleCornerMask
        bubble.alpha = Labiba._userBubbleAlpha
        if let grad = Labiba._userBubbleBackgroundGradient
        {

            let gview = GradientView(frame: bubble.bounds)
            gview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            gview.setGradient(grad)
            gview.isUserInteractionEnabled = false
            bubble.insertSubview(gview, at: 0)
            

        }
        else
        {

            bubble.backgroundColor =  Labiba._userBubbleBackgroundColor
        }
//        else
//        {
//
//            bubble.backgroundColor = Labiba._tintColor
//            if let root = bubble.subviews.first as? GradientView
//            {
//                root.removeFromSuperview()
//            }
//        }

        return bubble
    }
}
