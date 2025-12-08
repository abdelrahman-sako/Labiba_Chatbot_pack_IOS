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

public enum LabibaFontWeight:String{
    case regular = "regular"
    case bold = "bold"
}

//public enum LabibaBackground {
//    case solid (color:UIColor)
//    case gradient (gradientSpecs:Labiba.GradientSpecs)
//    case image (image:UIImage)
//}

public enum LabibaBackground: RawRepresentable {
    case solid(color: UIColor)
    case gradient(gradientSpecs: Labiba.GradientSpecs)
    case image(image: UIImage)
    
    public typealias RawValue = String
    
    public init?(rawValue: String) {
        switch rawValue {
        case "solid":
            self = .solid(color: .gray) // Default color
        case "gradient":
            self = .gradient(gradientSpecs: Labiba.GradientSpecs.init(colors: [], locations: [], start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: 0))) // Provide a default gradient
        case "image":
            self = .image(image: UIImage()) // Provide a default image
        default:
            return nil
        }
    }
    
    public var rawValue: String {
        switch self {
        case .solid: return "solid"
        case .gradient: return "gradient"
        case .image: return "image"
        }
    }
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

