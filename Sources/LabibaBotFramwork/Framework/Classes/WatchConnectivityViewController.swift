//
//  ViewController.swift
//  LabibaWatch
//
//  Created by Abdulrahman Qasem on 13/12/2021.
//

import UIKit
import WatchConnectivity

class WatchConnectivityViewController: UIViewController {
    
    public static func create() -> WatchConnectivityViewController
    {
        return UIStoryboard(name: "WatchConnectivity", bundle: bundle).instantiateViewController(withIdentifier: "WatchConnectivityViewController") as! WatchConnectivityViewController
        
    }
    
    @IBOutlet weak var reachableLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var roundedViews: [UIView]!
    
    var customerID:String = ""
    var trxnlimit:String = ""
    var isReachable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = OneTimeWatchConnectivity.shared
        roundedViews.forEach({$0.layer.cornerRadius = 10})
        activityIndicator.hidesWhenStopped = true
        updateReachabilityColor()
        NotificationCenter.default.addObserver(
            self, selector: #selector(type(of: self).activationDidComplete(_:)),
            name:  Constants.NotificationNames.activationDidComplete, object: nil
        )
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(type(of: self).reachabilityDidChange(_:)),
            name:  Constants.NotificationNames.reachabilityDidChange, object: nil
        )
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
   
    func updateReachabilityColor() {
      
       isReachable = false
       if WCSession.default.activationState == .activated {
           isReachable = WCSession.default.isReachable
       }
       reachableLabel.textColor = isReachable ? .green : .red
       reachableLabel.text = isReachable ? "Watch is  reachable" : "Watch is not reachable"
   }
    
    
    @objc
    func activationDidComplete(_ notification: Notification) {
        updateReachabilityColor()
    }
    
    @objc
    func reachabilityDidChange(_ notification: Notification) {
        updateReachabilityColor()
    }
    
    @IBAction func textFieldDidEdite(_ sender: UITextField) {
        switch sender.tag {
        case 0:
            customerID = sender.text ?? ""
        case 1:
            trxnlimit = sender.text ?? ""
        default:
            break
        }
    }
    
    
    @IBAction func conncect(_ sender: Any) {
        if customerID.isEmpty || trxnlimit.isEmpty {
            showErrorMessage("Please fill all required fields")
            return
        }
        guard let trxnlimitInteger  =  Int(trxnlimit) else{
            showErrorMessage("trxnlimit must be number")
            return
        }
        if !isReachable {
            showErrorMessage("Watch is not reachable \nplease connect your watch and open labibaWhatch App on it then try again")
            return
        }
       // OneTimeWatchConnectivity.shared.sendData(data: ["Customer ID":self.customerID,"trxnlimit":trxnlimitInteger])
        activityIndicator.startAnimating()
        DispatchQueue.main.async {
            WCSession.default.sendMessage(["Customer ID":self.customerID,"trxnlimit":trxnlimitInteger], replyHandler: { dic in
                DispatchQueue.main.async {self.activityIndicator.stopAnimating()}
                if let respose = dic["status"] as? Bool {
                    showErrorMessage(title: "Success", "Data has been successfully transferred to your watch")
                }
            }, errorHandler: { error in
                DispatchQueue.main.async {self.activityIndicator.stopAnimating()}
                showErrorMessage(error.localizedDescription)
            })
        }
        
    }
     
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}

class OneTimeWatchConnectivity:NSObject,WCSessionDelegate{
    
    private(set) var isReachable = false
    private var data:[String:Any]?
    private var dataSent:Bool = false
    
    static let shared = OneTimeWatchConnectivity()
    private override init(){
        super.init()
        WCSession.default.delegate = self
        WCSession.default.activate()
    }
    
//    func sendData(data:[String:Any]){
//        self.data = data
//    }
//
//    private func scheduleDataSendToWatch(){
//        guard let data = data, !dataSent, isReachable else {
//            return
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            WCSession.default.sendMessage(data, replyHandler: {  [weak self]  dic in
//                if (dic["status"] as? Bool) != nil {
//                    showErrorMessage(title: "Success", message: "Data has been successfully transferred to your watch")
//                    self?.dataSent = true
//                }
//            }, errorHandler: { error in
//                showErrorMessage(error.localizedDescription,buttonTitle: "TryAgain") {
//                    self.scheduleDataSendToWatch()
//                }
//            })
//        }
//    }
    
    private func updateRechability(){
        isReachable = false
        if WCSession.default.activationState == .activated {
            isReachable = WCSession.default.isReachable
        }
        
         //   scheduleDataSendToWatch()
        
    }
    
    func postNotificationOnMainQueueAsync(name: NSNotification.Name) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: name, object: nil)
        }
    }
    
    // WCSessionDelegate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        postNotificationOnMainQueueAsync(name: Constants.NotificationNames.activationDidComplete)
        updateRechability()
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        postNotificationOnMainQueueAsync(name:  Constants.NotificationNames.reachabilityDidChange)
        updateRechability()
    }
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
}
