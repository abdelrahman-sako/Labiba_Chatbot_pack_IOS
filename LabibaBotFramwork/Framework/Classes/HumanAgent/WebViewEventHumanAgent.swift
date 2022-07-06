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
        let url = "https://botbuilder.labiba.ai/SignalRChannel/Index?device=ios&userid=\(Labiba._senderId ?? "")&storyId=\(Labiba._pageId)"
        print(url)
        if let url = URL(string: url){
            Labiba.isHumanAgentStarted = true
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
    }
    
    func end() {
        
        if let url = Labiba.bundle.url(forResource: "index", withExtension: "html") {
          //  if let url = URL(string: url){
                let request = URLRequest(url: url)
                webView.load(request)
          //  }
        }
//        if let url = URL(string: "https://www.google.com"){
//            Labiba.isHumanAgentStarted = false
//            let request = URLRequest(url: url)
//            webView.load(request)
//        }
    }
    
    func forceEnd(completionHandler:(()->Void)? = nil) {
        if Labiba.isHumanAgentStarted  {
            Labiba.isHumanAgentStarted = false
            
            let url = "https://botbuilder.labiba.ai/api/LiveChat/v1.0/CloseConversation/\(Labiba._pageId)/\(Labiba._senderId ?? "")/mobile"
            end()
            DispatchQueue.global(qos: .background).async {
//                request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { response in
//                }
                LabibaRestfulBotConnector.shared.LabibaRequest([String].self, url: url, method: .post,headers: nil) { result in
                    completionHandler?()
                }
            }
            print("The task has started")
            
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
