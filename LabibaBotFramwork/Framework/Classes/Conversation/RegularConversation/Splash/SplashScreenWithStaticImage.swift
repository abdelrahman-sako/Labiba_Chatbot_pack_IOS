//
//  SplashScreenWithStaticImage.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman on 9/19/19.
//  Copyright © 2019 Abdul Rahman. All rights reserved.
//

import UIKit
//import Kingfisher
public class SplashScreenWithStaticImage: SplashVC {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet  var startButtons: [UIButton]!
    @IBOutlet weak var wellcomeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var vertualAssistantLbl: UILabel!
    @IBOutlet weak var headerImage: UIImageView!
    
    @IBOutlet weak var enWellcomeLabel: UILabel!
    @IBOutlet weak var enNameLabel: UILabel!
    
    //var id:String = ""
    public override static func create() -> SplashScreenWithStaticImage
    {
        return Labiba.splashStoryboard.instantiateViewController(withIdentifier: "SplashScreenWithStaticImage") as! SplashScreenWithStaticImage
    }
    
    
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        //LabibaThemes.setSharja_Theme()
        self.view.layoutIfNeeded()
        self.navigationController?.isNavigationBarHidden = true
        let gTColor2 = UIColor(argb: 0xff00a6dd)
         let gCColor2 = UIColor(argb: 0xff00a6dd)
        let gEColor2 = UIColor(argb: 0xff0069aa)
        self.view.applyGradient(colours: [gTColor2,gCColor2,gEColor2 ], locations: nil)
        startButtons.forEach { (button) in
            button.layer.cornerRadius = button.frame.height/2
            button.layer.borderWidth = 1.5
            button.layer.borderColor = UIColor.white.cgColor
            if button.tag == 0 {
                button.titleLabel?.font = applyBotFont(textLang: .ar, bold:true, size: 14 )
            }else{
                button.titleLabel?.font = applyBotFont(textLang: .en, size: 13)
            }
        }
        
        wellcomeLabel.font = applyBotFont(textLang: .ar, size: 18)
        nameLabel.font = applyBotFont(textLang: .ar,bold: true, size: 24)
        vertualAssistantLbl.font = applyBotFont(textLang: .ar, size: 20)
        enWellcomeLabel.font = applyBotFont(textLang: .en, size: 18)
        enNameLabel.font = applyBotFont(textLang: .en, size: 22)

       // imageView.kf.setImage(with: URL(string: "https://botbuilder.labiba.ai/maker/files/5ca70eb8-e29a-4c07-a50e-a583a77f2274.png"))
       ///////////////// //imageView.kf.setImage(with: URL(string: "https://botbuilder.labiba.ai/maker/files/a46626a4-5965-4e5e-ba46-f5adfef309e2.png"))// faded
         // headerImage.kf.setImage(with: URL(string: "https://botbuilder.labiba.ai/maker/files/30def70c-c6bf-4c32-a83f-6a03155d0d17.png"))
        
        if let url = URL(string: "https://botbuilder.labiba.ai/maker/files/5ca70eb8-e29a-4c07-a50e-a583a77f2274.png"){
            imageView.af_setImage(withURL: url)
        }
        
        if let url = URL(string: "https://botbuilder.labiba.ai/maker/files/30def70c-c6bf-4c32-a83f-6a03155d0d17.png"){
            headerImage.af_setImage(withURL: url)
        }
        
       addObservers()
      
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(forName: Constants.NotificationNames.languageChanged, object: nil, queue: OperationQueue.main) { [weak self](notification) in
            switch SharedPreference.shared.botLangCode {
            case .ar:
                Labiba.setBotType(botType: .voiceAndKeyboard)
            default:
                Labiba.setBotType(botType: .keyboardWithTTS)
            }
        }
    }
    
    
    
    
    override public func viewWillAppear(_ animated: Bool) {
      //  UIApplication.statusBarBackgroundColor = .clear
        NotificationCenter.default.post(name: Constants.NotificationNames.StopTextToSpeech,
                                        object: nil)
        
    }
    override public func viewDidAppear(_ animated: Bool) {
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
   
    
    func startConversation(lang:LabibaLanguage)  {
        Labiba.initialize(RecipientIdAR: "0de26564-1d53-4c87-87b1-60fd6235e1c3",RecipientIdEng: "283c3d0e-550f-4221-87f7-27adaf401ad6" )
        Labiba.setBotLanguage(LangCode: lang)
        switch SharedPreference.shared.botLangCode  {
        case .ar:
            Labiba.setBotType(botType: .voiceAndKeyboard)
        default:
            Labiba.setBotType(botType: .keyboardWithTTS)
        }
        (Labiba._customHeaderView as? GreetingHeaderView)?.resetUIs() // to handle start language issue in header
        SharedPreference.shared.setUserIDs(ar: "0de26564-1d53-4c87-87b1-60fd6235e1c3", en: "283c3d0e-550f-4221-87f7-27adaf401ad6" ,de:  "bb74141b-099e-497f-adde-990b7836a829", ru:  "0f22a778-09e8-4ae6-8218-6357b1c67157" ,zh:  "453bf578-5226-4cb0-b012-c4bddc0c143a")
        //             LabibaThemes.setSharja_Theme()
        self.navigationController?.pushViewController(ConversationViewController.create(), animated: true )
    }
    
    
    @IBAction func start(_ sender: UIButton) {
        langAction()
    }
    
    func langAction() {
     
        var style:UIAlertController.Style = .alert
        switch UIScreen.current {
        case .iPhone3_5 , .iPhone4_0 ,.iPhone4_7 ,.iPhone5_5 ,.iPhone5_8 ,.iPhone6_1 ,.iPhone6_5:
            style = .actionSheet
        default:
            style = .alert
            
        }
        let alert = UIAlertController(title: "Choose Language",
        message: "", preferredStyle: style)
        let arAction = UIAlertAction(title: "العربية", style: .default, handler: { _ in
            Labiba.setBotLanguage(LangCode: .ar)
            self.startConversation(lang: .ar)
        })
        
        let enAction = UIAlertAction(title: "English", style: .default, handler: { _ in
            Labiba.setBotLanguage(LangCode: .en)
            self.startConversation(lang: .en)
        })
        alert.addAction(enAction)
        alert.addAction(arAction)
        let ruAction = UIAlertAction(title: "русский", style: .default, handler: { _ in
            Labiba.setBotLanguage(LangCode: .ru)
            self.startConversation(lang: .ru)
        })
        let deAction = UIAlertAction(title: "Deutsch", style: .default, handler: { _ in
            Labiba.setBotLanguage(LangCode: .de)
            self.startConversation(lang: .de)
        })
        let znAction = UIAlertAction(title: "俄文", style: .default, handler: { _ in
            Labiba.setBotLanguage(LangCode: .zh)
            self.startConversation(lang: .zh)
        })
        alert.addAction(ruAction)
        alert.addAction(znAction)
        alert.addAction(deAction)
        let cancleAction = UIAlertAction(title: "Cancle", style: .cancel, handler: { _ in
            
            
        })
        alert.addAction(cancleAction)
        getTheMostTopViewController().present(alert, animated: true, completion: {})
        
    }
    
    @IBAction func pop(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
