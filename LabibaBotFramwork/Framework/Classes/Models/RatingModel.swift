////
////  RatingModel.swift
////  LabibaBotFramwork
////
////  Created by Abdulrahman on 10/14/19.
////  Copyright © 2019 Abdul Rahman. All rights reserved.
////
//
//import Foundation
//enum RatingCellType:String {
//    case rating = "1"
//    case options = "2"
//    case comment = "3"
//    case textField = "4"
//}
//
//
//class RatingModel:Codable{
//    var sender_id:String
//    var recepient_id:String
//    var questions:[QuestionModel]
//    init(recepient_id:String ,questions:[QuestionModel] ,sender_id:String = Labiba._senderId) {
//        self.recepient_id = recepient_id
//        self.questions = questions
//        self.sender_id = sender_id
//    }
//}
//
//
//class QuestionModel :Codable{
//    var id : Int
//    var question:String
//    var type:Int
//    var rating:Int?
//    var options:[String]?
//    var option:Int?
//    var text:String?
//    
//    init(id : Int , question:String , type:Int) {
//        self.id = id
//        self.question = question
//        self.type = type
//    }
//    
//}
//
//
////class StarsRatingModel:Rating{
////    var titel: String
////    var type: RatingCellType = .stars
////    var rate:Int = 0
////    init(titel:String) {
////        self.titel = titel
////    }
////}
////
////class RadioButtonsRatingModel:Rating{
////    var titel: String
////    var type: RatingCellType = .radioButtons
////    var options:[String]
////    var selectedIndex:Int?
////    init(titel:String ,options:[String]) {
////        self.titel = titel
////        self.options = options
////    }
////}
