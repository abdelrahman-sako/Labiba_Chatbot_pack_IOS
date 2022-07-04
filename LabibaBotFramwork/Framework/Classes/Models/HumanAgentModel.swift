//
//  HumanAgentModel.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman Qasem on 03/07/2022.
//  Copyright © 2022 Abdul Rahman. All rights reserved.
//

import Foundation
class HumanAgentModel:Decodable {
    var result:HumanAgentResult?
    
    class HumanAgentResult:Decodable {
        var fulfillment:[HumanAgentfulfillment]?
    }
    
    
    class HumanAgentfulfillment:Decodable {
        var message:String?
//        var title": null,
//        var text": null,
        var imageUrl:String?
//        var buttons": null,
//        var replies": null
    }
}
