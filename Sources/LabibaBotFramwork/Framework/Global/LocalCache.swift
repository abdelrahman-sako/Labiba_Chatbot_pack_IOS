//
//  LocalCache.swift
//  LabibaBotFramwork
//
//  Created by Osama Hasan on 08/05/2023.
//  Copyright © 2023 Abdul Rahman. All rights reserved.
//

import Foundation


class LocalCache{
    static let shared = LocalCache()
    var displayedDialogs:[EntryDisplay] = []
    var stepsToBeDisplayed = [ConversationDialog]()
    var conversationId: String?
}
