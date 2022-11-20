//
//  WaselRemoteDataSource.swift
//  TiaIOS
//
//  Created by Abdul Rahman on 1/27/19.
//  Copyright © 2019 NSIT. All rights reserved.
//

import Foundation

class RemoteDataSource:RemoteDataSourceProtocol{
   
  
    
   
    
    func getRatingQuestions(handler: @escaping Handler<[GetRatingFormQuestionsModel]>) {
        let url = "\(Labiba._basePath)/api/MobileAPI/FetchQuestions"
        let endPoint = EndPoint(url: url, httpMethod: .get)
        let params:[String:Any] = [
            "bot_id" : SharedPreference.shared.currentUserId
        ]
        remoteContext.request(endPoint: endPoint, parameters: params) { result in
            switch  result {
            case .success(let data):
                self.parser(data: data, model: [GetRatingFormQuestionsModel].self, handler: handler)
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    func submitRating(ratingModel: SubmitRatingModel, handler: @escaping Handler<SubmitRatingResponseModel>) {
        let url = "\(Labiba._basePath)/api/ratingform/submit"
        let endPoint = EndPoint(url: url, httpMethod: .post)
        let params = ratingModel.dictionary
        
        remoteContext.request(endPoint: endPoint, parameters: params) { result in
            switch  result {
            case .success(let data):
                self.parser(data: data, model: SubmitRatingResponseModel.self, handler: handler)
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
   
    
    func getHelpPageData(handler: @escaping Handler<HelpPageModel>) {
        let url = Labiba._helpUrl
        let endPoint = EndPoint(url: url, httpMethod: .get)
        let params:[String:Any] = [
            "bot_id" : SharedPreference.shared.currentUserId
        ]
        
        remoteContext.request(endPoint: endPoint, parameters: params) { result in
            switch  result {
            case .success(let data):
                self.parser(data: data, model: HelpPageModel.self, handler: handler)
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    
    func getPrechatForm(handler: @escaping Handler<[PrechatFormModel]>) {
        let url =  "\(Labiba._basePath)\(Labiba._prechatFormServicePath)"
        let endPoint = EndPoint(url: url, httpMethod: .post)
        let params:[String:Any] = [
            "bot_id" : SharedPreference.shared.currentUserId
        ]
        
        remoteContext.request(endPoint: endPoint, parameters: params) { result in
            switch  result {
            case .success(let data):
                self.parser(data: data, model: [PrechatFormModel].self, handler: handler)
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
   
    func textToSpeech(model: TextToSpeechModel, handler: @escaping Handler<TextToSpeachResponseModel>) {
        let url =  "\(Labiba._voiceBasePath)\(Labiba._voiceServicePath)"
        let endPoint = EndPoint(url: url, httpMethod: .post)
        let params:[String:Any] = [
            "text":model.text,
            "voicename" : model.googleVoice.voicename,
            "clientid" : model.clientid,
            "language" : model.googleVoice.language,
            "isSSML":"\(model.isSSML)"
        ]
        
        remoteContext.request(endPoint: endPoint, parameters: params) { result in
            switch  result {
            case .success(let data):
                self.parser(data: data, model: TextToSpeachResponseModel.self, handler: handler)
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    
    
  
   //MARK: - Parsers

    private func parser<T:Decodable>(data:Data,model:T.Type, handler: @escaping Handler<T>) {
       
        let decoder =  JSONDecoder()
        do {
            let model = try decoder.decode(T.self, from: data)
            handler(.success(model))
        } catch {
            handler(.failure(ErrorModel(message: error.localizedDescription)))
        }
    }
    
    func printResponse(url:String = "",statusCode:Int = 0,method:String = "",data:Data,name:String = "")  {
        prettyPrintedResponse(url: url, statusCode:statusCode,method:method,data: data, name: URL(string: url)?.lastPathComponent ?? "request")
    }

  
    //MARK: - Properties
    lazy var remoteContext = RemoteContext()
  
}


func getHeaders(withToken:Bool = true) -> [String : String]{
    var headers = [String : String]()
    headers["Content-Type"] = "application/json"
   // headers["device-Key"] = "3c754e4987ea1dc515eh8a01a10583ff"
    return headers
}

