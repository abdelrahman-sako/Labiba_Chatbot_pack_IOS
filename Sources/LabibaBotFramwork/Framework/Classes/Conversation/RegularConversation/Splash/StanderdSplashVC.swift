//
//  StanderdSplashVC.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman on 2/5/20.
//  Copyright © 2020 Abdul Rahman. All rights reserved.
//

import UIKit
//import Kingfisher

 public class StanderdSplashVC: SplashVC {

    public override static func create() -> StanderdSplashVC
       {
           return Labiba.splashStoryboard.instantiateViewController(withIdentifier: "StanderdSplashVC") as! StanderdSplashVC
       }
       
    
    
    @IBOutlet weak var greetingLbl: UILabel!
    @IBOutlet weak var appNameLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var enButton: UIButton!
    @IBOutlet weak var arButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    override  public func viewDidLoad() {
        super.viewDidLoad()
      //  LabibaThemes.setBahrainCredit_Theme()
        
       
        // Labiba.setStatusBarColor(color: UIColor(argb: 0xff253996)) // Statusbar
        
        greetingLbl.font = applyBotFont(textLang: .en, size: 22)
        appNameLbl.font = applyBotFont(textLang: .en, bold: true,size: 35)
        typeLbl.font = applyBotFont(textLang: .en, size: 22)
        enButton.titleLabel?.font = applyBotFont(textLang: .ar, size: 17)
        arButton.titleLabel?.font = applyBotFont(textLang: .ar, size: 17)
        enButton.layer.cornerRadius = enButton.frame.height/2
        arButton.layer.cornerRadius = arButton.frame.height/2
       // imageView.kf.setImage(with: URL(string: "https://botbuilder.labiba.ai/maker/files/c76c8ec4-4339-4dcd-8c5c-e3d8a692bebe.png"))
        
        if let url = URL(string: "https://botbuilder.labiba.ai/maker/files/c76c8ec4-4339-4dcd-8c5c-e3d8a692bebe.png"){
            imageView.af_setImage(withURL: url)
        }
        
    }
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override  public func viewWillAppear(_ animated: Bool) {
          self.navigationController?.isNavigationBarHidden = true
    }
    
    func startConversation()  {
        
        let bodyAndTitles = ["en_title":"\"Hi, I’m Yousif!\"","ar_title": "\"مرحبا، أنا يوسف!\""  , "en_body": "Please tap the mic icon below to ask me a question.", "ar_body":"يمكنك الضغط على زر الميكرفون أدناه لكي تتحدث معي وتسألني أي سؤال"  ]
        let header = GreetingHeaderView.create(centerImageURL:  "https://botbuilder.labiba.ai/maker/files/6f1ec32f-89cb-47f8-8894-9f579be75f09.png" ,bodyAndTitle: bodyAndTitles)
        Labiba.setCustomHeaderView(header, withHeight: 230) // to handel change language case 
        self.navigationController?.pushViewController(ConversationViewController.create(), animated: true )
    }
    
    @IBAction func chooseLangAction(_ sender: UIButton) {
        // 0 ar , 1 en
        Labiba.setBotLanguage(LangCode: sender.tag == 0 ? .ar : .en)
        startConversation()
    }
    

  

}
