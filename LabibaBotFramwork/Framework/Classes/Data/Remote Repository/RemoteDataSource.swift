//
//  WaselRemoteDataSource.swift
//  TiaIOS
//
//  Created by Abdul Rahman on 1/27/19.
//  Copyright © 2019 NSIT. All rights reserved.
//

import Foundation

class RemoteDataSource:RemoteDataSourceProtocol{
    func uploadData(model: UploadDataModel, handler: @escaping Handler<UploadDataResponseModel>) {
        let url = "\(Labiba._uploadUrl)?id=\(SharedPreference.shared.currentUserId)"
        let endPoint = EndPoint(url: url, httpMethod: .post)
        remoteContext.multipartRequest(endPoint: endPoint, params: nil, multipartName: "", uploadFiles: [model.data], mimeType: model.mimeType,fileName: model.fileName) { result in
            switch  result {
            case .success(let body):
                self.parser(data: body, model: UploadDataResponseModel.self, handler: handler)
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }

    
    
    func getLastBotResponse(handler: @escaping Handler<LastBotResponseModel>) {
        let url = "\(Labiba._basePath)/api/getLastBotResponse"
        let endPoint = EndPoint(url: url, httpMethod: .get)
        
        let params:[String:String] = [
            "RecepientID" :Labiba._pageId,
            "SenderID":Labiba._senderId
        ]
        remoteContext.withTokenRequest(endPoint: endPoint, parameters: params) { result in
            switch  result {
            case .success(let data):
                self.parser(data: data, model: LastBotResponseModel.self, handler: handler)
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    func closeConversation(handler: @escaping Handler<[String]>) {
        //api/LiveChat/v1.0/CloseConversation/\(Labiba._pageId)/\(Labiba._senderId ?? "")/mobile
        
        let url = "\(Labiba._basePath)/api/LiveChat/v1.0/CloseConversation/\(Labiba._pageId)/\(Labiba._senderId ?? "")/mobile"
        let endPoint = EndPoint(url: url, httpMethod: .post)
       
        
        remoteContext.request(endPoint: endPoint, parameters: nil) { result in
            switch  result {
            case .success(let data):
                self.parser(data: data, model: [String].self, handler: handler)
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
//    func updateToken(handler: @escaping Handler<UpdateTokenModel>) {
//        let url = "\(Labiba._basePath)/api/Auth/Login"
//        let endPoint = EndPoint(url: url, httpMethod: .post)
//        let params:[String:Any] = [
//            "Username":Labiba.jwtAuthParamerters.username,
//            "Password":Labiba.jwtAuthParamerters.password
//        ]
//        remoteContext.request(endPoint: endPoint, parameters: params) { result in
//            switch  result {
//            case .success(let data):
//                self.parser(data: data, model: UpdateTokenModel.self, handler: handler)
//            case .failure(let error):
//                handler(.failure(error))
//            }
//        }
//    }
    
    func messageHandler(model: [String : Any], handler: @escaping Handler<[LabibaModel]>) {
        let url = "\(Labiba._basePath)\(Labiba._messagingServicePath)"
        let endPoint = EndPoint(url: url, httpMethod: .post,headers: ["Content-Type":ContentType.json.rawValue])
        let params = model
        remoteContext.withTokenRequest(endPoint: endPoint, parameters: params) { result in
            switch  result {
            case .success(let data):
                self.parser(data: data, model: [LabibaModel].self, handler: handler)
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    func getRatingQuestions(handler: @escaping Handler<[GetRatingFormQuestionsModel]>) {
        let url = "\(Labiba._basePath)/api/MobileAPI/FetchQuestions"
        let endPoint = EndPoint(url: url, httpMethod: .get)
        let params:[String:Any] = [
            "bot_id" : SharedPreference.shared.currentUserId
        ]
        remoteContext.withTokenRequest(endPoint: endPoint, parameters: params) { result in
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
        
        remoteContext.withTokenRequest(endPoint: endPoint, parameters: params) { result in
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
        
        remoteContext.withTokenRequest(endPoint: endPoint, parameters: params) { result in
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
        
        remoteContext.withTokenRequest(endPoint: endPoint, parameters: params) { result in
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
        
        remoteContext.withTokenRequest(endPoint: endPoint, parameters: params) { result in
            switch  result {
            case .success(let data):
                self.parser(data: data, model: TextToSpeachResponseModel.self, handler: handler)
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    private func log(){
        
    }
    
    
    
    //MARK: - Close All Session Tasks

    func close() {
        remoteContext.close()
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
  
    //MARK: - Properties
    lazy var remoteContext = RemoteContext()
  
}


func getHeaders(withToken:Bool = true) -> [String : String]{
    var headers = [String : String]()
    headers["Content-Type"] = "application/json"
   // headers["device-Key"] = "3c754e4987ea1dc515eh8a01a10583ff"
    return headers
}

