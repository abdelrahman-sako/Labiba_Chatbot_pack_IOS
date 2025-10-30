//
//  getActiveQuestionsResponseModel.swift
//  LabibaBotFramwork
//
//  Created by Ahmad Sbeih on 16/06/2025.
//  Copyright © 2025 Abdul Rahman. All rights reserved.
//

import Foundation


// MARK: - GetActiveQuestionsResponseModel
struct getActiveQuestionsResponseModel: Codable {
    let header: QuestionHeader
    let data: NPSQuestionData
    
    enum CodingKeys: String, CodingKey {
        case header = "Header"
        case data = "Data"
    }
}

struct QuestionHeader: Codable {
        let isSuccess: Bool?
        
        enum CodingKeys: String, CodingKey {
            case isSuccess = "IsSuccess"
        }
    }
struct NPSQuestionData: Codable {
    let id, clientID: Int?
    let question, questionAr, npsQuestionTemplateLongID: String?
    let npsTypeID: Int?
    let currentActive: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case clientID = "clientId"
        case question, questionAr
        case npsQuestionTemplateLongID = "npsQuestionTemplateLongId"
        case npsTypeID = "npsTypeId"
        case currentActive
    }
}
