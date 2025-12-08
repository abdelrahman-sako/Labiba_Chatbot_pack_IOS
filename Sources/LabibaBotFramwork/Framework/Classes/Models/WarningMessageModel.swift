//
//  WarningMessageModel.swift
//  LabibaBotFramwork
//
//  Created by Ahmad Sbeih on 12/11/2025.
//  Copyright © 2025 Abdul Rahman. All rights reserved.
//

import Foundation

struct WarningMessageModel{
    var isWarningMessageEnabled:Bool = false
    var enTitle, arTitle:String
    var link:String?
    var linkEnPressTitle,linkArPressTitle: String?
    var linkPressColor:UIColor = .black
    var fontName:String?
    var fontColor, backgroundColor:UIColor
    var padding:Int
    var cornerRadius:Int
    var showBoarder:Bool = false
    var boarderColor:UIColor = .black.withAlphaComponent(0.3)
}
