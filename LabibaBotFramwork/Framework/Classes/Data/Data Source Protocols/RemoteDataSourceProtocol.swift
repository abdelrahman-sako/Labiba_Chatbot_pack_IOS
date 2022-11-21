//
//  WaselDataSourceProtocol.swift
//  TiaIOS
//
//  Created by Abdul Rahman on 1/27/19.
//  Copyright © 2019 NSIT. All rights reserved.
//

import Foundation

protocol RemoteDataSourceProtocol {
    func getRatingQuestions(handler: @escaping Handler<[GetRatingFormQuestionsModel]>)
    func submitRating(ratingModel:SubmitRatingModel,handler: @escaping Handler<SubmitRatingResponseModel>)
    func getHelpPageData(handler: @escaping Handler<HelpPageModel>)
    func getPrechatForm(handler: @escaping Handler<[PrechatFormModel]>)
    func textToSpeech(model:TextToSpeechModel,handler: @escaping Handler<TextToSpeachResponseModel>)
    func closeConversation(handler: @escaping Handler<[String]>)
    func updateToken(handler: @escaping Handler<UpdateTokenModel>)
    func getLastBotResponse(handler: @escaping Handler<LastBotResponseModel>)
    
    
}

