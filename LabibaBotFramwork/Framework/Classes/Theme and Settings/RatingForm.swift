//
//  RatingForm.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman Qasem on 11/25/20.
//  Copyright © 2020 Abdul Rahman. All rights reserved.
//

import Foundation
import UIKit

public class LabibaRatingForm {
    public enum RatingStyle{
        case fullScreen
        case sheet
    }
    public var style:RatingStyle = .fullScreen
    public var background:LabibaBackground = .solid(color:UIColor(argb: 0xff5387B8))
    public var titleColor: UIColor = .white
    public var titleFont:UIFont = applyBotFont( bold: true, size: 18)
    public var questionsColor: UIColor = .white
    public var questionsFont: (size:CGFloat,weight:LabibaFontWeight) = (15,.regular ) 
    public var fullStarTintColor: UIColor = UIColor(argb: 0xffF4B63F)
    public var emptyStarTintColor: UIColor = UIColor(argb: 0xffD4D9DD)
    public var starsContainerBorderColor: UIColor = .gray
    public var commentContainerColor:UIColor = UIColor.white.withAlphaComponent(0.1)
    public var commentContainerCornerRadius:CGFloat = 0
    public var commentFont:(size:CGFloat,weight:LabibaFontWeight) = (15,.regular)
    public var commentColor:UIColor = UIColor.white
    public var mobileNumContainerColor:UIColor = UIColor.white.withAlphaComponent(0.1)
    public var mobileNumFont:UIFont = applyBotFont(size: 15)
    public var mobileNumColor:UIColor = UIColor.white
    
    public var submitButton:(tint:UIColor,background:UIColor) = (.white,.clear)
    public var rateLaterButton:(tint:UIColor,background:UIColor) = (.white,.clear)
    
    
}
