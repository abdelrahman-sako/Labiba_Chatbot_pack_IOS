//
//  BaseConnector.swift
//  LabibaBotClient_Example
//
//  Created by Suhayb Ahmad on 8/8/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//



import UIKit
import CoreLocation

//ssxxxxxx
protocol BotConnectorDelegate:AnyObject {
    
    func botConnector(_ botConnector:BotConnector, didRecieveActivity activity:ConversationDialog) -> Void
    func botConnector(_ botConnector:BotConnector, didRequestLiveChatTransferWithMessage message:String) -> Void
    func botConnector(_ botConnector:BotConnector, didRequestHumanAgent message:String) -> Void
    func botConnectorDidRecieveTypingActivity(_ botConnector:BotConnector) -> Void
    func botConnectorRemoveTypingActivity(_ botConnector:BotConnector) -> Void
}

protocol BotConnectorInterface:AnyObject {
    
    func botConnector(_ botConnector:BotConnector, didRecieveActivity activity:ConversationDialog) -> Void
    func botConnectorDidRecieveTypingActivity(_ botConnector:BotConnector) -> Void
}

class BotConnector: NSObject {
   
    
    
    
    var currentRequest: DataRequest?

    static let shared = BotConnector()
   // var loader = CircularGradientLoadingIndicator()
    

  //  private let LabibaUploadPath = "\(Labiba._basePath)/maker/FileUploader.ashx"
    fileprivate var LabibaUploadPath:String {
//        return "\(Labiba._basePath)/WebBotConversation/UploadHomeReport?id=\(SharedPreference.shared.currentUserId)"
        return "\(Labiba._uploadUrl)?id=\(SharedPreference.shared.currentUserId)"
    }
    var userId:String = "2314"
    var conversationId:String!
    var currentToken:String!
    
    weak var delegate:BotConnectorDelegate?
    var activitiesList = [ConversationDialog]()
    
    var clientId:String!
    var scenarioId:String!
    //MARK: Non implemented methodes
//    func configureInternetReachability() -> Void {}
//    func startConversation() -> Void {}
//    func sendGetStarted() -> Void {}
//    func reconnectConversation() -> Void {}
//    func resumeConnection() {}
//
//    func fetchHistory() -> Void {}
    
//    func sendMessage(_ message:String? = nil, payload:String? = nil, withAttachments attachments:[[String:Any]]? = nil, withEntities entities:[[String:Any]]? = nil) -> Void {}
    //func sendPhoto(_ photo: UIImage, withChoiceActionToken token:String) {}
//    func sendLocation(_ location:CLLocationCoordinate2D ) -> Void {}
    func sendVoice(_ voiceLocalPath:String, completion:@escaping (String?) -> Void) -> Void {}
//    func ShowDialog(){}
    
    //MARK: Initializer
    var messageAnalyizer:LabibaRestfulBotConnector!
    var sessionManager:SessionManager?
    var opQueue:OperationQueue?
    private override init() {
        super.init()

        messageAnalyizer = LabibaRestfulBotConnector()
        messageAnalyizer.delegate = self
        
    }
    

    var baseURL = "\(Labiba._basePath)\(Labiba._messagingServicePath)"
  

    var isTherePendingRequest:Bool = false
   
