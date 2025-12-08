//
//  PrechatFormThemeModel.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman Qasem on 16/09/2021.
//  Copyright © 2021 Abdul Rahman. All rights reserved.
//

import Foundation
public class PrechatFormThemeModel {
    
    public var backgroundColor:UIColor = .white
    public var header:(image:UIImage?,titleColor:UIColor) =  (nil, .black)
    public var field:(titleColor:UIColor,textColor:UIColor,backgroundColor:UIColor,borderColor:UIColor) = (UIColor(argb: 0xff979898),.black,UIColor(argb: 0xffF8F9F8),UIColor(argb: 0xffD1D2D2))
    public var button:(titleColor:UIColor,backgroundColor:UIColor) = (.white,UIColor(argb: 0xFFFFCC02))
    
    
}
 
