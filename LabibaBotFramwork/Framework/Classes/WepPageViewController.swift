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
    
    static func launchWithUrl(url:String, title:String) -> Void {
        if let topVC = getTheMostTopViewController(),
            let webPageVC = Labiba.storyboard.instantiateViewController(withIdentifier: "WebPageViewController") as? WebPageViewController{
            print("loading....",url)
            webPageVC.initialUrl = url
            webPageVC.pagetitle = title
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = pagetitle
        activityIndicator.color = .systemBlue
        activityIndicator.backgroundColor = .clear
        activityIndicator.hidesWhenStopped = true
        addHeaderBlurEffect()
        webView.navigationDelegate = self
        closeBtn.setTitle("Close".localForChosnLangCodeBB, for: .normal)
        
        
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
            showErrorMessage("can't open the URL")
            
        }
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

