//
//  UIColorExtension.swift
//  LabibaBotFramwork
//
//  Created by Ahmad Sbeih on 17/03/2025.
//

import Foundation


import UIKit

import UIKit

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        if !Scanner(string: hexSanitized).scanHexInt64(&rgb) {
            self.init(white: 0.5, alpha: 1.0) // Default to gray
            return
        }
        
        let length = hexSanitized.count
        let r, g, b, a: CGFloat
        
        if length == 6 { // RGB (Hex format: RRGGBB)
            r = CGFloat((rgb >> 16) & 0xFF) / 255.0
            g = CGFloat((rgb >> 8) & 0xFF) / 255.0
            b = CGFloat(rgb & 0xFF) / 255.0
            a = 1.0
        } else if length == 8 { // ARGB (Hex format: AARRGGBB)
            a = CGFloat((rgb >> 24) & 0xFF) / 255.0
            r = CGFloat((rgb >> 16) & 0xFF) / 255.0
            g = CGFloat((rgb >> 8) & 0xFF) / 255.0
            b = CGFloat(rgb & 0xFF) / 255.0
        } else {
            self.init(white: 0.5, alpha: 1.0) // Default to gray
            return
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}

// Usage
//let myColor = UIColor(hex: "#FF5733")  // Custom color
//let invalidColor = UIColor(hex: "XYZ") // Defaults to gray