     func sendMessage(_ message: String? = nil, payload: String? = nil, withAttachments attachments: [[String : Any]]? = nil, withEntities entities: [[String : Any]]? = nil) {
        let pageId = Labiba._pageId;
        let senderId = Labiba._senderId;
        let time = Int(Date().timeIntervalSince1970 * 1000)
        let null = NSNull()
        var filteredMessage = message
        filteredMessage?.removeHiddenCharacters() // there is a hidden chars produced by Speech framework
        let msgLoad: [String: Any] = [
            "object": "page",
            "entry": [[
                "id": "221231835260127",
                "time": time,
                "messaging": [[
                    "Id": "00000000-0000-0000-0000-000000000000",
                    "sender": ["id": senderId],
                    "recipient": ["id": pageId],
                    "referral": Labiba._Referral,
                    "timestamp": time,
                    "message": (filteredMessage == nil && attachments == nil) ? null as Any : [
                        "mid": null,
                        "text": filteredMessage ?? null,
                        "messaging_type": null,
                        "attachments": (attachments ?? null) as Any
                    ] as [String: Any],
                    "postback": [
                        "payload": payload ?? null,
                        "referral": null
                    ] as [String: Any]
                ]]
            ]]
        ]
        print("\n***********************************  PARAMETERS  *********************************** \n")
        if let data = try? JSONSerialization.data(withJSONObject: msgLoad, options: .prettyPrinted)
        {
            print(String(data: data, encoding: .utf8)!)
        }
        print("\n*********************************** END PARAMETERS ***********************************\n")
        
        sendData(parameters: msgLoad)
        self.delegate?.botConnectorDidRecieveTypingActivity(self)
        Labiba.resetReferral()
        NotificationCenter.default.post(name: Constants.NotificationNames.ChangeTextViewKeyboardType,object:nil) // to rest keyboard content type
    }
    
    
     func startConversation() {
        // showLoadingIndicator()
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
             CircularGradientLoadingIndicator.show()
         }
         self.sendMessage("CONVERSATION-RELOAD")
    }
    
     
    
    func sendData(parameters:[String:Any])  {
        isTherePendingRequest = true
        DataSource.shared.messageHandler(model: parameters) { result in
            CircularGradientLoadingIndicator.dismiss()
            switch result {
            case .success(let model):
                self.messageAnalyizer.parseResponse(response: model)
            case .failure(let err):
                print(err.localizedDescription)
                showErrorMessage(err.localizedDescription)
                self.delegate?.botConnectorRemoveTypingActivity(self)
            }
            self.isTherePendingRequest = false
        }
        
        
      
        //        LabibaRequest([LabibaModel].self, url: baseURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, logTag: .messaging, completion: { response in
        //            self.loader.dismiss()
        //            switch response {
        //            case .success(let model):
        //                self.parseResponse(response: model)
        //            case .failure(let err):
        //                print(err.localizedDescription)
        //                showErrorMessage(err.localizedDescription)
        //                self.delegate?.botConnectorRemoveTypingActivity(self)
        //            }
        //            self.isTherePendingRequest = false
        //        })
        
    }
    
    func sendPhoto(_ photo: UIImage)
    {
        if let data = photo.jpegData(compressionQuality: 0.8)
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.delegate?.botConnectorDidRecieveTypingActivity(self)
            }
            let model = UploadDataModel(data: data, fileName: "photo.jpg", mimeType: "image/jpeg")
            DataSource.shared.uploadData(model: model) { result in
                switch result {
                case .success(let model):
                    if (model.urls?.count ?? 0) > 0, let link = model.urls?[0] {
                            self.sendMessage(withAttachments: [
                                [
                                    "type": "image",
                                    "payload": ["url": link]
                                ]
                            ])
                    }else {
                        self.sendMessage("Failure")
                    }
                case .failure(let err):
                    print(err.localizedDescription)
                    showErrorMessage(err.localizedDescription)
                    self.delegate?.botConnectorRemoveTypingActivity(self)
                }
            }
        }
    }
    
    
    func sendFile(_ url: URL) {
        if let data = try? Data(contentsOf: url)
        {
            self.delegate?.botConnectorDidRecieveTypingActivity(self)
            let model = UploadDataModel(data: data, fileName: url.lastPathComponent, mimeType: url.mimeType)
            DataSource.shared.uploadData(model: model){ result in
                switch result {
                case .success(let model):
                    if (model.urls?.count ?? 0) > 0, let link = model.urls?[0] {
                        if let fileURL = URL(string: link) {
                            let dialog = ConversationDialog(by: .user, time: Date())
                            dialog.attachment = AttachmentCard(link: link)
                            self.delegate?.botConnector(self, didRecieveActivity: dialog)
                            self.sendMessage(withAttachments: [
                                [
                                    "type": fileURL.isImage() ?  "image":"file",
                                    "payload": ["url": link]
                                ]
                            ])
                        }
                    }else {
                        self.sendMessage("Failure")
                    }
                case .failure(let err):
                    print(err.localizedDescription)
                    showErrorMessage(err.localizedDescription)
                    self.delegate?.botConnectorRemoveTypingActivity(self)
                }
                
            }
        }
    }
    
    func getLastBotResponse()  {
        //        let params:[String:String] = [
        //            "RecepientID" :Labiba._pageId,
        //            "SenderID":Labiba._senderId
        //        ]
        //        let url = "\(Labiba._basePath)/api/getLastBotResponse"
        
        self.delegate?.botConnectorDidRecieveTypingActivity(self)
        
        //        LabibaRequest(LastBotResponseModel.self, url: url, method: .post, parameters: params, encoding: JSONEncoding.default, logTag: .lastMessage, completion: { response in
        //            self.loader.dismiss()
        //            switch response {
        //            case .success(let model):
        //                if let labibaModel = model.lastBotResponse {
        //                    self.parseResponse(response: labibaModel)
        //                }
        //            case .failure(let err):
        //                print(err.localizedDescription)
        //                showErrorMessage(err.localizedDescription)
        //                self.delegate?.botConnectorRemoveTypingActivity(self)
        //            }
        //        })
        DataSource.shared.getLastBotResponse { response in
            //self.loader.dismiss()
            switch response {
            case .success(let model):
                if let labibaModel = model.lastBotResponse {
                    self.messageAnalyizer.parseResponse(response: labibaModel)
                }
            case .failure(let err):
                print(err.localizedDescription)
                showErrorMessage(err.localizedDescription)
                self.delegate?.botConnectorRemoveTypingActivity(self)
            }
        }
    }
    
     func resumeConnection() {
        if isTherePendingRequest {
            isTherePendingRequest = false
            currentRequest?.cancel()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.getLastBotResponse()
            }
            
        }
    }
    
     func sendLocation(_ location: CLLocationCoordinate2D) {
        let attachment =
        [["payload":["coordinates":[
            "lat":location.latitude ,
            "long" :location.longitude]],
          "type":"location"]]
        self.sendMessage(withAttachments :attachment)
    }
    //MARK: Implemented methodes
    
    func ShowDialog(){
        messageAnalyizer.ShowDialog()
    }
