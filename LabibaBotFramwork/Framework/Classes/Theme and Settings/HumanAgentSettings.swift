//
//  HumanAgentSettings.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman Qasem on 12/08/2021.
//  Copyright © 2021 Abdul Rahman. All rights reserved.
//

import Foundation
public class HumanAgentSettings{
    public enum type {
        case inLabiba
        case outLabiba
    }
    public var url:String = ""
    /// if you choose [inLabiba] type, you must add human agent url using  [Labiba.HumanAgent.url = String]
    public var type:type = .inLabiba
    /// This counter indicates the number of misunderstanding sentences before  transfer to human agent 
    public var counter:UInt8 = 2
    
    func getUrl()->String {
        return "\(url)?SessionID=\(Labiba._senderId ?? "")"
    }
    
 
    
}
