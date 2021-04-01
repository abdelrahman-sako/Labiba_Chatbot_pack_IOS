//
//  CarousalCardView.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman Qasem on 12/10/20.
//  Copyright © 2020 Abdul Rahman. All rights reserved.
//

import Foundation
import UIKit

public class LabibaCarousalCardView {
    
    public var backgroundColor:UIColor = UIColor(argb: 0xFFf7f7f7)
    public var border:(width:CGFloat,color:UIColor) = (0,.clear)
    public var alpha: CGFloat = 1
    public var cornerRadius:CGFloat = 10
    public var tintColor: UIColor = #colorLiteral(red: 0.03137254902, green: 0.3725490196, blue: 1, alpha: 1)
    public var backgroundImageStyleEnabled: Bool = false
    public var bottomGradient: Labiba.GradientSpecs? = nil {
        didSet{
            backgroundImageStyleEnabled = true
        }
    }
    
    
    public var titleColor: UIColor = UIColor(argb: 0xffffffff)
    public var titleFont: (size:CGFloat,weight:LabibaFontWeight) = (11,.bold)
    
    
    public var subtitleColor: UIColor =  UIColor(argb: 0xffffffff)
    public var subtitleFont: (size:CGFloat,weight:LabibaFontWeight) = (11,.regular)
    
    
    public var buttonTitleColor:UIColor = UIColor(argb: 0xffffffff)
    public var buttonFont: (size:CGFloat,weight:LabibaFontWeight) = (11,.regular)
    public var buttonBorder:(width:CGFloat,color:UIColor) = (0,.clear)
    public var buttonSeparatorLine:(color:UIColor,inset:CGFloat) = (.white,0)
    public var buttonCornerRadius:CGFloat = 0
    public var shadow:LabibaShadowModel = LabibaShadowModel(shadowColor:  UIColor.black.cgColor, shadowOffset: CGSize(width: 0, height: 1), shadowRadius: 1.5, shadowOpacity: 0.15)
    
}
