//
//  LabibaFont.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman on 10/6/19.
//  Copyright © 2019 Abdul Rahman. All rights reserved.
//

import Foundation
 public enum LabibaFont {
    case DINNextLTW23
    case TheSans
    
    var rawValue:(regAR:String , boldAR:String , regEN:String , boldEN:String){
        switch self {
        case .DINNextLTW23:
            return ("DINNextLTW23-Regular","DINNextLTW23-Bold","DINNextLTW23-Regular","DINNextLTW23-Bold")
        case .TheSans :
            return ("TheSans-Plain","TheSans-Bold","AvantGarde-Medium","AvantGarde-Bold")
        }
    }
}
