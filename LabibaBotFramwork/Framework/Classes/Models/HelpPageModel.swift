//
//  HelpPageModel.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman Qasem on 2/9/21.
//  Copyright © 2021 Abdul Rahman. All rights reserved.
//

import Foundation
class HelpPageModel:Codable {
    var Title:String?
    var Description:String?
    var GetStarted:Bool?
    var Bot_Id:String
    var ExpandableItems:[ExpandableItem]?
    
    class ExpandableItem:Codable {
        var Title:String?
        var Description:String?
    }
}

