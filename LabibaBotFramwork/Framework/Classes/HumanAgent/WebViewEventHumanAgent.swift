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
    static let Shared = WebViewEventHumanAgent()
   private override init() {
        super.init()
        webView.navigationDelegate = self
    
        addJavaScripListner()
        addAppWillTerminateListener()
    }
    
   private  func addJavaScripListner()  {
        let handler = "sakoHandler"
        webView.configuration.userContentController.add(self, name: handler)
       webView.configuration.userContentController.add(self, name: "error")
    }
    
    private func addAppWillTerminateListener(){
        let queue = OperationQueue()
        NotificationCenter.default.addObserver(forName: UIApplication.willTerminateNotification, object: nil, queue: .current) { [weak self] _ in
            
            let sem = DispatchSemaphore(value: 0)
            self?.forceEnd(completionHandler: {
                //sem.signal()
            })
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 2) {
                sem.signal()
                // i did this because app was crashing after termination it will not appear to user but it will be shown on testflight when user relanch the application  (crash report will be shown)
            }
            sem.wait() // call wait on main thread freezs the application but here it will call when app terminates
           
        }
    }
   
    func start() {
        loadUrl()
        guard let topVC = UIApplication.shared.topMostViewController else{return}
        topVC.view.addSubview(webView)
        webView.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        webView.alpha = 0
        //webView.isHidden = true
    }
    
    func loadUrl(){
        let url = "\(Labiba.HumanAgent.url)?device=ios&userid=\(Labiba._senderId ?? "")&storyId=\(Labiba._pageId)"
        print(url)
        if let url = URL(string: url){
            Labiba.isHumanAgentStarted = true
//            SharedPreference.shared.isHumanAgentStarted = true
            var request = URLRequest(url: url)
            var finalHeaders:[String:String] = [:]
            for dict in Labiba.clientHeaders {
                for (key, value) in dict {
                    finalHeaders[key] = value  // Later values will overwrite earlier ones
                    request.setValue(value, forHTTPHeaderField:key)
                }
            }

            webView.load(request)
        }
        
    }
    
    func end() {
        Labiba.isHumanAgentStarted = false
        if let url = Labiba.bundle.url(forResource: "index", withExtension: "html") {
                let request = URLRequest(url: url)
                webView.load(request)
            if !Labiba.didGoToRate && Labiba.isNPSAgentRatingEnabled{
               Labiba.handleNPSRartingAndQuit(isForAgent: true)
            }else{
                BotConnector.shared.sendMessage("get started")
            }
        }
    }
    
    func forceEnd(completionHandler:(()->Void)? = nil) {
        if Labiba.isHumanAgentStarted  {
            print("SharedPreference.shared.isHumanAgentStarted Ended")
            Labiba.isHumanAgentStarted = false
            end()
            DataSource.shared.closeConversation {}
        }
    }
    
    func ForceEndOnStart(completionHandler:(()->Void)? = nil){
        print("Agent Ended on start")
        Labiba.isHumanAgentStarted = false
        if let url = Labiba.bundle.url(forResource: "index", withExtension: "html") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        DataSource.shared.closeConversation {
            completionHandler?()
        }
    }
}


extension WebViewEventHumanAgent: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("human agent finish loading ")
        
    }
}

extension WebViewEventHumanAgent: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.name,message.body)
        
        if message.name == "error"{
            webView.reload()
            return
        }
        guard let messageDic =  message.body as? [String:Any] else {
            return
        }
        guard let statusParam = messageDic["messageType"] else {
            return
        }
        
        
        if statusParam as? String == "msg" {
            
            if !Labiba.isAppInBackground{
                if let stringModel = messageDic["msg"] as? String, let dataModel = stringModel.data(using: .utf8) {
                    let decoder = JSONDecoder()
                    do {
                        let model = try decoder.decode(HumanAgentModel.self, from: dataModel)
                        LabibaRestfulBotConnector.shared.parsHumanAgentResponse(model: model)
                    } catch  {
                        print(error.localizedDescription)
                    }
                }
            }
            
            
        }else if statusParam as? String == "refresh-token" {
            print("refresh-token calllled ")
            loadUrl()
        }
        
        if statusParam as? String == "end" {
            if !Labiba.isAppInBackground{
                end()
//                BotConnector.shared.sendGetStarted()
            }
        }
        
       
    }
}
