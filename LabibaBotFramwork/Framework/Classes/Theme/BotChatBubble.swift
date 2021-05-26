//
//  BotChatBubble.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman Qasem on 1/12/21.
//  Copyright © 2021 Abdul Rahman. All rights reserved.
//

import Foundation
import UIKit

public class LabibaBotChatBubble {
    public var typingIndicatorColor:UIColor = UIColor.gray
    public var background:LabibaBackground = .solid(color:#colorLiteral(red: 0.03137254902, green: 0.3725490196, blue: 1, alpha: 1))
    public var textColor:UIColor = UIColor.black
    public var fontsize:CGFloat = 13 // no wight since bubble font deped on the HTML style
    public var textAlignment:NSTextAlignment?
    public var alpha:CGFloat = 1
    public var cornerRadius:CGFloat = 10
    public var cornerMaskPin:LabibaCornerPin = .none{
        didSet{
            switch cornerMaskPin {
            case .up:
                cornerMask = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner,.layerMaxXMinYCorner]
            case .down:
                cornerMask = [.layerMaxXMaxYCorner,.layerMinXMinYCorner,.layerMaxXMinYCorner]
            case .none:
                cornerMask = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner ,.layerMinXMaxYCorner ,.layerMinXMinYCorner]
            }
        }
    }
    public var cornerMask: CACornerMask = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner ,.layerMinXMaxYCorner ,.layerMinXMinYCorner]
    public var shadow:LabibaShadowModel = LabibaShadowModel(shadowColor: UIColor.clear.cgColor, shadowOffset: .zero, shadowRadius: 0, shadowOpacity: 0)
    public var avatar:UIImage?
    
    public var timestamp:(fontSize:CGFloat,color:UIColor,formate:String) = (9,.gray,"h:mm a")
    
}
