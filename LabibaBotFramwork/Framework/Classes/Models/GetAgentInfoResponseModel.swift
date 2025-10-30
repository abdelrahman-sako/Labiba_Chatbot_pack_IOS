//
//  GetAgentInfoResponseModel.swift
//  LabibaBotFramwork
//
//  Created by Ahmad Sbeih on 16/09/2025.
//  Copyright © 2025 Abdul Rahman. All rights reserved.
//

import Foundation

// MARK: - GetAgentInfoResponseModel
struct GetAgentInfoResponseModel: Codable {
    let success: Bool?
    let id, name: String?
    
    enum CodingKeys: String, CodingKey {
        case success = "Success"
        case id = "Id"
        case name = "Name"
    }
}
