//
//  IASplashVC.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman on 10/27/19.
//  Copyright © 2019 Abdul Rahman. All rights reserved.
//

import UIKit
//import Kingfisher
class IASplashVC: SplashVC {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var arLabel: UILabel!
    @IBOutlet weak var enLabel: UILabel!
    
        
    public override static func create() -> IASplashVC
        {
            return Labiba.splashStoryboard.instantiateViewController(withIdentifier: "IASplashVC") as! IASplashVC
        }
        
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
             self.navigationController?.isNavigationBarHidden = true
            Labiba.setFont(regAR: "Cairo-Regular", boldAR: "Cairo-Bold", regEN: "Cairo-Regular", boldEN: "Cairo-Bold")
            let gTColor2 = UIColor(argb: 0xffE33D49)
            let gCColor2 = UIColor(argb: 0xffFEA18B)
            self.view.applyGradient(colours: [gTColor2,gCColor2 ], locations: nil)
            startButton.layer.cornerRadius = startButton.frame.height/2
            startButton.layer.borderWidth = 1.5
            startButton.layer.borderColor = UIColor.white.cgColor

             arLabel.font = applyBotFont(textLang: .ar, size: 28)
             enLabel.font = applyBotFont(textLang: .en, size: 28)
           // imageView.kf.setImage(with: URL(string: "https://botbuilder.labiba.ai/maker/files/a56ad424-753f-42d3-9ebe-fb1559cc7b01.png"))
            //idTextField.text = "9ccaab56-12c1-401c-a3df-beddf3845349"  // IA
            
            if let url = URL(string: "https://botbuilder.labiba.ai/maker/files/a56ad424-753f-42d3-9ebe-fb1559cc7b01.png"){
                imageView.af_setImage(withURL: url)
            }
            
            
            
        }
        override func viewWillAppear(_ animated: Bool) {
            NotificationCenter.default.post(name: Constants.NotificationNames.StopTextToSpeech,
                                            object: nil)
        }
  
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
        
        @IBAction func start(_ sender: UIButton) {
            let id = "9ccaab56-12c1-401c-a3df-beddf3845349"
            Labiba.initialize(RecipientIdAR: id,RecipientIdEng: id)
            LabibaThemes.set_IA_Theme()
           //self.navigationController?.pushViewController(Labiba.createConversation(), animated: true)
            Labiba.startConversation(onView: self)
            
        }
    @IBAction func backButton(_ sender: Any) {
        UIApplication.shared.setStatusBarColor(color: .clear)
        if let navVC = self.navigationController {
            navVC.popViewController(animated: true)
        } else {
            self.dismiss(animated: true , completion: nil)
        }
    }
    
      


  

}
