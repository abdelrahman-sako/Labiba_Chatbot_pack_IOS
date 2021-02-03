//
//  VoiceAssistantView.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman Qasem on 1/14/21.
//  Copyright © 2021 Abdul Rahman. All rights reserved.
//

import Foundation
import UIKit

public class LabibaVoiceAssistantView{
    
    public var background:LabibaBackground = .solid(color:.clear)
    public var micButton:(icon:UIImage,tintColor:UIColor,backgroundColor:UIColor,alpha:CGFloat) = (Image(named: "micIcon")!,.white,UIColor(argb: 0x8066439F),1)
    public var keyboardButton:(icon:UIImage,tintColor:UIColor) = (Image(named: "keyboard_icon")!,.white)
    public var attachmentButton:(icon:UIImage,tintColor:UIColor,isHidden:Bool) = (Image(named: "paperclip-solid")!,.white,true)
    public var waveColor:UIColor = .white
    
}