//    func showLoadingIndicator() {
//        loader.LoadingText = "\("loading".localForChosnLangCodeBB) ..."
//        loader.show()
//    }
//     func sendPhoto(_ photo: UIImage)
//    {
//        if let data = photo.jpegData(compressionQuality: 0.8)
//        {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                self.delegate?.botConnectorDidRecieveTypingActivity(self)
//            }
//            uploadDataToLabiba(filename: "photo.jpg", data: data,mimetype: "image/jpeg")
//            { (url) in
//
//                if let imgUrl = url
//                {
//                    self.sendMessage(withAttachments: [
//                        [
//                            "type": "image",
//                            "payload": ["url": imgUrl]
//                        ]
//                        ])
//                }else{
//                    self.sendMessage("Failure")
//                }
//            }
//        }
//    }

//
//    func sendFile(_ url: URL) {
//        if let data = try? Data(contentsOf: url)
//        {
//            self.delegate?.botConnectorDidRecieveTypingActivity(self)
//            uploadDataToLabiba(filename: url.lastPathComponent, data: data, mimetype: url.mimeType)
//            { (fileURL) in
//
//                if let fileURL = fileURL
//                {
//                    let dialog = ConversationDialog(by: .user, time: Date())
//                    dialog.attachment = AttachmentCard(link: fileURL)
//                    self.delegate?.botConnector(self, didRecieveActivity: dialog)
//                    self.sendMessage(withAttachments: [
//                        [
//                            "type": url.isImage() ?  "image":"file",
//                            "payload": ["url": fileURL]
//                        ]
//                    ])
//                }else{
//                    self.sendMessage("Failure")
//                }
//            }
//        }
//    }
//
//
//
//    func uploadDataToLabiba(filename: String, data: Data,mimetype:String, completion: @escaping (String?) -> Void) -> Void
//    {
//      // let LabibaUploadPath = "https://botbuilder.labiba.ai/WebBotConversation/UploadHomeReport?id=\(SharedPreference.shared.currentUserId)" // we add this since the old one produce 500 due to a viruse as nour said
//
//        upload(multipartFormData: { (formData) in
//
//            formData.append(data, withName: "Filedata", fileName: filename, mimeType: mimetype)
//
//        }, to: LabibaUploadPath, encodingCompletion: createEncodingBlock(completion: completion))
//    }
  
//    func textToSpeech(model:TextToSpeechModel, completion: @escaping (Result<String>) -> Void){
//        let path = "\(Labiba._voiceBasePath)\(Labiba._voiceServicePath)"
//
//        let params:[String:Any] = [
//            "text":model.text,
//            // "text":model.testText(),
//            "voicename" : model.googleVoice.voicename,
//            "clientid" : model.clientid,
//            "language" : model.googleVoice.language,
//            "isSSML":"\(model.isSSML)"
//        ]
//        LabibaRequest([String:String].self,url: path, method: .post, parameters: params, encoding: URLEncoding(), logTag: .voice) { (result) in
//            switch result {
//            case .success(let model):
//                completion(.success(model["file"] ?? ""))
//            case .failure(let err):
//                completion(.failure(err))
//            }
//        }
//    }
    
