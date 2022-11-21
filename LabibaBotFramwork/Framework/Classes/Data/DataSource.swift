//
//  WaselDataSource.swift
//  TiaIOS
//
//  Created by Abdul Rahman on 1/27/19.
//  Copyright © 2019 NSIT. All rights reserved.
//

import Foundation
final class DataSource: DataSourceProtocol{
   
   
 
  
   
  
    
   
    //MARK: Shared Instance
    static var shared: DataSourceProtocol = DataSource()
    
    //MARK: - Properties
    lazy var remoteDataSource:RemoteDataSourceProtocol = RemoteDataSource()
    lazy var localDataSource:LocalDataSourceProtocol = LocalDataSource()
    
    //MARK: - Initializers
    /// Can't init
    private init() {
    }
  
    
    //MARK: - Remote Database
    func messageHandler(model: [String : Any], handler: @escaping Handler<[LabibaModel]>) {
        remoteDataSource.messageHandler(model: model, handler: handler)
    }
    
    func submitRating(ratingModel: SubmitRatingModel, handler: @escaping Handler<SubmitRatingResponseModel>) {
        remoteDataSource.submitRating(ratingModel: ratingModel, handler: handler)
    }
    
    func getRatingQuestions(handler: @escaping Handler<[GetRatingFormQuestionsModel]>) {
        remoteDataSource.getRatingQuestions(handler: handler)
    }
    
    func getHelpPageData(handler: @escaping Handler<HelpPageModel>) {
        remoteDataSource.getHelpPageData(handler: handler)
    }
    
    func getPrechatForm(handler: @escaping Handler<[PrechatFormModel]>) {
        remoteDataSource.getPrechatForm(handler: handler)
    }
    
    func textToSpeech(model: TextToSpeechModel, handler: @escaping Handler<TextToSpeachResponseModel>) {
        remoteDataSource.textToSpeech(model: model, handler: handler)
    }
    
    
    
    //MARK: - Local Database
    func getRecentOriginCities(handler: @escaping Handler<[LabibaModel]>) {
        localDataSource.getRecentOriginCities(handler: handler)
    }
}



