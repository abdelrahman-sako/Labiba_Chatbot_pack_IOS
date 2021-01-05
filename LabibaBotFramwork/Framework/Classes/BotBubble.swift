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
        bubble.considersAvatar = Labiba._botAvatar != nil
        
        bubble.layer.shadowColor = Labiba._botBubbleShadow.shadowColor
        bubble.layer.shadowOffset = Labiba._botBubbleShadow.shadowOffset
        bubble.layer.shadowRadius = Labiba._botBubbleShadow.shadowRadius
        bubble.layer.shadowOpacity = Labiba._botBubbleShadow.shadowOpacity
        bubble.layer.cornerRadius = Labiba._botBubbleCorner
        if SharedPreference.shared.botLangCode == .ar {
            if  !Labiba._botBubbleCornerMask.contains(.layerMinXMinYCorner){
                Labiba._botBubbleCornerMask.insert(.layerMinXMinYCorner)
                Labiba._botBubbleCornerMask.remove(.layerMaxXMinYCorner)
            }
        }else{
            if  !Labiba._botBubbleCornerMask.contains(.layerMaxXMinYCorner){
                Labiba._botBubbleCornerMask.insert(.layerMaxXMinYCorner)
                Labiba._botBubbleCornerMask.remove(.layerMinXMinYCorner)
            }
        }
        bubble.layer.maskedCorners = Labiba._botBubbleCornerMask
      //  bubble.roundCorners(corners: [.allCorners], radius: 20)
        bubble.layer.masksToBounds = false
        bubble.source = .incoming
        bubble.textLabel.textColor = Labiba._botBubbleTextColor 
        bubble.alpha = Labiba._botBubbleAlpha
        if let grad = Labiba._botBubbleBackgroundGradient {
            
            let gview = GradientView(frame: bubble.bounds)
            gview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            gview.setGradient(grad)
            gview.isUserInteractionEnabled = false
            bubble.insertSubview(gview, at: 0)
            
        } else if let bgColor = Labiba._botBubbleBackgroundColor {
            
            bubble.backgroundColor = bgColor
        } else {
            
            bubble.backgroundColor = UIColor.white
            if let root = bubble.subviews.first as? GradientView {
                root.removeFromSuperview()
            }
        }
        
        return bubble
    }
}

