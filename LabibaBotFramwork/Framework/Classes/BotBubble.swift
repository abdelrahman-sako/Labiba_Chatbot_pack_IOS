//
//  BotBubble.swift
//  ImagineBot
//
//  Created by Suhayb Al-Absi on 10/22/16.
//  Copyright © 2016 Suhayb Al-Absi. All rights reserved.
//

import UIKit

let BotBubbleColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

public class BotBubble: BubbleView {
    
    override class func createBubble(withWidth width:CGFloat) -> BubbleView {
       
        let bubble = UIView.loadFromNibNamedFromDefaultBundle("BotBubble") as! BotBubble
        bubble.maxWidth = width
       // bubble.considersAvatar = Labiba._botAvatar != nil
        bubble.considersAvatar = Labiba.BotChatBubble.avatar != nil
        
//        bubble.layer.shadowColor = Labiba._botBubbleShadow.shadowColor
//        bubble.layer.shadowOffset = Labiba._botBubbleShadow.shadowOffset
//        bubble.layer.shadowRadius = Labiba._botBubbleShadow.shadowRadius
//        bubble.layer.shadowOpacity = Labiba._botBubbleShadow.shadowOpacity
        bubble.layer.shadowColor = Labiba.BotChatBubble.shadow.shadowColor
        bubble.layer.shadowOffset = Labiba.BotChatBubble.shadow.shadowOffset
        bubble.layer.shadowRadius = Labiba.BotChatBubble.shadow.shadowRadius
        bubble.layer.shadowOpacity = Labiba.BotChatBubble.shadow.shadowOpacity
        
        //bubble.layer.cornerRadius = Labiba._botBubbleCorner
        bubble.layer.cornerRadius = Labiba.BotChatBubble.cornerRadius
        if SharedPreference.shared.botLangCode == .ar {
            switch Labiba.BotChatBubble.cornerMaskPin {
            case .up:
                Labiba.BotChatBubble.cornerMask.insert(.layerMinXMinYCorner)
                Labiba.BotChatBubble.cornerMask.remove(.layerMaxXMinYCorner)
            case .down:
                Labiba.BotChatBubble.cornerMask.insert(.layerMinXMaxYCorner)
                Labiba.BotChatBubble.cornerMask.remove(.layerMaxXMaxYCorner)
            case .none:
                break
            }
//            if  !Labiba.BotChatBubble.cornerMask.contains(.layerMinXMinYCorner){
//                Labiba.BotChatBubble.cornerMask.insert(.layerMinXMinYCorner)
//                Labiba.BotChatBubble.cornerMask.remove(.layerMaxXMinYCorner)
//            }
        }else{
            switch Labiba.BotChatBubble.cornerMaskPin {
            case .up:
                Labiba.BotChatBubble.cornerMask.remove(.layerMinXMinYCorner)
                Labiba.BotChatBubble.cornerMask.insert(.layerMaxXMinYCorner)
            case .down:
                Labiba.BotChatBubble.cornerMask.remove(.layerMinXMaxYCorner)
                Labiba.BotChatBubble.cornerMask.insert(.layerMaxXMaxYCorner)
            case .none:
                break
            }
//                if  !Labiba.BotChatBubble.cornerMask.contains(.layerMaxXMinYCorner){
//                    Labiba.BotChatBubble.cornerMask.insert(.layerMaxXMinYCorner)
//                    Labiba.BotChatBubble.cornerMask.remove(.layerMinXMinYCorner)
//            }
        }
      //  bubble.layer.maskedCorners = Labiba._botBubbleCornerMask
        bubble.layer.maskedCorners = Labiba.BotChatBubble.cornerMask
      //  bubble.roundCorners(corners: [.allCorners], radius: 20)
        bubble.layer.masksToBounds = false
        bubble.source = .incoming
       // bubble.textLabel.textColor = Labiba._botBubbleTextColor
        bubble.textLabel.textColor = Labiba.BotChatBubble.textColor
       // bubble.alpha = Labiba._botBubbleAlpha
        bubble.alpha = Labiba.BotChatBubble.alpha
//        if let grad = Labiba._botBubbleBackgroundGradient {
//
//            let gview = GradientView(frame: bubble.bounds)
//            gview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//            gview.setGradient(grad)
//            gview.isUserInteractionEnabled = false
//            bubble.insertSubview(gview, at: 0)
//
//        } else if let bgColor = Labiba._botBubbleBackgroundColor {
//
//            bubble.backgroundColor = bgColor
//        } else {
//
//            bubble.backgroundColor = UIColor.white
//            if let root = bubble.subviews.first as? GradientView {
//                root.removeFromSuperview()
//            }
//        }
        switch Labiba.BotChatBubble.background {
        case .solid(color: let color):
            bubble.backgroundColor = color
        case .gradient(gradientSpecs: let grad):
            let gview = GradientView(frame: bubble.bounds)
            gview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            gview.setGradient(grad)
            gview.isUserInteractionEnabled = false
            bubble.insertSubview(gview, at: 0)
        }
        
        return bubble
    }
}

