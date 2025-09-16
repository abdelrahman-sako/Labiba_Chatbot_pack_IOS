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
            case .success(let data):
                self.parser(data: data, model: UploadDataResponseModel.self, handler: handler)
                let dataString = String(data: data, encoding: .utf8) ?? ""
                Logging.shared.logSuccessCase(url: url, tag: .upload, method: .post, parameter: "", response: dataString)
            case .failure(let error):
                handler(.failure(error))
                Logging.shared.log(url: url, tag: .upload, method: .post, parameter: "", response: error.response,exception: error.logDescription)
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
                let dataString = String(data: data, encoding: .utf8) ?? ""
                Logging.shared.logSuccessCase(url: url, tag: .lastMessage, method: .get, parameter: params.description, response: dataString)
            case .failure(let error):
                handler(.failure(error))
                Logging.shared.log(url: url, tag: .lastMessage, method: .get, parameter: params.description, response: error.response,exception: error.logDescription)
            }
        }
    }
    
    func closeConversation(handler: @escaping Handler<[String]>) {
        //api/LiveChat/v1.0/CloseConversation/\(Labiba._pageId)/\(Labiba._senderId ?? "")/mobile
        
//        let url = "\(Labiba.HumanAgent.endConversationUrl)\(SharedPreference.shared.currentUserId)/\(Labiba._senderId ?? "")/mobile"
//        let endPoint = EndPoint(url: url, httpMethod: .post,headers: ["Connection":"close","Cookie":"TS0138c503=016ec82a31c15f1a46acae0819b893edf3165cf878006eaee09e37a658f1b8a03c892efbf3aa4a152c60c41046565dad5a3d5fc287"])
//        
//        
//        remoteContext.request(endPoint: endPoint, parameters: "") { result in
//            switch  result {
//            case .success(let data):
//                self.parser(data: data, model: [String].self, handler: handler)
//            case .failure(let error):
//                handler(.failure(error))
//            }
//        }
        
        endConversationWithCookies()
    }
    
 //this is used because the server needs cookies and thats compatable with URLSession not alamofire
    func endConversationWithCookies(){
        let url = "\(Labiba.HumanAgent.endConversationUrl)\(SharedPreference.shared.currentUserId)/\(Labiba._senderId ?? "")/mobile"
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        for dict in Labiba.clientHeaders {
            for (key, value) in dict {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            print(String(data: data, encoding: .utf8)!)
        }
        
        task.resume()
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
        if Labiba.loggingAndRefferalEncodingType != .base64 {
            remoteContext.withTokenRequest(endPoint: endPoint, parameters: params) { result in
                switch  result {
                case .success(let data):
                    self.searchForEndedChats(data)
                    if !SharedPreference.shared.isHumanAgentStarted {
                        self.parser(data: data, model: [LabibaModel].self, handler: handler)
                        
                    }else{
                        handler(.success([]))
                    }
                    let dataString = String(data: data, encoding: .utf8) ?? ""
                    Logging.shared.logSuccessCase(url: url, tag: .messaging, method: .post, parameter: params.description, response: dataString)
                case .failure(let error):
                    handler(.failure(error))
                    Logging.shared.log(url: url, tag: .messaging, method: .post, parameter: params.description, response: error.response,exception: error.logDescription)
                }
                
            }
        }else{
            remoteContext.withTokenRequest(endPoint: endPoint, parameters: params.toBase64()) { result in
                switch  result {
                case .success(let data):
                    self.parserBase64(data: data, model: [LabibaModel].self, handler: handler)
                    let dataString = String(data: data, encoding: .utf8) ?? ""
                    Logging.shared.logSuccessCase(url: url, tag: .messaging, method: .post, parameter: params.description, response: dataString)
                case .failure(let error):
                    handler(.failure(error))
                    Logging.shared.log(url: url, tag: .messaging, method: .post, parameter: params.description, response: error.response,exception: error.logDescription)
                }
            }
        }
    }
    
    func searchForEndedChats(_ jsonData:Data){
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData)
            if findType(in: jsonObject) {
                print("Found type 'call.nps.agent'")
                Labiba.skipErrorMessage = true
//                if !Labiba.didGoToRate{
                if Labiba.isNPSAgentRatingEnabled{
                    Labiba.handleNPSRartingAndQuit(isForAgent: true)
                }
            } else {
                print("Type not found")
            }
        } catch {
            print("Failed to parse JSON: \(error)")
        }
    }
    func findType(in json: Any) -> Bool {
        if let dict = json as? [String: Any] {
            for (key, value) in dict {
                if key == "type", let typeValue = value as? String, typeValue == "call.nps.agent" {
                    return true
                } else if findType(in: value) { // recurse into nested
                    return true
                }
            }
        } else if let array = json as? [Any] {
            for item in array {
                if findType(in: item) { // recurse into array
                    return true
                }
            }
        }
        return false
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
                let dataString = String(data: data, encoding: .utf8) ?? ""
                Logging.shared.logSuccessCase(url: url, tag: .ratingQuestions, method: .post, parameter: params.description, response: dataString)
            case .failure(let error):
                handler(.failure(error))
                Logging.shared.log(url: url, tag: .ratingQuestions, method: .post, parameter: params.description, response: error.response,exception: error.logDescription)
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
                let dataString = String(data: data, encoding: .utf8) ?? ""
                Logging.shared.logSuccessCase(url: url, tag: .ratingSubmit, method: .post, parameter: params.description, response: dataString)
            case .failure(let error):
                handler(.failure(error))
                Logging.shared.log(url: url, tag: .ratingSubmit, method: .post, parameter: params.description, response: error.response,exception: error.logDescription)
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
                let dataString = String(data: data, encoding: .utf8) ?? ""
                Logging.shared.logSuccessCase(url: url, tag: .help, method: .post, parameter: params.description, response: dataString)
            case .failure(let error):
                handler(.failure(error))
                Logging.shared.log(url: url, tag: .help, method: .post, parameter: params.description, response: error.response,exception: error.logDescription)
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
                let dataString = String(data: data, encoding: .utf8) ?? ""
                Logging.shared.logSuccessCase(url: url, tag: .prechatForm, method: .post, parameter: params.description, response: dataString)
            case .failure(let error):
                handler(.failure(error))
                Logging.shared.log(url: url, tag: .prechatForm, method: .post, parameter: params.description, response: error.response,exception: error.logDescription)
            }
        }
    }
    
    func textToSpeech(model: TextToSpeechModel, handler: @escaping Handler<TextToSpeachResponseModel>) {
        let url =  "\(Labiba._voiceBasePath)\(Labiba._voiceServicePath)"
        var endPoint = EndPoint(url: url, httpMethod: .post)
        endPoint.headers = ["Content-Type": "application/x-www-form-urlencoded"]
        let params:[String:Any] = [
            "text":Labiba.loggingAndRefferalEncodingType == .base64 ? model.text.toBase64() : model.text,
            "voicename" : model.googleVoice.voicename,
            "clientid" : model.clientid,
            "language" : model.googleVoice.language,
            "isSSML":"\(model.isSSML)",
            "type": "\(model.isBase64)"
        ]
        
        
        remoteContext.withTokenRequest(endPoint: endPoint, parameters: params) { result in
            switch  result {
            case .success(let data):
                self.parser(data: data, model: TextToSpeachResponseModel.self, handler: handler)
                let dataString = String(data: data, encoding: .utf8) ?? ""
                Logging.shared.logSuccessCase(url: url, tag: .voice, method: .post, parameter: params.description, response: dataString)
            case .failure(let error):
                handler(.failure(error))
                Logging.shared.log(url: url, tag: .voice, method: .post, parameter: params.description, response: error.response,exception: error.logDescription)
            }
        }
        
    }
    
    func sendLog(model: LoggingModel, handler: @escaping Handler<Bool>) {
        let url =  "\(Labiba._basePath)\(Labiba._loggingServicePath)"
        let endPoint = EndPoint(url: url, httpMethod: .post)
        
        let params = model.dictionary
        
        //        if Labiba.loggingAndRefferalEncodingType == .base64 {
        //            remoteContext.request(endPoint: endPoint, parameters: "\"\(params.toBase64()!)\"") { result in
        //                switch result {
        //                case .success(_):
        //                    print("log success")
        //                case .failure(let error):
        //                    print("log faild with error: \(error.localizedDescription)")
        //                }
        //            }
        //        }else{
        remoteContext.request(endPoint: endPoint, parameters: params) { result in
            switch result {
            case .success(_):
                print("log success")
            case .failure(let error):
                print("log faild with error: \(error.localizedDescription)")
            }
        }
        //        }
        
    }
    
    func downloadFile(fileURL: URL, handler: @escaping Handler<URL>)-> AnyCancelable {
        return remoteContext.downLoad(url: fileURL) { result in
            switch result {
            case .success(let url):
                handler(.success(url))
                Logging.shared.logSuccessCase(url:  fileURL.absoluteString, tag: .downloadVoiceClip, method: .get, parameter: "No Parameters", response: url.absoluteString)
            case .failure(let error):
                handler(.failure(error))
                Logging.shared.log(url: fileURL.absoluteString, tag: .downloadVoiceClip, method: .get, parameter: "No Parameters", response: error.response,exception: error.logDescription)
            }
        }
    }
    
    
    func getLabibaTheme(_ completionHandler:@escaping Handler<LabibaThemeModel>){
        let url = "https://api.npoint.io/79ab562d735a67229269"
        let endPoint = EndPoint(url: url, httpMethod: .get)
        remoteContext.requestWithGet(endpoint: endPoint, method: .get) { result in
            switch result{
            case .success(let data):
                self.dataParamParser(data: data, model: LabibaThemeModel.self, completion: completionHandler)
            case .failure(let error):
                print(error)
            }
        }
    }

    func getActiveQuestion(_ completionHandler:@escaping Handler<getActiveQuestionsResponseModel>){
        let url = "\(Labiba._basePath)/api/Nps/GetCurrentActiveQuestion/\(SharedPreference.shared.currentUserId)\(Labiba.isRateForAgent ? "/2" : "/1")"
        let endPoint = EndPoint(url: url, httpMethod: .get)

        remoteContext.withTokenRequest(endPoint: endPoint, parameters: getHeaders()) { result in
            switch result{
            case .success(let data):
                self.dataParamParser(data: data, model: getActiveQuestionsResponseModel.self, completion: completionHandler)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func sendTranscript(name:String, email:String, handler: @escaping Handler<EmptyModel>) {
        //        let url = "\(Labiba._basePath)/api/SendTranscript/SendChatHistoryEmail"
        let url = "https://botbuilder.labiba.ai/api/SendTranscript/SendChatHistoryEmail"
        
        let params: [String:Any] = ["Name":name,"FromEmail": Labiba.transcriptSenderEmail ?? "","Email":email,"History": SharedPreference.shared.formatConversation(userMessages: SharedPreference.shared.userMessages, botMessages: SharedPreference.shared.botMessages)
                                    , "startingTime": "","Duration":"",  "PageURL": "", "Title": "Chat Transcript", "IsContentEncrypted": true
                                    
        ]
        let endPoint = EndPoint(url: url, httpMethod: .post)
        
        remoteContext.withTokenRequest(endPoint: endPoint, parameters: params) { result in
            switch  result {
            case .success(let data):
                self.parser(data: data, model: EmptyModel.self, handler: handler)
                let dataString = String(data: data, encoding: .utf8) ?? ""
                Logging.shared.logSuccessCase(url: url, tag: .ratingSubmit, method: .post, parameter: params.description, response: dataString)
            case .failure(let error):
                handler(.failure(error))
                Logging.shared.log(url: url, tag: .ratingSubmit, method: .post, parameter: params.description, response: error.response,exception: error.logDescription)
            }
        }
    }
    
    func submitNPSScore(_ score:String,_ completionHandler:@escaping Handler<String?>){
        let url = "\(Labiba._basePath)/api/LiveChat/SubmitNpsScore"
        let endPoint = EndPoint(url: url, httpMethod: .post)
        let parameters:[String:Any] = ["LongClientId":"",
                                       "NpsQuestionTemplateLongId" : "",
                                       "ConversationId" : "",
                                       "Score" : score,
                                       "StoryId" : SharedPreference.shared.currentUserId,
                                       "SenderId" : Labiba._senderId ?? "",
                                       "npsQuestionTemplateLongId" : Labiba.npsQuestionTemplateLongId ?? ""
        ]
        
        remoteContext.withTokenRequest(endPoint: endPoint,parameters: parameters) { result in
            switch result{
            case .success(let data):
                self.dataParamParser(data: data, model: String?.self, completion: completionHandler)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getChatHistory(pageId:String,senderId:String,_ completionHandler:@escaping Handler<MessagesHistoryResponseModel>){
        let url = "\(Labiba._basePath)/api/ChatHistory/GetChatHistory?senderId=\(senderId)&pageId=\(pageId)"
        let endPoint = EndPoint(url: url, httpMethod: .post)
        
        remoteContext.withTokenRequest(endPoint: endPoint, parameters: [:]) { result in
            switch result{
            case .success(let data):
                self.dataParamParser(data: data, model: MessagesHistoryResponseModel.self, completion: completionHandler)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateChatHistoryStatus(messagesIds:[String]){
            let url = "\(Labiba._basePath)/api/ChatHistory/UpdateStatusMessage"
        let endPoint = EndPoint(url: url, httpMethod: .post,headers: ["Content-Type":"application/json"])
        let parameters: [String : Any] = [
                "messageIds" : messagesIds,
                "senderId" : Labiba._senderId ?? "",
                "pageId" : SharedPreference.shared.currentUserId,
                "status" : 2
            ]
        remoteContext.request(endPoint: endPoint, parameters: parameters) { result in
                switch result{
                case .success(let data):
                    self.dataParamParser(data: data, model: Int.self, completion: {_ in } )
                case .failure(let error):
                    print(error)
                }
            }
        }
    
    
    
    func getAgentName(_ completionHandler:@escaping Handler<GetAgentInfoResponseModel>){
        let url = "\(Labiba._basePath)/api/LiveChat/v1.0/GetAgentInfo/\(SharedPreference.shared.currentUserId)/\(Labiba._senderId ?? "")"
        let endPoint = EndPoint(url: url, httpMethod: .get)
        
        remoteContext.withTokenRequest(endPoint: endPoint, parameters: [:]) { result in
            switch result{
            case .success(let data):
                self.dataParamParser(data: data, model: GetAgentInfoResponseModel.self, completion: completionHandler)
            case .failure(let error):
                print(error)
            }
        }
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
            //  handler(.failure(ErrorModel(message: error.localizedDescription)))
            handler(.failure(LabibaError(error: error, statusCode: 200)))
        }
    }
    
    
    private func parserBase64<T:Decodable>(data:Data,model:T.Type, handler: @escaping Handler<T>) {
        
        let decoder =  JSONDecoder()
        do {
            if let base64Response = String(data: data, encoding: .utf8) {
                let refactoredBase64 = base64Response.replacingOccurrences(of: "\"", with: "")
                
                let response = refactoredBase64.base64URLDecode()
                if let response {
                    let model = try decoder.decode(T.self, from: response)
                    handler(.success(model))
                    return
                }
                
                handler(.failure(LabibaError(error: ErrorModel(message: "Error"), statusCode: 200)))
               
            }
            
            handler(.failure(LabibaError(error: ErrorModel(message: "Error"), statusCode: 200)))
            
        } catch {
            //  handler(.failure(ErrorModel(message: error.localizedDescription)))
            handler(.failure(LabibaError(error: error, statusCode: 200)))
        }
    }
    
    func dataParamParser<T:Decodable>(data:Data,model:T.Type, completion: @escaping Handler<T>) {
        let decoder =  JSONDecoder()
        do {
            let model = try decoder.decode(T.self, from: data)
            completion(.success(model))
        } catch {
            completion(.failure(LabibaError(error: ErrorModel(message: error.localizedDescription), statusCode: 200)))
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


struct EmptyModel: Codable{
    
}
