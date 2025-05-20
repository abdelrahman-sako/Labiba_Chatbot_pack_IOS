//
//  SharedPreference.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman on 8/19/19.
//  Copyright © 2019 Abdul Rahman. All rights reserved.
//

import Foundation
public enum LabibaLanguage:String ,CaseIterable{
    case ar =  "ar"
    case en = "en"
    case de  = "de"// german
    case ru  = "ru"// russian
    case zh  = "zh"// chines // note that i changed lproject file name from zh-HK to zh
}

class SharedPreference {
    
    
    private let TOKEN = "TOKEN"
    private let JWT_TOKEN = "JWTTOKEN"
    private let langCode = "langCode"
    private let userIdAR = "userIdAR"
    private let userIdEN = "userIdEN"
    private let userIdDE = "userIdDE"
    private let userIdRU = "userIdRU"
    private let userIdZH = "userIdZH"
    private let humanAgentStarted = "humanAgentStarted"

    //let userIdAR = "userIdAR"
    
    private let standered = UserDefaults.standard
    static let shared = SharedPreference()
    
    private init(){
        
    }
    
    var refreshToken:String?{
        set{
            standered.set(newValue, forKey: TOKEN)
        }
        get{
            return standered.string(forKey: TOKEN)
        }
    }
    
    var jwtToken:(date:String?,token:String?){
        set{
            standered.set(newValue.date, forKey: "\(JWT_TOKEN)DATE")
            standered.set(newValue.token, forKey: "\(JWT_TOKEN)VALUE")
        }
        get{
            return (standered.string(forKey: "\(JWT_TOKEN)DATE"),standered.string(forKey: "\(JWT_TOKEN)VALUE"))
        }
    }
    
    var botLangCode:LabibaLanguage{
        get{
            if let lang = standered.string(forKey: langCode) {
                return LabibaLanguage(rawValue:lang) ?? .en
            }
            return LabibaLanguage.en
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
    
    
    var isHumanAgentStarted : Bool{
        set{
            standered.set(newValue, forKey: humanAgentStarted)
        }
        get{
            return standered.bool(forKey: humanAgentStarted)
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
    
    var userMessages:[String] = []
    
    var botMessages:[String] = []
    
    var conversationMessages: [String] = []
   
}
