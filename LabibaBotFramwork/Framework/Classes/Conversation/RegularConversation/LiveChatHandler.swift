//
//  LiveChatHandler.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman on 1/14/20.
//  Copyright © 2020 Abdul Rahman. All rights reserved.
//

import Foundation

#if canImport(LiveChat)
import LiveChat
#endif
class LiveChatHandler:NSObject {
    
    override init() {
        super.init()
        #if canImport(LiveChat)
        if #available(iOS 13.0, *) {
            let scene  = UIApplication.shared.keyWindow?.windowScene
            LiveChat.windowScene = scene
        }
        LiveChat.licenseId = Labiba.liveChatModel?.licenseId
        LiveChat.groupId = Labiba.liveChatModel?.groupId
        LiveChat.name = Labiba.liveChatModel?.name
        LiveChat.email = Labiba.liveChatModel?.email
        Labiba.liveChatModel?.variables?.forEach({ (item) in
            LiveChat.setVariable(withKey:item.key, value:item.value)
        })
        LiveChat.delegate = self
        #endif
    }
    
    func present()  {
        #if canImport(LiveChat)
        LiveChat.presentChat()
        #else
        showErrorMessage(title: "LiveChat", "Live chat can't be imported")
        #endif
    }
    
    func dismiss()  {
        #if canImport(LiveChat)
        LiveChat.dismissChat()
        #else
        showErrorMessage(title: "LiveChat", "Live chat can't be imported")
        #endif
        
    }
    
}

#if canImport(LiveChat)
extension LiveChatHandler: LiveChatDelegate{
    func received(message: LiveChatMessage) {
        if (!LiveChat.isChatPresented) {
            // Notifying user
            let alert = UIAlertController(title: "Support", message: message.text, preferredStyle: .alert)
            let chatAction = UIAlertAction(title: "Go to Chat", style: .default) { alert in
                // Presenting chat if not presented:
                if !LiveChat.isChatPresented {
                    LiveChat.presentChat()
                }
            }
            alert.addAction(chatAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(cancelAction)
            
            getTheMostTopViewController().present(alert, animated: true, completion: nil)
        }
    }
}

#endif
