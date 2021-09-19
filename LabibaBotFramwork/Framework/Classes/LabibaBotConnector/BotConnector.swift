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
protocol BotConnectorDelegate:class {
    
    func botConnector(_ botConnector:BotConnector, didRecieveActivity activity:ConversationDialog) -> Void
    func botConnector(_ botConnector:BotConnector, didRequestLiveChatTransferWithMessage message:String) -> Void
    func botConnector(_ botConnector:BotConnector, didRequestHumanAgent message:String) -> Void
    func botConnectorDidRecieveTypingActivity(_ botConnector:BotConnector) -> Void
    func botConnectorRemoveTypingActivity(_ botConnector:BotConnector) -> Void
}

protocol BotConnectorInterface:class {
    
    func botConnector(_ botConnector:BotConnector, didRecieveActivity activity:ConversationDialog) -> Void
    func botConnectorDidRecieveTypingActivity(_ botConnector:BotConnector) -> Void
}

enum NetworkError: String, Error {
    case badURL
    case encodingError = "Encoding error"
}
extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badURL:
            return "unvalid url"
        case .encodingError:
            return "response could not be decoded"
        }
    }
}
class BotConnector: NSObject {
    
    var currentRequest: DataRequest?

    var loader = CircularGradientLoadingIndicator()
    

  //  private let LabibaUploadPath = "\(Labiba._basePath)/maker/FileUploader.ashx"
    fileprivate var LabibaUploadPath:String {
        return "\(Labiba._basePath)/WebBotConversation/UploadHomeReport?id=\(SharedPreference.shared.currentUserId)"
    }
    var userId:String = "2314"
    var conversationId:String!
    var currentToken:String!
    
    weak var delegate:BotConnectorDelegate?
    var activitiesList = [ConversationDialog]()
    
    var clientId:String!
    var scenarioId:String!
    //MARK: Non implemented methodes
    func configureInternetReachability() -> Void {}
    func startConversation() -> Void {}
    func sendGetStarted() -> Void {}
    func reconnectConversation() -> Void {}
    func resumeConnection() {}
    func close() -> Void {
        print("Request \"\(currentRequest?.request?.url?.absoluteString ?? "")\" was canceld")
        currentRequest?.cancel()
    }
    
    func fetchHistory() -> Void {}
    
