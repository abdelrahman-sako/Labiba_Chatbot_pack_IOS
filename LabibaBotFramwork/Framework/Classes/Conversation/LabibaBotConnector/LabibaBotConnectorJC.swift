//
//  LabibaBotConnectorJC.swift // JC refere to JSON Coder
//  LabibaBotFramwork
//
//  Created by Abdulrahman on 1/13/20.
//  Copyright © 2020 Abdul Rahman. All rights reserved.
//

import UIKit
//import Alamofire
import CoreLocation

class LabibaBotConnectorJC: BotConnector
{
    //fileprivate let LabibaUploadPath = "https://whatsapp.labibabot.com/maker/FileUploader.ashx"
   // fileprivate let LabibaUploadPath = "https://botbuilder.labiba.ai/maker/FileUploader.ashx"

    private var socket: SRWebSocket?
    private weak var timer:Timer?
    var attachmentPayload:PayloadModel?
    var isReloadAfterScreenOff = false
    var lasConnectiontStatus:Network.Status?
    override func startConversation()
    {
        showLoadingIndicator()
        
        self.socket = SRWebSocket(url: URL(string: Labiba._socketBasePath)!)
        self.socket?.delegate = self
        self.socket?.open()
        startConnectionCheckTimer()
        print("derp")
        print("Socket opening ......mmmmmkkk")
    }
    
