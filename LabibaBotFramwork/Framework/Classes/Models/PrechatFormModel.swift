//
//  PrechatFormModel.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman Qasem on 19/09/2021.
//  Copyright © 2021 Abdul Rahman. All rights reserved.
//

import Foundation
class PrechatFormModel:Codable{
    
    var title:String?
    var parameterName:String?
    var isOptional:Bool
    var type:String?
    
    //local vars
    var fieldValue:String? = ""
    
    
    enum FieldType {
        case email
        case phone
        case number
        case text
    }
    
    func getType() -> FieldType {
        switch type {
        case "email":
            return .email
        case "phone":
            return .phone
        case "number":
            return .number
        case "text":
            return .text
        default:
            return .text
        }
    }
}
