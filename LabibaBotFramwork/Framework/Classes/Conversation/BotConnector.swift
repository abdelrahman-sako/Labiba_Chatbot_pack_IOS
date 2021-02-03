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


class BotConnector: NSObject {
    
    var currentRequest: DataRequest?
    enum NetworkError: String, Error {
        case badURL
        case encodingError = "Encoding error"
    }
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
                            "payload": ["url": fileURL]
                        ]
                    ])
                }
            }
        }
    }

    
    func uploadDataToLabiba(filename: String, data: Data, completion: @escaping (String?) -> Void) -> Void
    {
        
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
       //let path = "\(Labiba._voiceBasePath)/translate/texttospeech"
        //let path = "\(Labiba._voiceBasePath)/Handlers/Translate.ashx"
        let path = "\(Labiba._voiceBasePath)\(Labiba._voiceServicePath)"
        
        let params:[String:Any] = [
            "text":model.text,
            "voicename" : model.googleVoice.voicename,
            "clientid" : model.clientid,
            "language" : model.googleVoice.language,
            "isSSML":"\(model.isSSML)"
        ]
    print("url ", path , "\n params \n ",params)
        
//        let config = URLSessionConfiguration()
//
//        //config.timeoutIntervalForRequest = 50
//
//        let session = SessionManager(configuration: .default, delegate: SessionDelegate(), serverTrustPolicyManager: MyServerTrustPolicyManager(policies: [:]))
        
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
    
    func generateVedio ( completion:@escaping (Result<String>) -> Void) {
        let path1 = "http://imaginebotwebservice.engagemaster.com/Riyadh/api/RiyadhMunicipality/GenerateVideoURL"
        loader.show()
        request(path1, method: .get, parameters: nil ,encoding: JSONEncoding.default, headers: nil ).responseData { (response) in
            self.loader.dismiss()
            switch response.result{
            case .success(_):
                do {
                    let response = try JSONDecoder().decode([String:String].self, from: response.data ?? Data())
                    if  let result = response["state"] , result == "success" {
                        if let url = response["SlotFillingState"] {
                            completion(.success(url))
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
                    
                    var url = json["url"].string
                    if url != nil && url!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    {
                        url = nil
                    }
                    
                    completion(url)
                    
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
