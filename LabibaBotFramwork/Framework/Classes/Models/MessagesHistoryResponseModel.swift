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
    let id: String
    let messageText: String?
    let from, to, dateSent, timeSent: String?
    let messageID: String?
    let isChatWithAgent: Bool?
    
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
