//
//  SharedPreference.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman on 8/19/19.
//  Copyright © 2019 Abdul Rahman. All rights reserved.
//

import Foundation
public enum Language:String ,CaseIterable{
    case ar =  "ar"
    case en = "en"
    case de  = "de"// german
    case ru  = "ru"// russian
    case zh  = "zh"// chines // note that i changed lproject file name from zh-HK to zh
}

class SharedPreference {
    
    
    let token = "refreshToken"
    let langCode = "langCode"
    let userIdAR = "userIdAR"
    let userIdEN = "userIdEN"
    let userIdDE = "userIdDE"
    let userIdRU = "userIdRU"
    let userIdZH = "userIdZH"
    
    //let userIdAR = "userIdAR"
    
    private let standered = UserDefaults.standard
    static let shared = SharedPreference()
    
    private init(){
        
    }
    
    var refreshToken:String?{
        set{
            standered.set(newValue, forKey: token)
        }
        get{
            return standered.string(forKey: token)
        }
    }
    
    var botLangCode:Language{
        get{
            if let lang = standered.string(forKey: langCode) {
                return Language(rawValue:lang) ?? .en
            }
            return Language.en
        }
        
        set {
            standered.set(newValue.rawValue, forKey: langCode)
        }
    }
    
    
    
    var currentUserId:String {
        get{
            switch botLangCode {
            case .ar:
                return standered.string(forKey: userIdAR) ?? ""
            case .en:
               return standered.string(forKey: userIdEN) ?? ""
            case .de:
                return standered.string(forKey: userIdDE) ?? ""
            case .ru:
                return standered.string(forKey: userIdRU) ?? ""
            case .zh:
                return standered.string(forKey: userIdZH) ?? ""
            }
        }
        
    }
    
    func setUserIDs(ar:String , en:String , de:String = "" , ru:String = "" , zh:String = "")  {
        standered.set(ar, forKey: userIdAR)
        standered.set(en, forKey: userIdEN)
        if !de.isEmpty {standered.set(de, forKey: userIdDE)}
        if !ru.isEmpty {standered.set(ru, forKey: userIdRU)}
        if !zh.isEmpty {standered.set(zh, forKey: userIdZH)}
    }
    
    func getUserIDs()->(ar:String,en:String , de:String  , ru:String  , zn:String ){
        return (standered.string(forKey: userIdAR) ?? "",
                standered.string(forKey: userIdEN) ?? "",
                standered.string(forKey: userIdDE) ?? "",
                standered.string(forKey: userIdRU) ?? "",
                standered.string(forKey: userIdZH) ?? "")
    }
    
   
    
}
