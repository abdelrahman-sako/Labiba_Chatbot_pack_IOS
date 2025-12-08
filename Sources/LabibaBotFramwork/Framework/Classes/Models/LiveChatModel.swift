//
//  LiveChatModel.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman on 1/14/20.
//  Copyright © 2020 Abdul Rahman. All rights reserved.
//

import Foundation
public class LiveChatModel{
    var licenseId:String
    var name:String?
    var email:String?
    var variables:[String:String]?
    var groupId:String?
    public init(licenseId:String ,name:String? = nil ,email:String? = nil , variables:[String:String]? = nil  , groupId:String? = nil) {
        self.licenseId = licenseId
        self.name = name
        self.email = email
        self.variables = variables
        self.groupId = groupId
        
    }
}
