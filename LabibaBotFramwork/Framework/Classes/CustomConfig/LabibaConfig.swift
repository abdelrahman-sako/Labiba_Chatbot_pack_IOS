//
//  LabibaConfig.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman on 6/29/20.
//  Copyright © 2020 Abdul Rahman. All rights reserved.
//



//MARK: -Production
//******************************************

import Foundation
public class LabibaConfig {
    public init() {

    }
 //   weak var vc:UIViewController?
    var callback:(()->Void)?
    //*************
    var conversationVC:ConversationViewController?
    //*************
    public func BOJConnect(language:String ,customerID:String,trxnlimit:Int,callback:(()->Void)?){
        self.callback = callback
        //MARK: initialization
      // Labiba.initialize(RecipientIdAR:"5bfcd0bf-cb9a-4034-96ff-7c67000df2d3",RecipientIdEng: "45515613-1713-4031-bade-54ef60563547")// bot builder IDs
        Labiba.initialize(RecipientIdAR:"b553e8c1-d9d9-409e-b5b4-573a63506dce",RecipientIdEng: "45515613-1713-4031-bade-54ef60563547")// // BOJ builder IDs
//
        Labiba.setBotLanguage(LangCode: language == "Arabic" ? .ar : .en)
        Labiba.createCustomReferral(object: ["Customer ID":customerID,"trxnlimit":trxnlimit])


        //MARK: Theme
//        Labiba.setDelegate(delegate: self)
//        Labiba.set_basePath("https://boji.bankofjordan.com.jo")
//        Labiba.set_messagingServicePath("/api/MobileAPI/MessageHandler")
//
//        Labiba.set_voiceBasePath("https://boji.bankofjordan.com.jo")
//        Labiba.set_voiceServicePath("/api/VoiceAPI/VoiceClip")
//        Labiba.set_loggingServicePath("/api/MobileAPI/FetchHelpPage")
        
        // UAT server
//        Labiba.set_basePath("http://10.121.1.8")
//        Labiba.set_messagingServicePath("/api/MobileAPI/MessageHandler")
//
//        Labiba.set_voiceBasePath("https://10.121.1.8")
//        Labiba.set_voiceServicePath("/handlers/Translate.ashx")
//        Labiba.set_loggingServicePath("/api/Mobile/LogAPI")
        
//        Labiba.set_basePath("https://bojibot.bankofjordan.com.jo")
//        Labiba.set_messagingServicePath("/api/MobileAPI/MessageHandler")
//        Labiba.set_voiceBasePath("https://bojibot.bankofjordan.com.jo")
//        Labiba.set_voiceServicePath("/api/VoiceAPI/VoiceClip")
        
        LabibaThemes.isThemeApplied = true
        Labiba.setBotType(botType: .visualizer)

        //Labiba.setChatMainBackground(image:  Image(named: "BOJ_bg") ) // important note : UIImage will read the image from the main project target not from Labiba target
        Labiba.BackgroundView.background = .image(image: Image(named: "BOJ_bg")! )
        Labiba.setLogo(UIImage(named: ""))

        
        Labiba.UserChatBubble.background = .solid(color:  UIColor.black.withAlphaComponent(0.1))
        Labiba.UserChatBubble.textColor = UIColor(argb: 0xffffffff)
        Labiba.UserChatBubble.cornerRadius = 23
        Labiba.UserChatBubble.cornerMaskPin = .up
        //Labiba.UserChatBubble.cornerMask = [.layerMinXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]

        Labiba.BotChatBubble.typingIndicatorColor = UIColor(argb: 0xffffffff)
        Labiba.BotChatBubble.background = .solid(color: UIColor.white.withAlphaComponent(0.2))
        Labiba.BotChatBubble.textColor =  UIColor(argb: 0xffffffff)
        Labiba.BotChatBubble.cornerRadius = 23
        Labiba.BotChatBubble.cornerMaskPin = .up
        //Labiba.BotChatBubble.cornerMask =  [.layerMaxXMaxYCorner,.layerMinXMaxYCorner,.layerMaxXMinYCorner]
        
        
        Labiba.setMargin(left: 20, right: 20)

        Labiba.VoiceAssistantView.micButton.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        Labiba.VoiceAssistantView.micButton.tintColor = UIColor(argb: 0xffffffff)
        Labiba.VoiceAssistantView.waveColor = UIColor(argb: 0xffffffff)
        
        Labiba.MenuCardView.backgroundColor = UIColor(argb: 0x00ffffff)
        Labiba.MenuCardView.clearNonSelectedItems = false
        Labiba.MenuCardView.textColor =  UIColor(argb: 0xffffffff)
        Labiba.MenuCardView.fontSize = 12
       
//        Labiba.CarousalCardView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
//        Labiba.CarousalCardView.cornerRadius = 30
//        Labiba.CarousalCardView.titleFont = (14,.bold)
//        Labiba.CarousalCardView.buttonSeparatorLine = ( UIColor.white.withAlphaComponent(0.1) , 25)
//        let bColor1 = UIColor(argb: 0x1100263E)
//        let bColor2 = UIColor(argb: 0xff00263E)
//        Labiba.CarousalCardView.bottomGradient = Labiba.GradientSpecs.init(colors: [bColor1 , bColor2 ], locations: [0,1],  start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0, y: 1) )
        
        Labiba.CarousalCardView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        Labiba.CarousalCardView.cornerRadius = 14
        Labiba.CarousalCardView.titleFont = (18,.bold)
        Labiba.CarousalCardView.buttonSeparatorLine = ( UIColor.white , 25)
        Labiba.CarousalCardView.border = (1,UIColor.white.withAlphaComponent(0.2))
        Labiba.CarousalCardView.buttonBorder = (1,UIColor.white.withAlphaComponent(0.6))
        Labiba.CarousalCardView.buttonFont = (13,.regular)
        Labiba.CarousalCardView.buttonCornerRadius = 40
     //   Labiba.CarousalCardView.backgroundImageStyleEnabled = true
        
        
        
        Labiba.MapView.cornerRadius = 20

        Labiba.ChoiceView.backgroundColor = .clear
        Labiba.ChoiceView.tintColor = UIColor(argb: 0xffffffff)
        Labiba.ChoiceView.borderColor =  UIColor(argb: 0xffffffff)

        Labiba.UserInputView.sendButton.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        Labiba.UserInputView.sendButton.tintColor = UIColor(argb: 0xffffffff)
        
        Labiba.attachmentThemeModel.menu.background = UIColor.black.withAlphaComponent(0.1)
        Labiba.attachmentThemeModel.menu.tint = UIColor(argb: 0xffffffff)
        Labiba.UserInputView.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        Labiba.UserInputView.tintColor = .white
        Labiba.UserInputView.textColor  = .white
        Labiba.UserInputView.hintColor =  UIColor(argb: 0xccffffff)
        
       // Labiba.setMicButtondIcon(icon: UIImage(named: "BOJ Logo")!)
        Labiba.setFont(regAR: "Cairo-Regular", boldAR: "Cairo-Bold", regEN: "Cairo-Regular", boldEN: "Cairo-Bold")
        Labiba.setHeaderBackground(gradient: Labiba.GradientSpecs.init(colors: [UIColor(argb: 0xff0C263C) ,UIColor(argb: 0xff0C263C),UIColor(argb: 0x000C263C) ], locations: [0 ,0.85,1], start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0, y: 1) , viewBackgroundColor: .clear)) // Toolbar
        Labiba.setStatusBarColor(color:UIColor(argb: 0xff0C263C))
        Labiba.isMuteButtonHidden = false
         let bodyAndTitles = ["en_title":"\"Hi, I’m BOJI!\"","ar_title": "\"مرحبا، أنا بوجي!\""  , "en_body": "Please tap the mic icon below to ask me\n a question.", "ar_body":"يمكنك الضغط على زر الميكرفون أدناه لكي تتحدث معي وتسألني أي سؤال"  ]