//    func submitRating(ratingModel:SubmitRatingModel, completion: @escaping (Result<Bool>) -> Void){
//        let path = "\(Labiba._basePath)/api/ratingform/submit"//Labiba._submitRatingPath
//        guard let data = try? JSONEncoder().encode(ratingModel)  else {
//            return
//        }
//        do {
//            let params = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
//            prettyPrintedResponse(data: data, name: "Submit Rating Form")
//            showLoadingIndicator()
//            LabibaRequest([String:Bool].self, url: path, method: .post, parameters: params, encoding:JSONEncoding.default , logTag: .ratingSubmit) { (result) in
//                switch result {
//                case .success(let model):
//                    if  let result = model["response"] {
//                        completion(.success(result))
//                    }else{
//                        let error = LabibaError(code: .EncodingError, statusCode: 0)
//                        completion(.failure(error))
//                    }
//                case .failure(let err):
//                    completion(.failure(err))
//                }
//               // self.loader.dismiss()
//            }
//        }catch let err{
//            completion(.failure(err))
//        }
//    }
    
//    func getRatingQuestions(completion: @escaping (Result<[GetRatingFormQuestionsModel]>) -> Void){
//        let path = "\(Labiba._basePath)/api/MobileAPI/FetchQuestions"//Labiba._ratingQuestionsPath
//        let params:[String:Any] = [
//            "bot_id" : SharedPreference.shared.currentUserId// "d0b8e34a-26ba-4ed6-a2af-4412b55ef442"
//        ]
//        showLoadingIndicator()
//        LabibaRequest([GetRatingFormQuestionsModel].self, url: path, method: .get, parameters: params, encoding: URLEncoding.default, logTag: .ratingQuestions) { (result) in
//            switch result {
//            case .success(let model):
//                completion(.success(model))
//            case .failure(let err):
//                completion(.failure(err))
//            }
//          //  self.loader.dismiss()
//        }
//    }
    
//    func getHelpPageData(completion: @escaping (Result<HelpPageModel>) -> Void){
//        let path = Labiba._helpUrl//"\(Labiba._basePath)\(Labiba._helpServicePath)"
//        let params:[String:Any] = [
//            "bot_id" : SharedPreference.shared.currentUserId // "6bd2ecb6-958e-4bb5-905a-51bb6350490a"
//        ]
//        showLoadingIndicator()
//        LabibaRequest(HelpPageModel.self, url: path, method: .get, parameters: params, encoding: URLEncoding.default, logTag: .help) { (result) in
//            switch result {
//            case .success(let model):
//                completion(.success(model))
//            case .failure(let err):
//                completion(.failure(err))
//            }
//            //self.loader.dismiss()
//        }
//    }
//    
//    func getPrechatForm(completion: @escaping (Result<[PrechatFormModel.Item]>) -> Void) {
//        let path = "\(Labiba._basePath)\(Labiba._prechatFormServicePath)"
//        let params:[String:Any] = [
//            "bot_id" : SharedPreference.shared.currentUserId
//        ]
//        showLoadingIndicator()
//        LabibaRequest([PrechatFormModel].self, url: path, method: .get, parameters: params, encoding: URLEncoding.default, logTag: .prechatForm) { (result) in
//            switch result {
//            case .success(let model):
//                if model.count > 0 {
//                completion(.success(model[0].Data ?? []))
//                }else {
//                    let error = LabibaError(code: .EmptyResponse, statusCode: 0)
//                    completion(.failure(error))
//                }
//            case .failure(let err):
//                completion(.failure(err))
//            }
//           // self.loader.dismiss()
//        }
//    }
    
