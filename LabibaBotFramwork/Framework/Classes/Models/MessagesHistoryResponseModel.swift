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
    var from, to, dateSent, timeSent: String?
    var messageID: String?
    var isChatWithAgent: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case messageText = "MessageText"
        case from, to
        case dateSent = "DateSent"
        case timeSent = "TimeSent"
        case messageID = "MessageId"
        case isChatWithAgent
    }
}

typealias MessagesHistoryResponseModel = [MessagesHistoryResponseModelElement]
