//
//  WebViewEventHumanAgent.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman Qasem on 03/07/2022.
//  Copyright © 2022 Abdul Rahman. All rights reserved.
//

import Foundation
import WebKit

class WebViewEventHumanAgent:NSObject {
    let webView:WKWebView = WKWebView()
    
    override init() {
        super.init()
        webView.navigationDelegate = self
        addJavaScripListner()
    }
    
    func addJavaScripListner()  {
        let handler = "sakoHandler"
        webView.configuration.userContentController.add(self, name: handler)
    }
    
    func start() {
        let url = "https://botbuilder.labiba.ai/SignalRChannel/Index?device=ios&userid=\(Labiba._senderId ?? "")&storyId=\(Labiba._pageId)"
        print(url)
        if let url = URL(string: url){
            Labiba.isHumanAgentStarted = true
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func end() {
        if let url = URL(string: "https://www.google.com"){
            Labiba.isHumanAgentStarted = false
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}


extension WebViewEventHumanAgent: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("human agent finish loading ")
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("human agent faile to load with error \(error.localizedDescription)")
    }
}

extension WebViewEventHumanAgent: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.name,message.body)
        guard let messageDic =  message.body as? [String:String], let statusParam = messageDic["param1"] else {
            return
        }
        switch statusParam {
        case "msg":
            if let stringModel = messageDic["param2"], let dataModel = stringModel.data(using: .utf8) {
                let decoder = JSONDecoder()
                do {
                    let model = try decoder.decode(HumanAgentModel.self, from: dataModel)
                    LabibaRestfulBotConnector.shared.parsHumanAgentResponse(model: model)
                } catch  {
                    print(error.localizedDescription)
                }
            }
        case "end":
            end()
            LabibaRestfulBotConnector.shared.sendGetStarted()
        default:
            break
        }
       
    }
}
