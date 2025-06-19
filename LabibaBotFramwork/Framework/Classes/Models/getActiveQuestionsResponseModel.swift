//
//  getActiveQuestionsResponseModel.swift
//  LabibaBotFramwork
//
//  Created by Ahmad Sbeih on 16/06/2025.
//  Copyright © 2025 Abdul Rahman. All rights reserved.
//

import Foundation


struct getActiveQuestionsResponseModel: Codable {
    let header: QuestionHeader
    let data: NPSQuestionData
    
    enum CodingKeys: String, CodingKey {
        case header = "Header"
        case data = "Data"
    }
}

struct QuestionHeader: Codable {
    let isSuccess: Bool
    
    enum CodingKeys: String, CodingKey {
        case isSuccess = "IsSuccess"
    }
}

struct NPSQuestionData: Codable {
    let id: Int?
    let clientId: Int?
    let question: String?
    let questionAr: String?
    let npsQuestionTemplateLongId: String?
    let npsTypeId: Int?
    let currentActive: Bool?
}
