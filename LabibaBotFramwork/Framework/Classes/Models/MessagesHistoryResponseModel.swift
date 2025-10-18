//
//  MessagesHistoryResponseModel.swift
//  LabibaBotFramwork
//
//  Created by Ahmad Sbeih on 08/09/2025.
//  Copyright © 2025 Abdul Rahman. All rights reserved.
//

import Foundation

// MARK: - MessagesHistoryResponseModelElement
struct MessagesHistoryResponseModelElement: Codable {
    var id: String
    var messageText: String?
    var from, to, dateSent, timeSent,type,messageID: String?
    var isChatWithAgent: Bool?
    var senderName: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case messageText = "MessageText"
        case from, to
        case dateSent = "DateSent"
        case timeSent = "TimeSent"
        case messageID = "MessageId"
        case type = "Type"
        case senderName = "SenderName"
        case isChatWithAgent
    }
}

typealias MessagesHistoryResponseModel = [MessagesHistoryResponseModelElement]
