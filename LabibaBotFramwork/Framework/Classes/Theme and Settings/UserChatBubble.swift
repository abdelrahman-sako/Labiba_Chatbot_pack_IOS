//
//  UserChatBubble.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman Qasem on 1/12/21.
//  Copyright © 2021 Abdul Rahman. All rights reserved.
//

import Foundation
import UIKit

public class LabibaUserChatBubble {
    
    public var background:LabibaBackground = .solid(color:#colorLiteral(red: 0.03137254902, green: 0.3725490196, blue: 1, alpha: 1))
    public var textColor:UIColor = UIColor.gray
    public var fontsize:CGFloat = 13 // no wight since bubble font deped on the HTML style
    public var alpha:CGFloat = 1
    public var cornerRadius:CGFloat = 10
    public var cornerMaskPin:LabibaCornerPin = .none{
        didSet{
            switch cornerMaskPin {
            case .up:
                cornerMask = [.layerMinXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
            case .down:
                cornerMask = [.layerMinXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMinYCorner]
            case .none:
                cornerMask = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner ,.layerMinXMaxYCorner ,.layerMinXMinYCorner]
            }
        }
    }
    var cornerMask: CACornerMask = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner ,.layerMinXMaxYCorner ,.layerMinXMinYCorner]
    public var avatar:UIImage?
    
    public var timestamp:(fontSize:CGFloat,color:UIColor,formate:String) = (9,.gray,"h:mm a")
    public var userName:String? 
    
}