//    func updateToken(completion: @escaping ()->Void)  {
//        let path = Labiba._updateTokenUrl
//        let params:[String:Any] = [
//            "Username":Labiba.jwtAuthParamerters.username,
//            "Password":Labiba.jwtAuthParamerters.password
//        ]
//        DispatchQueue.global(qos: .background).sync { [weak self] in
//            LabibaRequest(UpdateTokenModel.self, url: path, method: .post, parameters: params, encoding: JSONEncoding.default, logTag: .upadateToken) { result in
//                switch result {
//                case .success(let model):
//                    UpdateTokenModel.saveToken(token: model.token)
//                    self?.sessionManagerConfiguration(token: model.token ?? "")
//                    print("token updated")
//                    completion()
//                case .failure(let err):
//                    showErrorMessage(err.localizedDescription)
//                }
//
//            }
//        }
//    }
    func LabibaRequest<T:Codable>(_ model:T.Type,url:String,method:HTTPMethod,parameters: Parameters? = nil,headers:[String:String]? = nil,encoding: ParameterEncoding = URLEncoding.default,logTag:LoggingTag? = nil, completion: @escaping (Result<T>)->Void) {

        if UpdateTokenModel.isTokenRequeird(){
            if !UpdateTokenModel.isTokenValid() && logTag != .upadateToken {
                updateToken(completion: { [weak self] in
                    self?.LabibaRequest(model, url: url, method: method,parameters: parameters,encoding:encoding,logTag:logTag,completion:completion)

                })
                return
            }
        }

        let log:(_ respons:String,_ exception:String?)->Void = { respons,exception in
            if let logTag = logTag {
                let additionalHeaders = (self.sessionManager?.session.configuration.httpAdditionalHeaders as? [String:String] ?? [:]).description
                self.log(url: url,headers: additionalHeaders,tag: logTag, method: method, parameter: parameters?.description ?? "", response: respons,exception: exception)
            }
        }
        opQueue?.addOperation({
            self.currentRequest = self.sessionManager?.request(url, method: method, parameters: parameters ,encoding: encoding , headers: headers).responseData { (response) in

                let statusCode = response.response?.statusCode ?? 0
                //print(response.response?.allHeaderFields)
                switch response.result{
                case .success(let data):

                    prettyPrintedResponse(url: url, statusCode:statusCode,method:method.rawValue,data: data, name: URL(string: url)?.lastPathComponent ?? "request")
                    let dataString = String(data: data , encoding: .utf8) ?? ""

                    do {
                        let response = try JSONDecoder().decode(T.self, from: data)
                        if let array =  response as? Array<Any>,  array.isEmpty , !Labiba.isHumanAgentStarted {
                            //isHumanAgentStarted  because it return empty string if human agent started and it is not error
                            let error = LabibaError(code: .EmptyResponse, statusCode: statusCode)
                            log(dataString, error.logDescription)
                            completion(.failure(error))
                        }else{
                            if Labiba.Logging.isSuccessLoggingEnabled { log(dataString, nil) }
                            completion(.success(response))
                        }

                    }catch{
                        let resposeHeaders = response.response?.allHeaderFields
                        let error = LabibaError(statusCode: statusCode,headers: resposeHeaders) ?? LabibaError(code: .EncodingError, statusCode: statusCode,headers: resposeHeaders)
                        log(dataString, error.logDescription)
                        completion(.failure(error))
                    }

                case .failure(let err):
                    let error = LabibaError(error: err, statusCode: statusCode)
                    log("", error.logDescription)
                    completion(.failure(error))
                }

                self.loader.dismiss()
            }
        })

    }
    
    enum LoggingTag:String {
        case messaging = "MESSAGING"
        case lastMessage = "GET_LAST_MESSAGE"
        case upload  = "UPLOAD_FILES"
        case voice  = "VOICE"
        case ratingQuestions = "GET_RATING_QUESTIONS"
        case ratingSubmit = "SUBMIT_RATING"
        case help = "HELP"
        case prechatForm = "PRECHAT_FORM"
        case upadateToken = "UPDATE_TOKEN"
        
        var exception:String {
            return rawValue + "_ERROR"
        }
        
        var normal:String {
            return rawValue
        }
    }
    
    func log(url:String,headers:String? = nil,tag:LoggingTag,method:HTTPMethod,parameter:String ,response:String,exception:String? = nil) {
        guard Labiba.Logging.isEnabled else {
            return
        }
        UIDevice.current.isBatteryMonitoringEnabled = true
        DispatchQueue.global(qos: .background).async {
            let deviceDetails:String = """
ModelName: \(UIDevice.modelName)
SystemName: \(UIDevice.current.systemName)
SystemVersion: \(UIDevice.current.systemVersion)
Model: \(UIDevice.current.model)
BatteryLevel: \(UIDevice.current.batteryLevel*100)%
"""
            let requestDetails:String = """
URL: \(url)
Method: \(method.rawValue)
Headers:\(headers ?? "")
Body: \(parameter)
"""
            let userDetails:String = """
SenderID: \(Labiba._senderId ?? "")
RecepientID: \(Labiba._pageId)
"""
            var filterdRespose = response
            if filterdRespose.range(of: "<[a-z][\\s\\S]*>", options: .regularExpression, range: nil, locale: nil) != nil
                && exception != nil {
                // exception != nil : this condition is to pass the ssml part in successful requests
                //  romove  HTML tags in the following line because server may consider HTML as an attack code:403
                filterdRespose = "HTML response" + filterdRespose.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "")
            }
       
            
            let body:[String:String] = [
                "Source":"IOS",
                "Tag": exception == nil ? tag.normal : tag.exception ,
                "DeviceDetails":deviceDetails,
                "UserDetails":userDetails,
                "Request":requestDetails,
                "Response":filterdRespose,
                "Exception":exception ?? "Success",
                "SDKVersion":Labiba.version
            ]
            let data = try! JSONEncoder().encode(body)
            prettyPrintedResponse(data: data)
            let url =  "\(Labiba._basePath)\(Labiba._loggingServicePath)"//Labiba._loggingPath
            //let url = "https://botbuilder.labiba.ai/api/MobileAPI/MobileLogging"
            DispatchQueue.global(qos: .background).async {
                self.sessionManager?.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseData { (response) in
                    print ( "log api " ,response.response?.statusCode ?? "0")
                    if  response.error != nil {
                        return
                    }
                    guard let data  = response.data else  {
                        return
                    }
                    
                    print("log success data\(String(data: data, encoding: .utf8) ?? "")")
                }
            }
        }

    }
   
}



