//
//  GeneralThemeSettings.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman Qasem on 11/25/20.
//  Copyright © 2020 Abdul Rahman. All rights reserved.
//

import Foundation
import UIKit
public enum LabibaCornerPin{
    case up
    case down
    case none
}

public enum LabibaFontWeight{
    case regular
    case bold
}

public enum LabibaBackground {
    case solid (color:UIColor)
    case gradient (gradientSpecs:Labiba.GradientSpecs)
    case image (image:UIImage)
}

public class LabibaShadowModel {
    var shadowColor:CGColor
    var shadowOffset:CGSize
    var shadowRadius:CGFloat
    var shadowOpacity:Float
    public init(shadowColor:CGColor , shadowOffset:CGSize , shadowRadius:CGFloat , shadowOpacity:Float) {
        self.shadowColor = shadowColor
        self.shadowOffset = shadowOffset
        self.shadowRadius = shadowRadius
        self.shadowOpacity = shadowOpacity
    }
}