        let header = GreetingHeaderView.create(bodyAndTitle: bodyAndTitles )
        header.settingType = .help
        header.centerImageView.isHidden = true
        header.homeButton.isHidden = true
       // header.settingButton.isHidden = true
       header.settingButton.setImage(Image(named: "info_Icon"), for: .normal)
        header.closeButton.setImage(Image(named: "cancelled"), for: .normal)
        header.volumUpImage = Image(named: "unmute-icon")
        header.volumOffImage = Image(named: "mute-icon")
        header.leftStackLeadingCons.constant = 10
        header.leftStackTopCons.constant = 10
        header.leftStackHightCons.constant = 46//UIScreen.main.bounds.width/7.1
        header.righStackTrailingCons.constant = 13
        header.righStackTopCons.constant = 10
        header.righStackHightCons.constant = 46
        header.centerImageTopCons.constant = 30
        header.centerImageWidthCons.constant = 85
        header.flibView()

        Labiba.setCustomHeaderView(header, withHeight: 150)
        header.resetUIs()
        Labiba.setVoiceAssistanteRate(ARrate: 0.9, ENRate: 0.9)
        Labiba.setListeningDuration(Duration: 1.0)
        Labiba.setStatusBarStyle(style: .lightContent)
        Labiba.setEnableAutoListening(enable: true)
        Labiba.isLoggingEnabled = true
       Labiba.setVoiceMan(ar: "ar-XA-Standard-D", en: "en-US-Wavenet-C")


