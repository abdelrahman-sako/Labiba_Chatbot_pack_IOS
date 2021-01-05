//
//  LabibaBotConnector.swift
//  LabibaBotClient_Example
//
//  Created by Suhayb Ahmad on 8/12/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
//import SVProgressHUD
//import SocketRocket
//import SwiftyJSON
//import Alamofire
import CoreLocation

class LabibaBotConnector: BotConnector
{
    private var socket: SRWebSocket?
    private weak var timer:Timer?
   // var myDialog: [JSON]?
    var myDialog:  [String : JSON]?
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
        //test
        let model = RefModel()
        let refModel = ReferralModel(ref: model.arrayJsonString()).modelAsDic()
        print(refModel)
        //
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
            Labiba.resetReferral()// referral must send with first message and when referesh token change
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
        
        
        if let elements = self.myDialog?["elements"]?.array
        {
            
            dialog.cards = DialogCards(presentation: .menu)
            dialog.cards?.items = elements.map({ (elm) -> DialogCard in
                
                let card = DialogCard(title: elm["title"].string ?? "")
                
//                if self.myDialog?["image_aspect_ratio"]?.string?.hasPrefix("SQUARE") ?? false{
//                    card.type = .square
//                }
                switch self.myDialog?["image_aspect_ratio"]?.string{
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
                
                card.imageUrl = elm["image_url"].string
                card.subtitle = elm["subtitle"].string
                
                if let buttons = elm["buttons"].array
                {
                    
                    card.buttons = buttons.map({ (btn) -> DialogCardButton in
                        
//                        let title = "https://botbuilder.labiba.ai/maker/files/3a035213-cea7-45e3-aa04-d80527881d0e.png"//btn["title"].stringValue
                      //  let title =  "https://tinyurl.com/yxbmzo8z"
                        let title = btn["title"].stringValue
                        let type = btn["type"].stringValue
                        let eunmType = AttachmentElementButtonType(rawValue: type)
                        if type == "postback" || type == "phone_number" || type == "email" || type == "create_post"
                        {
                           // return DialogCardButton(title: title, payload: btn["payload"].string ,type: type )
                            return DialogCardButton(title: title, payload: btn["payload"].string ,type: eunmType ?? .postback )
                        }
                        else
                        {
                            return DialogCardButton(title: title, url: btn["url"].string)
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
    
    override func sendVoice(_ voiceLocalPath: String, completion: @escaping (String?) -> Void)
    {
        
        uploadFileToLabiba(filepath: voiceLocalPath)
        { (remotePath) in
            
            if let path = remotePath
            {
                
                completion(path)
                self.sendMessage(withAttachments: [
                    [
                        "type": "audio",
                        "payload": ["url": path]
                    ]
                    ])
            }
            else
            {
                
                completion(nil)
            }
        }
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


extension LabibaBotConnector: SRWebSocketDelegate
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
    
    //titi response comes here
    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!)
    {
         
        print("TrackSteps Received Message")
        var cancelCard = false
        print("webSocket Received Message ...")
      //  NotificationCenter.default.post(name: Constants.NotificationNames.CardSelectionAbility, object: true)
       // print(message)
        let json = JSON(parseJSON: message as! String)
        print(json)
        let msg = json["message"]
        
        guard msg.exists(), let msgType = json["messaging_type"].string, msgType == "RESPONSE"
            else
        {
            return
        }
        
        let dialog = ConversationDialog(by: .bot, time: Date())
        dialog.message = msg["text"].string
        
        let message = dialog.message ?? ""
        if message.hasPrefix("GIF_") || message.hasPrefix("LOOP_GIF_") {
            let isLooping = message.hasPrefix("LOOP_GIF_")
            let offsetIndex = isLooping ? message.index(message.startIndex, offsetBy: 9) : message.index(message.startIndex, offsetBy: 4)
            NotificationCenter.default.post(name: Constants.NotificationNames.ShowHideDynamicGIF,
                                            object: ["show":true , "url":String(message[offsetIndex...]),"isLooping":isLooping])
            return
        }else if message.hasPrefix("ANIMATE_GRADIENT_DEFAULT") {
            NotificationCenter.default.post(name: Constants.NotificationNames.ShowHideDynamicGIF,
                                            object: ["show":false])
            
        }
        
       
        // MARK:- metadata
        if  let metadata = msg["metadata"].string
        {
            if metadata == "mute" {
                dialog.enableTTS = false
            }
        }
        
        
        let attach = msg["attachment"]
        Constants.content_type = "" // default value if content type nil
        // MARK:- choices
        if let choices = msg["quick_replies"].array
        {
            let index = choices.first
            let titles = index?["title"].string
            if titles == "null" || titles == nil || titles == ""
            {
                if let content_type = index?["content_type"].string
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
                        switch Constants.content_type {
                        case "DATE_AND_TIME" : // this is wrong , and must be returened with response quick_replies title ,,,,,, backend  :)
                            dialogChoice.title = "Pick date and time".localBasedOnLastMessage
                            dialogChoice.action = DialogChoiceAction.date
                            dialog.choices = [dialogChoice]
                        case "DATE" :
                            dialogChoice.title = "Pick date".localBasedOnLastMessage
                            dialogChoice.action = DialogChoiceAction.calendar
                            dialog.choices = [dialogChoice]
                        case "TIME":
                            dialogChoice.title = "Pick time".localBasedOnLastMessage
                            dialogChoice.action = DialogChoiceAction.time
                            dialog.choices = [dialogChoice]
                        case "location" :
                            dialogChoice.title = "Select Location".localBasedOnLastMessage
                            dialogChoice.action = DialogChoiceAction.location
                            dialog.choices = [dialogChoice]
                        case "user_email" , "NUMBER" , "user_phone_number" ,"free_text":
                            NotificationCenter.default.post(name: Constants.NotificationNames.ChangeInputToTextViewType,
                                                            object: char)
                            isKeyboardType = true
                        default:
                            break
                        }
                        if !isKeyboardType{
                            NotificationCenter.default.post(name: Constants.NotificationNames.ChangeInputToVoiceAssistantType,
                                                            object: nil)
                        }
                      //  NotificationCenter.default.post(name: Constants.NotificationNames.ChangeTextViewKeyboardType,
                       //                                 object: char)
                        
                    }
                    
                }
            }
            else
            {
                NotificationCenter.default.post(name: Constants.NotificationNames.ChangeInputToVoiceAssistantType,
                                                object: nil)
                Constants.content_type = ""
                Constants.Keyboard_type = ""
                dialog.choices = choices.map
                    { (choice) -> DialogChoice in
                        
                        let dialogChoice = DialogChoice(title: choice["title"].stringValue)
                        if let content_type = index?["content_type"].string
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
                        if let _payStr = choice["payload"].string
                        {
                            
                            let _pay = JSON(parseJSON: _payStr)
                            
                            
                            if let token = _pay["ParamToken"].string, token.uppercased().hasPrefix("CHOICE_ACTION:")
                            {
                                //titi disable input for choice action responses
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
        }
        else if let attachType = attach["type"].string
        {
            NotificationCenter.default.post(name: Constants.NotificationNames.ChangeInputToVoiceAssistantType,
                                            object: nil)
            if attachType == "template",
                let payload = attach["payload"].dictionary , let elements = payload["elements"]?.array
            {
                
                let dialogChoice = DialogChoice(title: "Click to choose".local)
                dialogChoice.action = DialogChoiceAction.menu
                dialog.choices = [dialogChoice]
                myDialog = payload
                
                dialog.cards = DialogCards(presentation: .menu)
                
                dialog.cards?.items = elements.map({ (elm) -> DialogCard in
                    
                    let card = DialogCard(title: elm["title"].string ?? "")
                    //run now
                    if card.title.hasPrefix("MENU:") {
                        // ConversationViewController().insertCellIntoTable()
                        //                                            dialog.cards?.presentation = .menu
                        //                                            card.title = card.title.replacingOccurrences(of: "MENU:", with: "")
                    }
                    //
                    //                    if card.title.hasPrefix("CAROUSEL:") {
                    //                        dialog.cards?.presentation = .carousel
                    //                        card.title = card.title.replacingOccurrences(of: "CAROUSEL:", with: "")
                    //                    }
                    //
                    card.imageUrl = elm["image_url"].string
                    card.imageUrl = elm["image_url"].string
                    // card.subtitle = elm["subtitle"].string
                    
                    if let buttons = elm["buttons"].array {
                        
                        card.buttons = buttons.map({ (btn) -> DialogCardButton in
                            
                            let title = btn["title"].stringValue
                            
                            let type = btn["type"].stringValue
                             let eunmType = AttachmentElementButtonType(rawValue: type)
                            if type == "postback" || type == "phone_number" || type == "email" || type == "create_post"
                            {
                               // return DialogCardButton(title: title, payload: btn["payload"].string ,type: type )
                                return DialogCardButton(title: title, payload: btn["payload"].string ,type: eunmType ?? .postback )
                            } else {
                                return DialogCardButton(title: title, url: btn["url"].string)
                            }
                        })
                    }
                    //
                    
//                    if !card.title.hasPrefix("MENU:")
//                    {
//                        ShowDialog()
//                        cancelCard = true
//                    }
                    
                    return card
                    
                    
                })
                    ShowDialog()
                    cancelCard = true

                
                
            }
            else if let attachUrl = attach["payload"]["url"].string
            {
                
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
            
        }
        else
        {
            NotificationCenter.default.post(name: Constants.NotificationNames.ChangeTextViewKeyboardType,
                                            object: "Enable")
        }
        if (!cancelCard)
        {
            self.delegate?.botConnector(self, didRecieveActivity: dialog)
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
 
}

//fileprivate let LabibaUploadPath = "https://whatsapp.labibabot.com/maker/FileUploader.ashx"
fileprivate let LabibaUploadPath = "https://botbuilder.labiba.ai/maker/FileUploader.ashx"
fileprivate typealias EncodingCompletionBlock = (SessionManager.MultipartFormDataEncodingResult) -> Void



func uploadFileToLabiba(filepath: String, completion: @escaping (String?) -> Void) -> Void
{
    
    let file = URL(fileURLWithPath: filepath)
    
    guard let attrs = try? FileManager.default.attributesOfItem(atPath: file.path)
        else
    {
        completion(nil)
        return
    }
    
    let length = attrs[FileAttributeKey.size] as! UInt64
    
    upload(multipartFormData: { (formData) in
        
        formData.append(InputStream(url: file)!,
                        withLength: length,
                        name: "Filedata",
                        fileName: file.lastPathComponent,
                        mimeType: file.mimeType)
        
    }, to: LabibaUploadPath, encodingCompletion: createEncodingBlock(completion: completion))
}



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


