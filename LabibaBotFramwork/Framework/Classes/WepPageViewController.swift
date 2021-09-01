//
//  WepPageViewController.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman Qasem on 4/22/20.
//  Copyright © 2020 Abdul Rahman. All rights reserved.
//

import UIKit
import WebKit

class WebPageViewController: UIViewController {
    
    static func launchWithUrl(url:String, title:String,isZoomDisabled:Bool = false) -> Void {
        if let topVC = getTheMostTopViewController(),
            let webPageVC = Labiba.storyboard.instantiateViewController(withIdentifier: "WebPageViewController") as? WebPageViewController{
            print("loading....",url)
            webPageVC.initialUrl = url
            webPageVC.pagetitle = title
            webPageVC.isZoomDisabled = isZoomDisabled
            webPageVC.modalPresentationStyle = .fullScreen
            topVC.present(webPageVC, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var closeBtn: UIButton!
    
    
    var initialUrl:String?
    var pagetitle: String?
    var isZoomDisabled: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = pagetitle
        titleLbl.font = applyBotFont(bold: true, size: 18)
        activityIndicator.color = .systemBlue
        activityIndicator.backgroundColor = .clear
        activityIndicator.hidesWhenStopped = true
        addHeaderBlurEffect()
        webView.navigationDelegate = self
        webView.contentMode = .scaleAspectFill
        //closeBtn.setTitle("Close".localForChosnLangCodeBB, for: .normal)
        let attributedString = NSAttributedString(string: "Close".localForChosnLangCodeBB, attributes: [.foregroundColor : closeBtn.tintColor, .font : applyBotFont(bold: true, size: 15)])
        closeBtn.setAttributedTitle(attributedString, for: .normal)
        isZoomDisabled ?  disableZooming()  : ()
       
        
    }
    override func viewDidAppear(_ animated: Bool) {
        loadURL()
    }
    
    func addHeaderBlurEffect()  {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = headerView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        headerView.insertSubview(blurEffectView, at: 0)
    }
    
    func loadURL()  {
        if let url = URL(string: initialUrl ?? "")  , UIApplication.shared.canOpenURL(url){
            startLoadingAnimation()
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
        }else{
            stoprLoadingAnimation()
            showErrorMessage("can't open the URL") {
                self.dismiss(animated: true, completion: nil)
            }
            
        }
    }
    
    func disableZooming() {
        let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" +
            "head.appendChild(meta);"
        
        let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        webView.configuration.userContentController.addUserScript(script)
    }
    
    
    func startLoadingAnimation() {
        activityIndicator.startAnimating()
    }
    
    func stoprLoadingAnimation() {
        activityIndicator.stopAnimating()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension WebPageViewController: WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish loading ...." , initialUrl)
        stoprLoadingAnimation()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        stoprLoadingAnimation()
        print("faile to open ...." , initialUrl)
    }
}