//fileprivate typealias EncodingCompletionBlock = (SessionManager.MultipartFormDataEncodingResult) -> Void
//fileprivate func createEncodingBlock(completion: @escaping (String?) -> Void) -> EncodingCompletionBlock
//{
//    
//    let encodeCompletion: EncodingCompletionBlock = { (encodeRes) in
//        let log:(_ respons:String,_ exception:String)->Void = { respons,exception in
//            let botConnector = BotConnector.shared
//            botConnector.log(url: botConnector.LabibaUploadPath, tag: BotConnector.LoggingTag.upload, method: .post, parameter: "", response: respons,exception: exception)
//        }
//        switch encodeRes
//        {
//        
//        case .success(let request, _, _):
//            request.response { (data) in
//                if let data = data.data{
//                    print(String(data: data, encoding: .utf8))
//                }
//            }
//            request.responseSwiftyJSON(completionHandler: { (res) in
//                
//                switch res.result
//                {
//                
//                case .success(let json):
//                    
//                    // var url = json["url"].string
//                    // if url != nil && url!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
//                    // {
//                    //     url = nil
//                    // }
//                    
//                    let urls = json["urls"].array
//                    if urls?.count ?? 0 > 0 {
//                        if let url = urls![0].string, !url.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//                            completion(url)
//                            return
//                        }
//                    }
//                    completion(nil)
//                    
//                case .failure:
//                    log("","upload fail")
//                    completion(nil)
//                }
//                
//            })
//            
//        case .failure:
//            log("","upload fail")
//            completion(nil)
//        }
//    }
//    
//    return encodeCompletion
//}

extension BotConnector:LocationServiceDelegate {
    func locationService(_ service: LocationService, didReceiveLocation location: CLLocationCoordinate2D) {
        sendLocation(location)
    }
}

extension BotConnector: URLSessionDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
       //Trust the certificate even if not valid
       let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)

       completionHandler(.useCredential, urlCredential)
    }
}

extension BotConnector : MessageAnalyizerDelegate {
    func botConnector(didRecieveActivity activity: ConversationDialog) {
        delegate?.botConnector(self, didRecieveActivity: activity)
    }
    
    func botConnector(didRequestLiveChatTransferWithMessage message: String) {
        delegate?.botConnector(self, didRequestLiveChatTransferWithMessage: message)
    }
    
    func botConnector(didRequestHumanAgent message: String) {
        delegate?.botConnector(self, didRequestHumanAgent: message)
    }
    
    func botConnectorDidRecieveTypingActivity() {
        delegate?.botConnectorRemoveTypingActivity(self)
    }
    
    func botConnectorRemoveTypingActivity() {
        delegate?.botConnectorRemoveTypingActivity(self)
    }
    func sendGetStarted() {
       self.sendMessage("get started")
   }
}
