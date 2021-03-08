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
    func botConnectorDidRecieveTypingActivity(_ botConnector:BotConnector) -> Void
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
    

    private let LabibaUploadPath = "\(Labiba._basePath)/maker/FileUploader.ashx"
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
    func reconnectConversation() -> Void {}
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
            uploadDataToLabiba(filename: "photo.jpg", data: data)
            { (url) in
                
                if let imgUrl = url
                {
                    self.sendMessage(withAttachments: [
                        [
                            "type": "image",
                            "payload": ["url": imgUrl]
                        ]
                        ])
                }
            }
        }
    }
    func sendFile(_ url: URL) {
        if let data = try? Data(contentsOf: url)
        {
            self.delegate?.botConnectorDidRecieveTypingActivity(self)
            uploadDataToLabiba(filename: url.lastPathComponent, data: data)
            { (url) in
              
                if let fileURL = url
                {
                    let dialog = ConversationDialog(by: .user, time: Date())
                    dialog.attachment = AttachmentCard(link: fileURL)
                    self.delegate?.botConnector(self, didRecieveActivity: dialog)
                    self.sendMessage(withAttachments: [
                        [
                             "type": "file",
                          //  "type": "image",
                            "payload": ["url": fileURL]
                        ]
                    ])
                }
            }
        }
    }

    
    func uploadDataToLabiba(filename: String, data: Data, completion: @escaping (String?) -> Void) -> Void
    {
       let LabibaUploadPath = "https://botbuilder.labiba.ai/WebBotConversation/UploadHomeReport?id=\(SharedPreference.shared.currentUserId)" // we add this since the old one produce 500 due to a viruse as nour said
        upload(multipartFormData: { (formData) in
            
            formData.append(data, withName: "Filedata", fileName: filename, mimeType: "")
            
        }, to: LabibaUploadPath, encodingCompletion: createEncodingBlock(completion: completion))
    }
     class MyServerTrustPolicyManager: ServerTrustPolicyManager {
           open override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
               return ServerTrustPolicy.disableEvaluation
           }
       }
    func textToSpeech(model:TextToSpeechModel, completion: @escaping (Result<String>) -> Void){
        let path = "\(Labiba._voiceBasePath)\(Labiba._voiceServicePath)"
        
        let params:[String:Any] = [
            "text":model.text,
            "voicename" : model.googleVoice.voicename,
            "clientid" : model.clientid,
            "language" : model.googleVoice.language,
            "isSSML":"\(model.isSSML)"
        ]
    print("url ", path , "\n params \n ",params)
        
        
      currentRequest =   request(path, method: .post, parameters: params ,encoding: URLEncoding(), headers: nil ).responseData { (response) in
            // URLEncoding() -> application/x-www-form-urlencoded
            switch response.result{
            case .success(_):
                do {
                    let response = try JSONDecoder().decode([String:String].self, from: response.data ?? Data())
                    if  let result = response["status"] , result == "success" {
                        if let file = response["file"] {
                            print(file)
                            completion(.success(file))
                        }
                    }else{
                        completion(.failure(NetworkError.encodingError))
                    }
                }catch{
                    completion(.failure(NetworkError.encodingError))
                }
            case .failure(let err):
                completion(.failure(err))
            }
            self.loader.dismiss()
        }
    }
    
    func submitRating(ratingModel:SubmitRatingModel, completion: @escaping (Result<Bool>) -> Void){
        let path = "https://botbuilder.labiba.ai/api/ratingform/submit"
        guard let data = try? JSONEncoder().encode(ratingModel)  else {
            return
        }
        
        
        do {
            let params = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
            let prettyPrintedData = try JSONSerialization.data(withJSONObject: params!, options: .prettyPrinted)
            print(String(data: prettyPrintedData, encoding: .utf8)!)
            showLoadingIndicator()
            request(path, method: .post, parameters: params ,encoding: JSONEncoding.default , headers: nil ).responseData { (response) in
                
                switch response.result{
                case .success(let data):
                    
                    print(String(data: data , encoding: .utf8))
                    do {
                        let response = try JSONDecoder().decode([String:Bool].self, from: data)
                        if  let result = response["response"] {
                            completion(.success(result))
                        }else{
                            completion(.failure(NetworkError.encodingError))
                        }
                    }catch{
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
        let path = "https://botbuilder.labiba.ai/api/MobileAPI/FetchQuestions"
        let params:[String:Any] = [
            "bot_id" : SharedPreference.shared.currentUserId// "d0b8e34a-26ba-4ed6-a2af-4412b55ef442"
        ]
       // print(params)
        showLoadingIndicator()
        request(path, method: .get, parameters: params ,encoding: URLEncoding.default , headers: nil ).responseData { (response) in
            
            switch response.result{
            case .success(let data):
               // print(String(data: data , encoding: .utf8))
                do {
                    let response = try JSONDecoder().decode([GetRatingFormQuestionsModel].self, from: data)
                    completion(.success(response))
                }catch{
                    completion(.failure(NetworkError.encodingError))
                }
            case .failure(let err):
                completion(.failure(err))
            }
            self.loader.dismiss()
        }
    }
    
    func getHelpPageData(completion: @escaping (Result<HelpPageModel>) -> Void){
        let path = Labiba._helpPath
        let params:[String:Any] = [
            "bot_id" : SharedPreference.shared.currentUserId // "6bd2ecb6-958e-4bb5-905a-51bb6350490a"
        ]
       // print(params)
        showLoadingIndicator()
        request(path, method: .get, parameters: params ,encoding: URLEncoding.default , headers: nil ).responseData { (response) in
            
            switch response.result{
            case .success(let data):
                print(String(data: data , encoding: .utf8))
                do {
                    let response = try JSONDecoder().decode(HelpPageModel.self, from: data)
                    completion(.success(response))
                }catch{
                    completion(.failure(NetworkError.encodingError))
                }
            case .failure(let err):
                completion(.failure(err))
            }
            self.loader.dismiss()
        }
    }
    enum LoggingTag:String {
        case matchID = "MATCH_ID"
        case keysRequest  = "KEYS_REQUEST"
        case liveness = "LIVENESS"
    }
    
    func log(url:String,headers:String? = nil,tag:LoggingTag,method:HTTPMethod,parameter:String ,response:String,exception:String? = nil) {
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
            let body:[String:String] = [
                "Source":"IOS",
                "Tag":tag.rawValue,
                "DeviceDetails":deviceDetails,
                "UserDetails":userDetails,
                "Request":requestDetails,
                "Response":response,
                "Exception":exception ?? "",
                "SDKVersion":Labiba.version
            ]
            let data = try! JSONEncoder().encode(body)
            prettyPrintedRespons(data: data)
            let url = Labiba._loggingPath
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
        
        switch encodeRes
        {
        
        case .success(let request, _, _):
            
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
                    completion(nil)
                }
            })
            
        case .failure:
            
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