    func sendMessage(_ message:String? = nil, payload:String? = nil, withAttachments attachments:[[String:Any]]? = nil, withEntities entities:[[String:Any]]? = nil) -> Void {}
//    func sendPhoto(_ photo:UIImage ) {}
    func sendPhoto(_ photo: UIImage, withChoiceActionToken token:String) {}
    func sendLocation(_ location:CLLocationCoordinate2D ) -> Void {}
    func sendVoice(_ voiceLocalPath:String, completion:@escaping (String?) -> Void) -> Void {}
    func ShowDialog(){}
    
    
     //MARK: Implemented methodes
    
    
    func showLoadingIndicator() {
        loader.LoadingText = "\("loading".localForChosnLangCodeBB) ..."
        loader.show()
    }
     func sendPhoto(_ photo: UIImage)
    {
        if let data = photo.jpegData(compressionQuality: 0.8)
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.delegate?.botConnectorDidRecieveTypingActivity(self)
            }
            uploadDataToLabiba(filename: "photo.jpg", data: data,mimetype: "image/jpeg")
            { (url) in
                
                if let imgUrl = url
                {
                    self.sendMessage(withAttachments: [
                        [
                            "type": "image",
                            "payload": ["url": imgUrl]
                        ]
                        ])
                }else{
                    self.sendMessage("Failure")
                }
            }
        }
    }
    func sendFile(_ url: URL) {
        if let data = try? Data(contentsOf: url)
        {
            self.delegate?.botConnectorDidRecieveTypingActivity(self)
            uploadDataToLabiba(filename: url.lastPathComponent, data: data, mimetype: url.mimeType)
            { (fileURL) in
              
                if let fileURL = fileURL
                {
                    let dialog = ConversationDialog(by: .user, time: Date())
                    dialog.attachment = AttachmentCard(link: fileURL)
                    self.delegate?.botConnector(self, didRecieveActivity: dialog)
                    self.sendMessage(withAttachments: [
                        [
                            "type": url.isImage() ?  "image":"file",
                            "payload": ["url": fileURL]
                        ]
                    ])
                }else{
                    self.sendMessage("Failure")
                }
            }
        }
    }

    
    func uploadDataToLabiba(filename: String, data: Data,mimetype:String, completion: @escaping (String?) -> Void) -> Void
    {
      // let LabibaUploadPath = "https://botbuilder.labiba.ai/WebBotConversation/UploadHomeReport?id=\(SharedPreference.shared.currentUserId)" // we add this since the old one produce 500 due to a viruse as nour said
        
        upload(multipartFormData: { (formData) in
            
            formData.append(data, withName: "Filedata", fileName: filename, mimeType: mimetype)
            
        }, to: LabibaUploadPath, encodingCompletion: createEncodingBlock(completion: completion))
    }
  
    func textToSpeech(model:TextToSpeechModel, completion: @escaping (Result<String>) -> Void){
        let path = "\(Labiba._voiceBasePath)\(Labiba._voiceServicePath)"
        
        let params:[String:Any] = [
            "text":model.text,
            // "text":model.testText(),
            "voicename" : model.googleVoice.voicename,
            "clientid" : model.clientid,
            "language" : model.googleVoice.language,
            "isSSML":"\(model.isSSML)"
        ]
        LabibaRequest([String:String].self,url: path, method: .post, parameters: params, encoding: URLEncoding(), logTag: .voice) { (result) in
            switch result {
            case .success(let model):
                completion(.success(model["file"] ?? ""))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
    
    func submitRating(ratingModel:SubmitRatingModel, completion: @escaping (Result<Bool>) -> Void){
        let path = "\(Labiba._basePath)/api/ratingform/submit"//Labiba._submitRatingPath
        guard let data = try? JSONEncoder().encode(ratingModel)  else {
            return
        }
        do {
            let params = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
            prettyPrintedResponse(data: data, name: "Submit Rating Form")
            showLoadingIndicator()
            LabibaRequest([String:Bool].self, url: path, method: .post, parameters: params, encoding:JSONEncoding.default , logTag: .ratingSubmit) { (result) in
                switch result {
                case .success(let model):
                    if  let result = model["response"] {
                        completion(.success(result))
                    }else{
                        completion(.failure(NetworkError.encodingError))
                    }
                case .failure(let err):
                    completion(.failure(err))
                }
                self.loader.dismiss()
            }
        }catch let err{
            completion(.failure(err))
        }
    }
    
    func getRatingQuestions(completion: @escaping (Result<[GetRatingFormQuestionsModel]>) -> Void){
        let path = "\(Labiba._basePath)/api/MobileAPI/FetchQuestions"//Labiba._ratingQuestionsPath
        let params:[String:Any] = [
            "bot_id" : SharedPreference.shared.currentUserId// "d0b8e34a-26ba-4ed6-a2af-4412b55ef442"
        ]
        showLoadingIndicator()
        LabibaRequest([GetRatingFormQuestionsModel].self, url: path, method: .get, parameters: params, encoding: URLEncoding.default, logTag: .ratingQuestions) { (result) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure(let err):
                completion(.failure(err))
            }
            self.loader.dismiss()
        }
    }
    
    func getHelpPageData(completion: @escaping (Result<HelpPageModel>) -> Void){
        let path = "\(Labiba._basePath)\(Labiba._helpServicePath)"//Labiba._helpPath
        let params:[String:Any] = [
            "bot_id" : SharedPreference.shared.currentUserId // "6bd2ecb6-958e-4bb5-905a-51bb6350490a"
        ]
        showLoadingIndicator()
        LabibaRequest(HelpPageModel.self, url: path, method: .get, parameters: params, encoding: URLEncoding.default, logTag: .help) { (result) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure(let err):
                completion(.failure(err))
            }
            self.loader.dismiss()
        }
    }
    
    func getPrechatForm(completion: @escaping (Result<[PrechatFormModel]>) -> Void) {
        let path = "path"
        let params:[String:Any] = [
            "bot_id" : SharedPreference.shared.currentUserId // "6bd2ecb6-958e-4bb5-905a-51bb6350490a"
        ]
        showLoadingIndicator()
        
        func readExampleData() -> Data {
            if let path = Labiba.bundle.url(forResource: "JsonExample1", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: path, options: .mappedIfSafe)
                    return data
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                    {
                        print(jsonArray) // use the json here
                    } else {
                        print("bad json")
                    }
                } catch {
                    print(error)
                }
            }
            
            return Data()
        }
        let jsonDecoder = JSONDecoder()
        do {
            let model = try jsonDecoder.decode([PrechatFormModel].self, from: readExampleData())
            completion(.success(model))
            self.loader.dismiss()
        } catch {
            print(error.localizedDescription)
        }
        
