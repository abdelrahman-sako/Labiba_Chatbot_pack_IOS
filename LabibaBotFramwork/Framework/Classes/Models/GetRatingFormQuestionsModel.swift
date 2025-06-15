//
//  GetRatingFormQuestionsModel.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman Qasem on 11/25/20.
//  Copyright © 2020 Abdul Rahman. All rights reserved.
//

import Foundation
enum RatingCellType:String {
    case rating = "1"
    case options = "2"
    case comment = "3"
    case textField = "4"
    case number = "6"
}
//MARK:  get questions model
class GetRatingFormQuestionsModel:Codable {
    var _id:String?
    var recepient_id:String?
    var questions:[RatingQuestionModel]?
}

class RatingQuestionModel:Codable {
    var QuestionID:String?
    var question:String?
    var type:String?
    
    // local variables
    var rating:Int?
    var options:[String]?
    var option:Int?
    var text:String?
    
    func submitModel() -> SubmitQuestionModel {
        return SubmitQuestionModel(id: Int(QuestionID ?? "1") ?? 1 , question: question ?? "", type: Int(type ?? "1") ?? 1, rating: rating, option: option, text: text)
    }
}

//MARK: submit model
class SubmitRatingModel:Codable{
    var sender_id:String
    var recepient_id:String
    var questions:[SubmitQuestionModel]
    init(recepient_id:String ,questions:[SubmitQuestionModel] ,sender_id:String = Labiba._senderId) {
        self.recepient_id = recepient_id
        self.questions = questions
        self.sender_id = sender_id
    }
}

class SubmitQuestionModel :Codable{
    var id : Int
    var question:String
    var type:Int
    var rating:Int?
    var options:[String]?
    var option:Int?
    var text:String?

    init(id : Int , question:String , type:Int, rating:Int?, option:Int?,text:String?) {
        self.id = id
        self.question = question
        self.type = type
        self.rating = rating
        self.option = option
        self.text = text
        
    }

}