        //*************
        let vc = Labiba.createConversation()
        vc.modalPresentationStyle = .fullScreen
        self.conversationVC = vc as? ConversationViewController
        //*************


       UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)

        //UIApplication.shared.topMostViewController?.navigationController?.pushViewController(vc, animated: true)
    }
}

extension LabibaConfig : LabibaDelegate {
    public func createPost(onView view: UIView, _ data: Dictionary<String, Any>, completionHandler: @escaping (Bool, [String : Any]?) -> Void) {
        print("createPost called successfully")
        self.callback?()
        UIApplication.shared.topMostViewController?.dismiss(animated: true, completion: {
            print("chatbot screen was closed")
        })
    }

    public func labibaWillClose() {
        print("labiba will close add whatever you want here")
    }
}



//MARK: -Testing
//******************************************

//import Foundation
////import "FFI"
//public class LabibaConfig {
//    public init() {
//
//    }
//
//    var callback:(()->Void)?
//    var conversationVC:ConversationViewController?
//
//
//    public func BOJConnect(language:String ,customerID:String, callback:(()->Void)?){
//        self.callback = callback
//        //MARK: initialization
//        Labiba.initialize(RecipientIdAR:"5bfcd0bf-cb9a-4034-96ff-7c67000df2d3",RecipientIdEng: "45515613-1713-4031-bade-54ef60563547")
//        Labiba.setBotLanguage(LangCode: language == "Arabic" ? .ar : .en)
//        Labiba.createCustomReferral(object: ["Customer ID":customerID])
//
//
//        //MARK: Theme
//        Labiba.setDelegate(delegate: self)
//        Labiba.set_basePath("http://10.121.1.8")
//        Labiba.set_messagingServicePath("/api/MobileAPI/MessageHandler")
//        Labiba.set_voiceBasePath("http://10.121.1.8")
//        Labiba.set_voiceServicePath("/Handlers/Translate.ashx")
//
//        LabibaThemes.isThemeApplied = true
//        Labiba.setBotType(botType: .visualizer)
//
//        Labiba.setChatMainBackground(image:  Image(named: "BOJ_bg") ) // important note : UIImage will read the image from the main project target not from Labiba target
//
//        Labiba.setLogo(UIImage(named: ""))
//
//        Labiba.setUserBubbleBackground(color:  UIColor.black.withAlphaComponent(0.1))
//        Labiba.setUserBubbleTextColor( color : UIColor(argb: 0xffffffff))
//        Labiba.setUserBubbleCorner(corner: 23, mask: [.layerMinXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner])
//
//        Labiba.setTypingIndicatorColor(color: UIColor(argb: 0xffffffff))
//        Labiba.setBotBubbleBackground(color: UIColor.white.withAlphaComponent(0.2))
//        Labiba.setBotBubbleText(color: UIColor(argb: 0xffffffff))
//        Labiba.setBotBubbleCorner(corner: 23, mask: [.layerMaxXMaxYCorner,.layerMinXMaxYCorner,.layerMaxXMinYCorner])
//
//        Labiba.setMargin(left: 20, right: 20)
//
//        Labiba.setMicButtonColors(background: UIColor.black.withAlphaComponent(0.1), tint: UIColor(argb: 0xffffffff) , wave: UIColor(argb: 0xffffffff))
//
//        Labiba.setMenuCardsCollectionColor(color: .clear)
//        Labiba.setMenuCardSetup(color: UIColor(argb: 0x00ffffff), clearNonSelectedItems: false)
//        Labiba.setMenuCardText(color: UIColor(argb: 0xffffffff), fontSize: 12)
//
//        Labiba.setCarousalCardColor(backgroundColor: UIColor.black.withAlphaComponent(0.1) , cornerRadius: 30)
//        Labiba._CarousalCardTitleFont = (14,.bold)
//        Labiba._CarousalCardTitleColor = UIColor(argb: 0xffffffff)
//        Labiba._CarousalCardSubtitleColor = UIColor(argb: 0xEEffffff)
//        Labiba._CarousalCardButtonTitleColor = UIColor(argb: 0xffffffff)
//        Labiba._CarousalCardButtonBorder = ( UIColor.white.withAlphaComponent(0.1) , 25)
//        let bColor1 = UIColor(argb: 0x1100263E)
//        let bColor2 = UIColor(argb: 0xff00263E)
//        Labiba.setCarousalCardBottom(gradient:  Labiba.GradientSpecs.init(colors: [bColor1 , bColor2 ], locations: [0,1],  start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0, y: 1) ))
//
//        Labiba._MapViewCornerRadius = 20
//
//        Labiba.setChoicesButtonColors(background: .clear, tint: UIColor(argb: 0xffffffff), borderColor:  UIColor(argb: 0xffffffff))
//
//
//        Labiba.setSendButtonColors(background: UIColor.black.withAlphaComponent(0.1), tint: UIColor(argb: 0xffffffff))
//        Labiba.setAttachmentMenuColors(background: UIColor.black.withAlphaComponent(0.1), tint: UIColor(argb: 0xffffffff))
//        Labiba.setUserInputColors(background: UIColor.black.withAlphaComponent(0.15), tintColor: .white, textColor: .white, hintColor: UIColor(argb: 0xccffffff))
//        // Labiba.setMicButtondIcon(icon: UIImage(named: "BOJ Logo")!)
//        Labiba.setFont(regAR: "Cairo-Regular", boldAR: "Cairo-Bold", regEN: "Cairo-Regular", boldEN: "Cairo-Bold")
//        Labiba.setHeaderBackground(gradient: Labiba.GradientSpecs.init(colors: [UIColor(argb: 0xff0C263C) ,UIColor(argb: 0xff0C263C),UIColor(argb: 0x000C263C) ], locations: [0 ,0.85,1], start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0, y: 1) , viewBackgroundColor: .clear)) // Toolbar
//        Labiba.setStatusBarColor(color:UIColor(argb: 0xff0C263C))
//        Labiba.isMuteButtonHidden = false
//        let bodyAndTitles = ["en_title":"\"Hi, I’m BOJ!\"","ar_title": "\"مرحبا، أنا بوجي!\""  , "en_body": "Please tap the mic icon below to ask me\n a question.", "ar_body":"يمكنك الضغط على زر الميكرفون أدناه لكي تتحدث معي وتسألني أي سؤال"  ]
//
//        let header = GreetingHeaderView.create(bodyAndTitle: bodyAndTitles )
//        header.centerImageView.isHidden = true
//        header.homeButton.isHidden = true
//        header.settingButton.isHidden = true
//        header.settingButton.setImage(Image(named: "language-icon2"), for: .normal)
//        header.closeButton.setImage(Image(named: "cancelled"), for: .normal)
//        header.volumUpImage = Image(named: "unmute-icon")
//        header.volumOffImage = Image(named: "mute-icon")
//        header.leftStackLeadingCons.constant = 10
//        header.leftStackTopCons.constant = 10
//        header.leftStackHightCons.constant = 46//UIScreen.main.bounds.width/7.1
//        header.righStackTrailingCons.constant = 13
//        header.righStackTopCons.constant = 10
//        header.righStackHightCons.constant = 46
//        header.centerImageTopCons.constant = 30
//        header.centerImageWidthCons.constant = 85
//        header.flibView()
//
//        Labiba.setCustomHeaderView(header, withHeight: 150)
//        header.resetUIs()
//        Labiba.setVoiceAssistanteRate(ARrate: 0.9, ENRate: 0.9)
//        Labiba.setListeningDuration(Duration: 1.0)
//        Labiba.setStatusBarStyle(style: .lightContent)
//        Labiba.setEnableAutoListening(enable: true)
//
//
//
//        //*************
//        let vc = Labiba.createConversation()
//        vc.modalPresentationStyle = .fullScreen
//        self.conversationVC = vc as? ConversationViewController
//        //*************
//
//
//        UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
//
//        //        UIApplication.shared.topMostViewController?.navigationController?.pushViewController(Labiba.createConversation(), animated: true)
//    }
//}
//
//extension LabibaConfig : LabibaDelegate {
//    public func createPost(onView view: UIView, _ data: Dictionary<String, Any>, completionHandler: @escaping (Bool, [String : Any]?) -> Void) {
//
////        self.callback?()
////        self.conversationVC?.backAction()
////        print("Bye")
//        print("createPost called successfully")
//              self.callback?()
//              UIApplication.shared.topMostViewController?.dismiss(animated: true, completion: {
//                  print("chatbot screen was closed")
//                 print("Bye")
//              })
//    }
//}