//        LabibaRequest([PrechatFormModel].self, url: path, method: .get, parameters: params, encoding: URLEncoding.default, logTag: .prechatForm) { (result) in
//            switch result {
//            case .success(let model):
//                completion(.success(model))
//            case .failure(let err):
//                completion(.failure(err))
//            }
//            self.loader.dismiss()
//        }
    }
    
    func LabibaRequest<T:Codable>(_:T.Type,url:String,method:HTTPMethod,parameters: Parameters? = nil,encoding: ParameterEncoding = URLEncoding.default,logTag:LoggingTag? = nil, completion: @escaping (Result<T>)->Void) {
        let log:(_ respons:String,_ exception:String)->Void = { respons,exception in
            if let logTag = logTag {
                self.log(url: url, tag: logTag, method: method, parameter: parameters?.description ?? "", response: respons,exception: exception)
            }
        }
        request(url, method: method, parameters: parameters ,encoding: encoding , headers: nil ).responseData { (response) in
            switch response.result{
            case .success(let data):
                let statusCode = response.response?.statusCode ?? 0
                prettyPrintedResponse(url: url, statusCode:statusCode,method:method.rawValue,data: data, name: URL(string: url)?.lastPathComponent ?? "request")
                do {
                    let response = try JSONDecoder().decode(T.self, from: data)
                    //log("ios","ios")
                    completion(.success(response))
                }catch{
                    log(String(data: data , encoding: .utf8) ?? "",NetworkError.encodingError.localizedDescription)
                    completion(.failure(NetworkError.encodingError))
                }
            case .failure(let err):
                log("",err.localizedDescription)
                completion(.failure(err))
                
            }
        }
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
    }
    
    func log(url:String,headers:String? = nil,tag:LoggingTag,method:HTTPMethod,parameter:String ,response:String,exception:String? = nil) {
        guard Labiba.isLoggingEnabled else {
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
Name:
PhoneNumber:
Email:
"""
            var filterdRespose = response
            if response.range(of: "<[a-z][\\s\\S]*>", options: .regularExpression, range: nil, locale: nil) != nil {
                filterdRespose = "HTML response"
            }
            let body:[String:String] = [
                "Source":"IOS",
                "Tag":tag.rawValue,
                "DeviceDetails":deviceDetails,
                "UserDetails":userDetails,
                "Request":requestDetails,
                "Response":filterdRespose,
                "Exception":exception ?? "",
                "SDKVersion":Labiba.version
            ]
            let data = try! JSONEncoder().encode(body)
            prettyPrintedResponse(data: data)
            let url =  "\(Labiba._basePath)\(Labiba._loggingServicePath)"//Labiba._loggingPath
            DispatchQueue.global(qos: .background).async {
                request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseData { (response) in
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



fileprivate typealias EncodingCompletionBlock = (SessionManager.MultipartFormDataEncodingResult) -> Void
fileprivate func createEncodingBlock(completion: @escaping (String?) -> Void) -> EncodingCompletionBlock
{
    
    let encodeCompletion: EncodingCompletionBlock = { (encodeRes) in
        let log:(_ respons:String,_ exception:String)->Void = { respons,exception in
            let botConnector = BotConnector()
            botConnector.log(url: botConnector.LabibaUploadPath, tag: BotConnector.LoggingTag.upload, method: .post, parameter: "", response: respons,exception: exception)
        }
        switch encodeRes
        {
        
        case .success(let request, _, _):
            request.response { (data) in
                if let data = data.data{
                    print(String(data: data, encoding: .utf8))
                }
            }
            request.responseSwiftyJSON(completionHandler: { (res) in
                
                switch res.result
                {
                
                case .success(let json):
                    
                    // var url = json["url"].string
                    // if url != nil && url!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    // {
                    //     url = nil
                    // }
                    
                    let urls = json["urls"].array
                    if urls?.count ?? 0 > 0 {
                        if let url = urls![0].string, !url.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            completion(url)
                            return
                        }
                    }
                    completion(nil)
                    
                case .failure:
                    log("","upload fail")
                    completion(nil)
                }
                
            })
            
        case .failure:
            log("","upload fail")
            completion(nil)
        }
    }
    
    return encodeCompletion
}

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
