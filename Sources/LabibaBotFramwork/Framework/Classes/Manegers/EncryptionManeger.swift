//
//  EncryptionManeger.swift
//  LabibaBotFramwork
//
//  Created by Osama Hasan on 24/11/2022.
//  Copyright © 2022 Abdul Rahman. All rights reserved.
//

import Foundation
class EncryptionManeger {
    static let shared = EncryptionManeger()
    
    private init(){}
    
    func encode()->String{
        return "Encoded String"
    }
    
    func decode(value:String)->[String:Any]{
        return [:]
    }
}
