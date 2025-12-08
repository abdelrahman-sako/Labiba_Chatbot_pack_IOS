//
//  LoggingModel.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman Qasem on 01/12/2022.
//  Copyright © 2022 Abdul Rahman. All rights reserved.
//

import Foundation
class LoggingModel:Codable {
    var Source:String = "IOS"
    var Tag:String
    var DeviceDetails:String
    var UserDetails:String
    var Request:String
    var Response:String
    var Exception:String
    var SDKVersion:String
    
    init(Tag:String,DeviceDetails:String,UserDetails:String,Request:String,Response:String,Exception:String,SDKVersion:String) {
        self.Tag = Tag
        self.DeviceDetails = DeviceDetails
        self.UserDetails = UserDetails
        self.Request = Request
        self.Response = Response
        self.Exception = Exception
        self.SDKVersion = SDKVersion
        
    }
    
}
