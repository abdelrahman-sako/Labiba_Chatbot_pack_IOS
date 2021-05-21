//
//  LabibaModelEnums.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman on 1/12/20.
//  Copyright © 2020 Abdul Rahman. All rights reserved.
//

import Foundation

enum QuickReplyContentType:String {
    case dateAndTime = "DATE_AND_TIME"
    case camera = "CAMERA"
    case image = "IMAGE"
    case gallery = "GALLERY"
    case date = "DATE"
    case time = "TIME"
    case location = "location"
    case userEmail = "user_email"
    case number = "NUMBER"
    case userPhoneNumber = "user_phone_number"
    case freeText = "free_text"
    case QRCode = "QR_CODE"
    
    var title:String{
        switch self {
        case .dateAndTime:
            return  "Pick date and time".localBasedOnLastMessage
        case .date:
            return "Pick date".localBasedOnLastMessage
        case .time:
            return "Pick time".localBasedOnLastMessage
        case .location:
            return "Select Location".localBasedOnLastMessage
        case .QRCode:
            return "scan".localBasedOnLastMessage
        case .userEmail,.number ,.userPhoneNumber ,.freeText:
            return ""
        case .camera,.image:
            return "camera".localBasedOnLastMessage
        case .gallery:
            return "gallery".localBasedOnLastMessage
            
        }
    }
    
    var action:DialogChoiceAction?{
        switch self {
        case .dateAndTime:
            return  .date
        case .date:
            return .calendar
        case .time:
            return .time
        case .location:
            return .location
        case .QRCode:
            return .QRCode
        case .userEmail,.number ,.userPhoneNumber ,.freeText:
            return nil
        case .camera,.image:
            return .camera
        case .gallery:
            return .gallery
        }
    }
}

enum AttachmentElementButtonType:String{
    case postback  = "postback"
    case phoneNumber = "phone_number"
    case email = "email"
    case createPost = "create_post"
    
}
