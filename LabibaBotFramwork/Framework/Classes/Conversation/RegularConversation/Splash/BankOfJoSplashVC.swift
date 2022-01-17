//
//  BankOfJoSplashVC.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman on 3/1/20.
//  Copyright © 2020 Abdul Rahman. All rights reserved.
//

import UIKit
//import Kingfisher
public class BankOfJoSplashVC: SplashVC {
    
    @IBOutlet weak var imageView: UIImageView!
    public override static func create() -> BankOfJoSplashVC
    {
        return Labiba.splashStoryboard.instantiateViewController(withIdentifier: "BankOfJoSplashVC") as! BankOfJoSplashVC
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
       // imageView.kf.setImage(with: URL(string: "https://botbuilder.labiba.ai/maker/files/1ea9df06-0a30-44e6-aade-a56cbbd46ccc.png"), placeholder: Image(named: "labiba_icon"))
        
        if let url = URL(string: "https://botbuilder.labiba.ai/maker/files/1ea9df06-0a30-44e6-aade-a56cbbd46ccc.png"){
            imageView.af_setImage(withURL: url, placeholderImage: Image(named: "labiba_icon"))
        }
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return Labiba._StatusBarStyle
    }
    
    public override func viewWillAppear(_ animated: Bool) {
       // Labiba.setStatusBarColor(color: Labiba._StatusBarColor)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func pushChatVC(_ sender: UIButton) {
        // self.navigationController?.pushViewController(Labiba.createConversation(), animated: false) // nathealth
    }
    
    
    
}
