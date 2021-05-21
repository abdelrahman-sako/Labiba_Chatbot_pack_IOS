//
//  LabibaModel.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman on 1/12/20.
//  Copyright © 2020 Abdul Rahman. All rights reserved.
//

import Foundation
class LastBotResponseModel:Codable{
    var result:String?
    var lastBotResponse:[LabibaModel]?
}
class LabibaModel:Codable {
    var recipient:RecipientModel?
    var messaging_type:String?
    var message:MessageModel?
}

class RecipientModel:Codable{
    var id:String?
}

class MessageModel: Codable {
    var text:String?
    var attachment:AttachmentModel?
    var metadata:String?
    var quick_replies:[QuickReplyModel]?
    
   
}

class QuickReplyModel:Codable{
    var content_type:String?
    var title:String?
    var image_url:String?
    var payload:String?
    
    func getPayloadObj() -> QuickReplyPayloadModel? {
        do{
            let decoder = JSONDecoder()
            let quickReplyPayloadModel = try decoder.decode(QuickReplyPayloadModel.self, from: Data((payload ?? "").utf8))
            return quickReplyPayloadModel
        }catch{
            return nil
        }
    }
}
class QuickReplyPayloadModel:Codable{
    //var NextID:String
    //var ParamName:String?
    //var ParamValue:String?
    var ParamToken:String?
    
}

class AttachmentModel:Codable {
    var payload:PayloadModel?
    var type:String?
}

class PayloadModel:Codable{
    var url:String?
    var sharable:Bool?
    var image_aspect_ratio:String?
    var elements:[PayloadElementModel]?
    var template_type:String?
}

class PayloadElementModel:Codable {
   // var default_action:
    var title:String?
    var subtitle:String?
    var buttons:[PayloadElementButtonModel]?
    var image_url:String?
}

class PayloadElementButtonModel:Codable {
    var title:String?
    //var webview_height_ratio:String?
    var payload:String? // this is a json string
    var url:String?
    var type:String?
}
