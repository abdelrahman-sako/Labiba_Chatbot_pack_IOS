//
//  UpdateTokenModel.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman Qasem on 14/10/2021.
//  Copyright © 2021 Abdul Rahman. All rights reserved.
//

import Foundation
class UpdateTokenModel : Codable {
    var token:String?
    
    static func isTokenValid()-> Bool {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US")
        df.dateFormat = "dd MM yyyy hh:mm a"
        guard let tokenDate = df.date(from: SharedPreference.shared.jwtToken.date ?? "")?.addingTimeInterval(60*60*23) else { return false }
        let currentDate = Date()
        if currentDate > tokenDate {
            return false
        }
        return true
    }
    
    static func isTokenRequeird()->Bool{
        return !Labiba.jwtAuthParamerters.password.isEmpty
    }
    
    static func saveToken(token:String?) {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US")
        df.dateFormat = "dd MM yyyy hh:mm a"
        if let token  = token {
            SharedPreference.shared.jwtToken = (df.string(from: Date()),token)
        }
    }
}