    override func sendMessage(_ message: String? = nil, payload: String? = nil, withAttachments attachments: [[String: Any]]? = nil, withEntities entities: [[String: Any]]? = nil)
    {
       
        let pageId = Labiba._pageId;
        let senderId = Labiba._senderId;
        let time = Int(Date().timeIntervalSince1970 * 1000)
        let null = NSNull()
        
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
                    "message": (message == nil && attachments == nil) ? null as Any : [
                        "mid": null,
                        "text": message ?? null,
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
        print("***********************************")
        print(msgLoad)
        print("***********************************")
        if let data = try? JSONSerialization.data(withJSONObject: msgLoad, options: .prettyPrinted)
        {
            
            print(String(data: data, encoding: .utf8)!)
            if let state = self.socket?.readyState , state == SRReadyState(rawValue: 1) { // check if socket is open , app will crash if you try to send data when socket closed
                self.socket?.send(data)
            }
            self.delegate?.botConnectorDidRecieveTypingActivity(self)
            Labiba.resetReferral() // referral must send with first message and when referesh token change
        }
    }
    
    override func sendPhoto(_ photo: UIImage, withChoiceActionToken token: String)
    {
       
        if let data =  photo.jpegData(compressionQuality: 0.25)
        {
            
            uploadDataToLabiba(filename: "photo.jpg", data: data)
            { (url) in
                
                if let imgUrl = url
                {
                    self.sendMessage(token + imgUrl)
                }
            }
        }
    }
    
    override func ShowDialog()
    {
        let dialog = ConversationDialog(by: .bot, time: Date())
        
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        
        //            self.delegate?.botConnectorDidRecieveTypingActivity(self)
        
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        
        
        if let elements = self.attachmentPayload?.elements
        {
            
            dialog.cards = DialogCards(presentation: .menu)
            dialog.cards?.items = elements.map({ (elm) -> DialogCard in
                
                let card = DialogCard(title: elm.title ?? "")
                
//                if self.myDialog?["image_aspect_ratio"]?.string?.hasPrefix("SQUARE") ?? false{
//                    card.type = .square
//                }
                switch self.attachmentPayload?.image_aspect_ratio ?? ""{
                case "SQUARE" :
                    card.type = .square
                case "HORIZONTAL ","HORIZONTAL" :
                    card.type = .horizontal
                default:
                    break
                }
                
                if card.title.hasPrefix("MENU:")
                {
                    dialog.cards?.presentation = .menu
                    card.title = card.title.replacingOccurrences(of: "MENU:", with: "")
                }
                
                if card.title.hasPrefix("CAROUSEL:")
                {
                    dialog.cards?.presentation = .carousel
                    card.title = card.title.replacingOccurrences(of: "CAROUSEL:", with: "")
                }
                
                card.imageUrl = elm.image_url
                card.subtitle = elm.subtitle
                
                if let buttons = elm.buttons
                {
                    
                    card.buttons = buttons.map({ (btn) -> DialogCardButton in
                        
//                        let title = "https://botbuilder.labiba.ai/maker/files/3a035213-cea7-45e3-aa04-d80527881d0e.png"//btn["title"].stringValue
                      //  let title =  "https://tinyurl.com/yxbmzo8z"
                        let title = btn.title ?? ""
                        let type = AttachmentElementButtonType(rawValue: btn.type ?? "")
                        switch type {
                        case .some(let type):
                            switch type {
                            case .postback ,.phoneNumber , .email , .createPost:
                                return DialogCardButton(title: title, payload: btn.payload ,type: type)
                            }
                        case .none:
                            return DialogCardButton(title: title, url: btn.url)
                        }
                    })
                }
                
                return card
            })
            
            
        }
        
        //                self.activitiesList.append(dialog)
        self.delegate?.botConnector(self, didRecieveActivity: dialog)
        
        //            }
        //        }
    }
    
    override func close()
    {
        
        self.socket?.close()
    }
    
//    override func configureInternetReachability()  {
//        do {
//            try Network.reachability = Reachability(hostname: "www.google.com")
//        }
//        catch {
//            switch error as? Network.Error {
//            case let .failedToCreateWith(hostname)?:
//                print("Network error:\nFailed to create reachability object With host named:", hostname)
//            case let .failedToInitializeWith(address)?:
//                print("Network error:\nFailed to initialize reachability object With address:", address)
//            case .failedToSetCallout?:
//                print("Network error:\nFailed to set callout")
//            case .failedToSetDispatchQueue?:
//                print("Network error:\nFailed to set DispatchQueue")
//            case .none:
//                print(error)
//            }
//        }
//        NotificationCenter.default
//            .addObserver(self,
//                         selector: #selector(statusManager),
//                         name: .flagsChanged,
//                         object: nil)
//        checkInternet()
//
//    }
//    @objc func statusManager(_ notification: Notification) {
//        checkInternet()
//
//    }
//    func checkInternet() {
//        switch Network.reachability.status {
//        case .unreachable:
//            showErrorMessage("no inertnet connection " , okHandelr: { [weak self] in
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
//                    self?.showLoadingIndicator()
//                })
//                guard let _ = self?.lasConnectiontStatus else { // check if first launch
//                    self?.isReloadAfterScreenOff = false
//                    return
//                }
//
//            })
//        case .wifi , .wwan:
//            if let lastStatus = lasConnectiontStatus , lastStatus == .wifi || lastStatus == .wwan {
//                break
//            }
//            SVProgressHUD.dismiss()
//            startConversation("", forClient: "")
//
//        }
//        lasConnectiontStatus = Network.reachability.status
//    }
//
}


extension LabibaBotConnectorJC: SRWebSocketDelegate
{
    
    
    func webSocketDidOpen(_ webSocket: SRWebSocket!)
    {
        
        print("connected ...")
        //SVProgressHUD.dismiss()
        loader.dismiss()
        if (!isReloadAfterScreenOff)
        {
//            self.sendMessage("get started", withAttachments: nil, withEntities: nil)
            self.sendMessage("CONVERSATION-RELOAD", withAttachments: nil, withEntities: nil)
            NotificationCenter.default.post(name: Constants.NotificationNames.ScoketDidOpen,
                                            object: nil)
           // isReloadAfterScreenOff = true
        }
        else
        {
            isReloadAfterScreenOff = false
        }
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didReceivePong pongPayload: Data!)
    {
        
        print("Did receive pong: ")
        print(pongPayload)
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!)
    {
        var cancelCard = false
        let decoder = JSONDecoder()
        
        guard let message = message as? String  else{
            return
        }
        
        let data = Data(message.utf8)
        
        do {
            
            let labibaModel = try decoder.decode(LabibaModel.self, from: data)
            
            print(String(data: data, encoding: .utf8)!)
            guard  let msgType = labibaModel.messaging_type , msgType == "RESPONSE" else {
                return
            }
            
            let dialog = ConversationDialog(by: .bot, time: Date())
            let message = labibaModel.message
            // dialog.message = message?.text
            if let messages = message?.text?.components(separatedBy: "@:@"){
                if messages.count > 0 {
                    dialog.message = messages[0]
                }
                if messages.count > 1 {
                    dialog.SSML = messages[1]
                }
            }else{
                dialog.message = message?.text
            }
            // MARK:- handel GIF
            if  let message = dialog.message{
                if   message.hasPrefix("GIF_") || message.hasPrefix("LOOP_GIF_") {
                    let isLooping = message.hasPrefix("LOOP_GIF_")
                    let offsetIndex = isLooping ? message.index(message.startIndex, offsetBy: 9) : message.index(message.startIndex, offsetBy: 4)
                    NotificationCenter.default.post(name: Constants.NotificationNames.ShowHideDynamicGIF,
                                                    object: ["show":true , "url":String(message[offsetIndex...]),"isLooping":isLooping])
                    return
                }else if message.hasPrefix("ANIMATE_GRADIENT_DEFAULT") {
                    NotificationCenter.default.post(name: Constants.NotificationNames.ShowHideDynamicGIF,
                                                    object: ["show":false])
                    
                }
            }
            
            // MARK:- metadata
            if  let metadata = message?.metadata
            {
                if metadata == "mute" {
                    dialog.enableTTS = false
                }
            }
            
            Constants.content_type = "" // default value if content type nil
            let attach = message?.attachment
            // MARK:- choices
            if let quick_replies = message?.quick_replies {
                let firstReply = quick_replies.first
                let title = firstReply?.title
                if  (title?.isEmpty ?? true ){
                    if let content_type = firstReply?.content_type
                    {
                        Constants.content_type = content_type
                        if Constants.content_type != "" && Constants.content_type != "text"
                        {
                            let validate = Constants.content_type
                            let splits = validate.split(separator: ",")
                            let index0 = splits[0]
                            let char = String(index0)
                            let dialogChoice = DialogChoice(title: "Calender")
                            var isKeyboardType:Bool = false
                            switch QuickReplyContentType(rawValue:content_type) {
                            case .some(let contentType):
                                switch contentType {
                                case .dateAndTime ,.date ,.time , .location ,.QRCode:
                                    dialogChoice.title = contentType.title
                                    dialogChoice.action = contentType.action
                                    dialog.choices = [dialogChoice]
                                case .userEmail ,.number , .userPhoneNumber ,.freeText:
                                    NotificationCenter.default.post(name: Constants.NotificationNames.ChangeInputToTextViewType,object: char)
                                    isKeyboardType = true
                                }
                            case .none:
                                break
                            }
                            if !isKeyboardType{
                                NotificationCenter.default.post(name: Constants.NotificationNames.ChangeInputToVoiceAssistantType,
                                                                object: nil)
                            }
                        }
                        
                    }
                }
                else
                {
                    NotificationCenter.default.post(name: Constants.NotificationNames.ChangeInputToVoiceAssistantType,
                                                    object: nil)
                    Constants.content_type = ""
                    Constants.Keyboard_type = ""
                    dialog.choices = quick_replies.map
                        { (reply) -> DialogChoice in
                            
                            let dialogChoice = DialogChoice(title: reply.title ?? "")
                            if let content_type = firstReply?.content_type
                            {
                                if  content_type == "QR_CODE" {
                                    dialogChoice.action = DialogChoiceAction.QRCode
                                }
                            }
                            
                            if dialogChoice.title.hasPrefix("CALENDAR:")
                            {
                                let index = dialogChoice.title.index(dialogChoice.title.startIndex, offsetBy: 9)
                                dialogChoice.title = dialogChoice.title.substring(from: index)
                                dialogChoice.action = DialogChoiceAction.calendar
                            }
                            if let _payStr = reply.getPayloadObj()
                            {
                                if let token = _payStr.ParamToken, token.uppercased().hasPrefix("CHOICE_ACTION:")
                                {
                                    NotificationCenter.default.post(name: Constants.NotificationNames.ChangeTextViewKeyboardType,
                                                                    object: "Disable")
                                    let action = token.uppercased()
                                        .replacingOccurrences(of: "CHOICE_ACTION:", with: "")
                                        .trimmingCharacters(in: .whitespacesAndNewlines)
                                    dialogChoice.action = DialogChoiceAction(rawValue: action)
                                }
                            }
                            return dialogChoice
                    }
                }
            } else if let attachType = attach?.type{
                NotificationCenter.default.post(name: Constants.NotificationNames.ChangeInputToVoiceAssistantType,
                                                object: nil)
                if attachType == "template", let payload = message?.attachment?.payload, let elements = payload.elements
                {
                    
                    let dialogChoice = DialogChoice(title: "Click to choose".local)
                    dialogChoice.action = DialogChoiceAction.menu
                    dialog.choices = [dialogChoice]
                    self.attachmentPayload = payload
                    
                    dialog.cards = DialogCards(presentation: .menu)
                    
                    dialog.cards?.items = elements.map({ (elm) -> DialogCard in
                        let card = DialogCard(title: elm.title ?? "")
                        card.imageUrl = elm.image_url
                        // card.subtitle = elm["subtitle"].string
                        if let buttons = elm.buttons {
                            card.buttons = buttons.map({ (btn) -> DialogCardButton in
                                let title = btn.title ?? ""
                                let type = AttachmentElementButtonType(rawValue: btn.type ?? "")
                                switch type {
                                case .some(let type):
                                    switch type {
                                    case .postback ,.phoneNumber , .email , .createPost:
                                        return DialogCardButton(title: title, payload: btn.payload ,type: type)
                                    }
                                case .none:
                                    return DialogCardButton(title: title, url: btn.url)
                                }

                            })
                        }
                        return card
                    })
                    ShowDialog()
                    cancelCard = true
                } else if let attachUrl = attach?.payload?.url {
                    switch attachType
                    {
                    case "audio":
                        dialog.media = DialogMedia(type: .Audio)
                    case "video":
                        dialog.media = DialogMedia(type: .Video)
                    default:
                        dialog.media = DialogMedia(type: .Photo)
                    }
                    
                    dialog.media?.url = attachUrl
                }
            }else{
                NotificationCenter.default.post(name: Constants.NotificationNames.ChangeTextViewKeyboardType,
                                                object: "Enable")
            }
            
            
            if (!cancelCard)
            {
                self.delegate?.botConnector(self, didRecieveActivity: dialog)
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
    func webSocket(_ webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool)
    {
        print("... disconnected")
        print(code)
        print(reason)
        timer?.invalidate()
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didFailWithError error: Error!)
    {
        
        print("tititi Socket did fail: ")
        print(error)
      // SVProgressHUD.dismiss()
        //SVProgressHUD.showError(withStatus: "Error happened while connecting to Labiba")
        isReloadAfterScreenOff = true
//        checkInternet()
        startConversation()
    }
    
    

    
    func startConnectionCheckTimer()  {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: { [weak self](timer) in
            if let state = self?.socket?.readyState , state == SRReadyState(rawValue: 1) { // check if socket is open , app will crash if you try to send data when socket closed
                do {
                    try  self?.socket?.sendPing(nil)
                } catch  {
                    print("socket ping failed")
                }
                
            }
           
        })
    }
    
   
    

 
//    func testFayvoSecurity( completion: @escaping (Result<String>) -> Void) -> Void
//        {
//
//           let path1 = "https://lorb8s58n0.execute-api.us-west-2.amazonaws.com/alpha/logs/capture"
//            let path2 = "https://lorb8s58n0.execute-api.us-west-2.amazonaws.com/alpha/logs/header"
//
//
//
//            Alamofire.request(path1, method: .post, parameters: nil ,encoding: JSONEncoding.default, headers: nil ).responseData { (response) in
//                    // URLEncoding() -> application/x-www-form-urlencoded
//                    switch response.result{
//                    case .success(_):
//                       print("path1    " ,String(data: response.result.value!, encoding: .utf8))
//                    case .failure(let err):
//                       break
//                    }
//                }
//
//            Alamofire.request(path2, method: .get, parameters: nil ,encoding: JSONEncoding.default, headers: nil ).responseData { (response) in
//                // URLEncoding() -> application/x-www-form-urlencoded
//                switch response.result{
//                case .success(_):
//                   print("path2    " ,String(data: response.result.value!, encoding: .utf8))
//                case .failure(let err):
//                   break
//                }
//                self.loader.dismiss()
//            }
//        }
    

    


//fileprivate typealias EncodingCompletionBlock = (SessionManager.MultipartFormDataEncodingResult) -> Void

//func uploadDataToLabiba(filename: String, data: Data, completion: @escaping (String?) -> Void) -> Void
//{

//
//    upload(multipartFormData: { (formData) in
//
//        formData.append(data, withName: "Filedata", fileName: filename, mimeType: "")
//
//    }, to: LabibaUploadPath, encodingCompletion: createEncodingBlock(completion: completion))
//}

//func uploadFileToLabiba(filepath: String, completion: @escaping (String?) -> Void) -> Void
//{
//
//    let file = URL(fileURLWithPath: filepath)
//
//    guard let attrs = try? FileManager.default.attributesOfItem(atPath: file.path)
//        else
//    {
//        completion(nil)
//        return
//    }
//
//    let length = attrs[FileAttributeKey.size] as! UInt64
//
//    upload(multipartFormData: { (formData) in
//
//        formData.append(InputStream(url: file)!,
//                        withLength: length,
//                        name: "Filedata",
//                        fileName: file.lastPathComponent,
//                        mimeType: file.mimeType)
//
//    }, to: LabibaUploadPath, encodingCompletion: createEncodingBlock(completion: completion))
//}
//
//
//
//fileprivate func createEncodingBlock(completion: @escaping (String?) -> Void) -> EncodingCompletionBlock
//{
//
//    let encodeCompletion: EncodingCompletionBlock = { (encodeRes) in
//
//        switch encodeRes
//        {
//
//        case .success(let request, _, _):
//
//            request.responseSwiftyJSON(completionHandler: { (res) in
//
//                switch res.result
//                {
//
//                case .success(let json):
//
//                    var url = json["url"].string
//                    if url != nil && url!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
//                    {
//                        url = nil
//                    }
//
//                    completion(url)
//
//                case .failure:
//                    completion(nil)
//                }
//            })
//
//        case .failure:
//
//            completion(nil)
//        }
//    }
//
//    return encodeCompletion
//}
//}
}
