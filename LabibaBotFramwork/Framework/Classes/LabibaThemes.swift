//
//  LabibaThemes.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman on 9/2/19.
//  Copyright © 2019 Abdul Rahman. All rights reserved.
//

import Foundation
import UIKit
 public class LabibaThemes {
    public static var isThemeApplied = false
    var default_Gradient_Animation_Colors:[[CGColor]] = [[UIColor(argb:0xffEC1B43).cgColor,UIColor(argb:0xffAFC525).cgColor],
                                                         [UIColor(argb:0xffC127A1).cgColor,UIColor(argb:0xff0F9CBA).cgColor],
                                                         [UIColor(argb:0xffFF9B0F).cgColor,UIColor(argb:0xffEC1B43).cgColor],
                                                         [UIColor(argb:0xffEC1B43).cgColor,UIColor(argb:0xffFF9B0F).cgColor],
                                                         [UIColor(argb:0xff3485BD).cgColor,UIColor(argb:0xff66439F).cgColor],
                                                         [UIColor(argb:0xffC127A1).cgColor,UIColor(argb:0xff13D67C).cgColor]]
    
    var BSF_Gradient_Animation_Colors:[[CGColor]]     =  [[UIColor(argb:0xffFFFFFF).cgColor,UIColor(argb:0xff196576).cgColor],
                                                         [UIColor(argb:0xff2695AD).cgColor,UIColor(argb:0xffFFFFFF).cgColor],
                                                         [UIColor(argb:0xffFFFFFF).cgColor,UIColor(argb:0xff248FA7).cgColor],
                                                         [UIColor(argb:0xffFFFFFF).cgColor,UIColor(argb:0xff01AACF).cgColor],
                                                         [UIColor(argb:0xffFFFFFF).cgColor,UIColor(argb:0xff31C0E0).cgColor],
                                                         [UIColor(argb:0xff196576).cgColor,UIColor(argb:0xffFFFFFF).cgColor]]
    

    
    func setChatDefaultTheme()
    {
        LabibaThemes.isThemeApplied = true
        Labiba.setBotType(botType: .keyboardType)
     
        let gTColor2 = UIColor(argb: 0xff66439F)
        let gEColor2 = UIColor(argb: 0xff0F9CBA)
        Labiba.BackgroundView.background = .gradient(gradientSpecs:  Labiba.GradientSpecs.init(colors: [gTColor2  , gEColor2], locations: [0 ,1],  start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0, y: 1) ))
        
        
        Labiba.UserChatBubble.background = .solid(color:  UIColor(argb: 0x803a5b76))
        Labiba.UserChatBubble.textColor = UIColor(argb: 0xffffffff)
        Labiba.UserChatBubble.alpha = 0.6
        
        
        Labiba.BotChatBubble.background = .solid(color: UIColor(argb: 0x20ffffff))
        Labiba.BotChatBubble.textColor = UIColor(argb: 0xffffffff)
        Labiba.BotChatBubble.avatar = Image(named: "")
        Labiba.BotChatBubble.typingIndicatorColor = UIColor(argb: 0xffffffff)
        
        Labiba.setLogo(Image(named: "labiba_icon"))

        Labiba.CarousalCardView.backgroundColor = UIColor(argb: 0xaa292929)
        
        Labiba.UserInputView.sendButton.backgroundColor = UIColor(argb: 0xff005569)
        Labiba.UserInputView.sendButton.tintColor = UIColor(argb: 0xffffffff)
        
        Labiba.attachmentThemeModel.menu.background = UIColor(argb: 0xff4670A2)
        Labiba.attachmentThemeModel.menu.tint = UIColor(argb: 0xffffffff)
        Labiba.ChoiceView.backgroundColor = .clear
        Labiba.ChoiceView.tintColor = UIColor(argb: 0x95ffffff)
        Labiba.ChoiceView.borderColor =  UIColor(argb: 0x95ffffff)
        
        Labiba.setFont(regAR: "TheSans-Plain", boldAR: "TheSans-Bold", regEN: "AvantGarde-Medium", boldEN: "AvantGarde-Bold")
    }
    
    public static func setVoiceDefaultTheme()
    {
        //LabibaThemes.isThemeApplied = true
        Labiba.setBotType(botType: .voiceAndKeyboard)
        let gTColor1 = UIColor(argb: 0xff2a2930)
        let gEColor1 = UIColor(argb: 0x002a2930)
        Labiba.setHeaderBackground(gradient: Labiba.GradientSpecs.init(colors: [gTColor1 , gEColor1], locations: [0 ,1], start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0, y: 1) , viewBackgroundColor: .clear)) // Toolbar
        Labiba.setStatusBarColor(color:  gTColor1) // Statusbar
        
        let gTColor2 = UIColor(argb: 0xff66439F)
        //let gMColor2 = UIColor(argb: 0xff3485BD)
        let gEColor2 = UIColor(argb: 0xff0F9CBA)
        //Labiba.setChatMainBackground(gradient: Labiba.GradientSpecs.init(colors: [gTColor2  , gEColor2], locations: [0 ,1],  start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0, y: 1) ))
        Labiba.BackgroundView.background = .gradient(gradientSpecs: Labiba.GradientSpecs.init(colors: [gTColor2  , gEColor2], locations: [0 ,1],  start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0, y: 1) ))
        
        
//        Labiba.setUserBubbleBackground(color:  UIColor(argb: 0x803a5b76))
//        Labiba.setUserBubbleTextColor( color : UIColor(argb: 0xffffffff))
//        Labiba.setUserBubbleAlpha(alpha: 0.6)
        
        Labiba.UserChatBubble.background = .solid(color:  UIColor(argb: 0x803a5b76))
        Labiba.UserChatBubble.textColor = UIColor(argb: 0xffffffff)
        Labiba.UserChatBubble.alpha = 0.6
        
//        Labiba.setBotBubbleBackground(color: UIColor(argb: 0x20ffffff))
//        Labiba.setBotBubbleText(color: UIColor(argb: 0xffffffff))
//        Labiba.setBotAvatar(Image(named: ""))
//        Labiba.setTypingIndicatorColor(color: UIColor(argb: 0xffffffff))
//
        Labiba.BotChatBubble.background = .solid(color: UIColor(argb: 0x20ffffff))
        Labiba.BotChatBubble.textColor = UIColor(argb: 0xffffffff)
        Labiba.BotChatBubble.avatar = Image(named: "")
        Labiba.BotChatBubble.typingIndicatorColor = UIColor(argb: 0xffffffff)
        
        Labiba.setLogo(Image(named: "labiba_icon"))
        Labiba.MenuCardView.backgroundColor = UIColor(argb:  0x6066439F)
        Labiba.CarousalCardView.backgroundColor = UIColor(argb: 0xaa292929)
        Labiba.CarousalCardView.titleColor = UIColor(argb: 0xffffffff)
        Labiba.CarousalCardView.subtitleColor = UIColor(argb: 0xffffffff)
        Labiba.CarousalCardView.buttonTitleColor = UIColor(argb: 0xffffffff)
        //Labiba.setCarousalCardColor(backgroundColor: UIColor(argb: 0xaa292929))
       // Labiba._CarousalCardTitleColor = UIColor(argb: 0xffffffff)
//        Labiba._CarousalCardSubtitleColor = UIColor(argb: 0xffffffff)
//        Labiba._CarousalCardButtonTitleColor = UIColor(argb: 0xffffffff)
        
        
     //   Labiba.setSendButtonColors(background: UIColor(argb: 0xff005569), tint: UIColor(argb: 0xffffffff))
        Labiba.UserInputView.sendButton.backgroundColor = UIColor(argb: 0xff005569)
        Labiba.UserInputView.sendButton.tintColor = UIColor(argb: 0xffffffff)
        
        //Labiba.setAttachmentMenuColors(background: UIColor(argb: 0xff4670A2), tint: UIColor(argb: 0xffffffff))
        Labiba.attachmentThemeModel.menu.background = UIColor(argb: 0xff4670A2)
        Labiba.attachmentThemeModel.menu.tint = UIColor(argb: 0xffffffff)
        //Labiba.setChoicesButtonColors(background: .clear, tint: UIColor(argb: 0x95ffffff), borderColor: UIColor(argb: 0x95ffffff))
        Labiba.ChoiceView.backgroundColor = .clear
        Labiba.ChoiceView.tintColor = UIColor(argb: 0x95ffffff)
        Labiba.ChoiceView.borderColor =  UIColor(argb: 0x95ffffff)
        //Labiba.setFont(regAR: "TheSans-Plain", boldAR: "TheSans-Bold", regEN: "AvantGarde-Medium", boldEN: "AvantGarde-Bold")
       // Labiba.setMicButtondAlpha(alpha: 0.8)
        Labiba.VoiceAssistantView.micButton.alpha = 0.8
        Labiba.setVoiceAssistanteRate(ARrate: 0.9, ENRate: 0.9)
    }
    
     public static func setLabibaTheme()
    {
        LabibaThemes.isThemeApplied = true
//        Labiba.Bot_Type = .voiceAndKeyboard
//        Labiba.Temporary_Bot_Type = .voiceAssistance
        Labiba.setBotType(botType: .voiceAndKeyboard)
        //Labiba.setBotLanguage(LangCode: .en)
        let gTColor1 = UIColor(argb: 0xff2a2930)
        // let gMColor1 = UIColor(argb: 0x102a2930)
        let gEColor1 = UIColor(argb: 0x002a2930)
        //Labiba.setHeaderBackground(gradient: Labiba.GradientSpecs.init(colors: [gTColor1 , gEColor1], locations: [0 ,1], start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0, y: 1) , viewBackgroundColor: .clear)) // Toolbar
        //Labiba.setStatusBarColor(color:  gTColor1) // Statusbar
        
        let gTColor2 = UIColor(argb: 0xff66439F)
        //let gMColor2 = UIColor(argb: 0xff3485BD)
        let gEColor2 = UIColor(argb: 0xff0F9CBA)
//        Labiba.setChatMainBackground(gradient: Labiba.GradientSpecs.init(colors: [gTColor2  , gEColor2], locations: [0 ,1],  start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0, y: 1) ))
        Labiba.BackgroundView.background = .gradient(gradientSpecs:  Labiba.GradientSpecs.init(colors: [gTColor2  , gEColor2], locations: [0 ,1],  start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0, y: 1) ))
        
//        Labiba.setUserBubbleBackground(color:  UIColor(argb: 0x803a5b76))
//        Labiba.setUserBubbleTextColor( color : UIColor(argb: 0xffffffff))
//        Labiba.setUserBubbleAlpha(alpha: 0.6)
        
        Labiba.UserChatBubble.background = .solid(color:  UIColor(argb: 0x803a5b76))
        Labiba.UserChatBubble.textColor = UIColor(argb: 0xffffffff)
        Labiba.UserChatBubble.alpha = 0.6
        
        
//        Labiba.setBotBubbleBackground(color: UIColor(argb: 0x20ffffff))
//        Labiba.setBotBubbleText(color: UIColor(argb: 0xffffffff))
//        Labiba.setBotAvatar(Image(named: ""))
//        Labiba.setTypingIndicatorColor(color: UIColor(argb: 0xffffffff))
        
        Labiba.BotChatBubble.background = .solid(color: UIColor(argb: 0x20ffffff))
        Labiba.BotChatBubble.textColor = UIColor(argb: 0xffffffff)
        Labiba.BotChatBubble.avatar = Image(named: "")
        Labiba.BotChatBubble.typingIndicatorColor = UIColor(argb: 0xffffffff)
        
        Labiba.setLogo(Image(named: "labiba_icon"))

        //Labiba.MenuCardView.backgroundColor = UIColor(argb:  0x6066439F)
        Labiba.CarousalCardView.backgroundColor = UIColor(argb: 0xaa292929)
//        Labiba.CarousalCardView.titleColor = UIColor(argb: 0xffffffff)
//        Labiba.CarousalCardView.subtitleColor = UIColor(argb: 0xffffffff)
//        Labiba.CarousalCardView.buttonTitleColor = UIColor(argb: 0xffffffff)
//        Labiba.setCarousalCardColor(backgroundColor: UIColor(argb: 0xaa292929))
       // Labiba._CarousalCardTitleColor = UIColor(argb: 0xffffffff)
      //  Labiba._CarousalCardSubtitleColor = UIColor(argb: 0xffffffff)
       // Labiba._CarousalCardButtonTitleColor = UIColor(argb: 0xffffffff)
        
       
        //Labiba.setSendButtonColors(background: UIColor(argb: 0xff005569), tint: UIColor(argb: 0xffffffff))
        Labiba.UserInputView.sendButton.backgroundColor = UIColor(argb: 0xff005569)
        Labiba.UserInputView.sendButton.tintColor = UIColor(argb: 0xffffffff)
        
        //Labiba.setAttachmentMenuColors(background: UIColor(argb: 0xff4670A2), tint: UIColor(argb: 0xffffffff))
        Labiba.attachmentThemeModel.menu.background = UIColor(argb: 0xff4670A2)
        Labiba.attachmentThemeModel.menu.tint = UIColor(argb: 0xffffffff)
       // Labiba.setChoicesButtonColors(background: .clear, tint: UIColor(argb: 0x95ffffff), borderColor: UIColor(argb: 0x95ffffff))
        Labiba.ChoiceView.backgroundColor = .clear
        Labiba.ChoiceView.tintColor = UIColor(argb: 0x95ffffff)
        Labiba.ChoiceView.borderColor =  UIColor(argb: 0x95ffffff)
        
        Labiba.setFont(regAR: "TheSans-Plain", boldAR: "TheSans-Bold", regEN: "AvantGarde-Medium", boldEN: "AvantGarde-Bold")
       // Labiba.setMicButtondAlpha(alpha: 0.8)
        Labiba.VoiceAssistantView.micButton.alpha = 0.8
        Labiba.setVoiceAssistanteRate(ARrate: 0.9, ENRate: 0.9)
        Labiba.setListeningDuration(Duration: 1)
        
    }
    
    public static func  setBSF_Theme() {
        LabibaThemes.isThemeApplied = true
//        Labiba.Bot_Type = .keyboardType
//        Labiba.Temporary_Bot_Type = .keyboardType
        Labiba.setBotType(botType: .keyboardType)
        let gTColor1 = UIColor(argb: 0xff196575)
        let gEColor1 = UIColor(argb: 0xff015468)
        Labiba.setHeaderBackground(gradient: Labiba.GradientSpecs.init(colors: [gTColor1 , gEColor1], locations: [0 ,1], start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0, y: 1) , viewBackgroundColor: .clear)) // Toolbar
        
        Labiba.setStatusBarColor(color:  gTColor1) // Statusbar
        //Labiba.setChatMainBackground(color: UIColor(argb: 0xffFCFBFF))
        Labiba.BackgroundView.background = .solid(color: UIColor(argb: 0xffFCFBFF))
        Labiba.BackgroundView.background = .solid(color: UIColor(argb: 0xffFCFBFF))
        
//        Labiba.setUserBubbleBackground(color:  UIColor(argb: 0xff156274))
//        Labiba.setUserBubbleTextColor( color : UIColor(argb: 0xffffffff))
        
        Labiba.UserChatBubble.background = .solid(color:  UIColor(argb: 0xff156274))
        Labiba.UserChatBubble.textColor = UIColor(argb: 0xffffffff)
        
//        Labiba.setBotBubbleBackground(color: UIColor(argb: 0xffE8E8E8))
//        Labiba.setBotBubbleText(color: UIColor(argb: 0xff505050))
//        Labiba.setBotAvatar(Image(named: "BSF_Chatbot_logo"))
//        Labiba.setTypingIndicatorColor(color: UIColor(argb: 0xff196576))
//
        Labiba.BotChatBubble.background = .solid(color: UIColor(argb: 0xffE8E8E8))
        Labiba.BotChatBubble.textColor = UIColor(argb: 0xff505050)
        Labiba.BotChatBubble.avatar = Image(named: "BSF_Chatbot_logo")
        Labiba.BotChatBubble.typingIndicatorColor = UIColor(argb: 0xff196576)
        
        Labiba.setLogo(Image(named: "BSF_Chatbot_logo"))

        Labiba.MenuCardView.backgroundColor = UIColor(argb: 0xffffffff)
        Labiba.MenuCardView.textColor = UIColor(argb: 0xff7ab125)
        Labiba.CarousalCardView.backgroundColor = UIColor(argb: 0xFFF196576)
        Labiba.CarousalCardView.titleColor = UIColor(argb: 0xffffffff)
        Labiba.CarousalCardView.subtitleColor = UIColor(argb: 0xffffffff)
        Labiba.CarousalCardView.buttonTitleColor = UIColor(argb: 0xffffffff)
       // Labiba.setCarousalCardColor(backgroundColor: UIColor(argb: 0xFFF196576))
        //Labiba._CarousalCardTitleColor = UIColor(argb: 0xffffffff)
       // Labiba._CarousalCardSubtitleColor = UIColor(argb: 0xffffffff)
       // Labiba._CarousalCardButtonTitleColor = UIColor(argb: 0xffffffff)
        
        
       // Labiba.setChoicesButtonColors(background: .clear, tint: UIColor(argb: 0xff0D5060), borderColor: UIColor(argb: 0xff0D5060))
        Labiba.ChoiceView.backgroundColor = .clear
        Labiba.ChoiceView.tintColor = UIColor(argb: 0xff0D5060)
        Labiba.ChoiceView.borderColor =  UIColor(argb: 0xff0D5060)
        
        //Labiba.setSendButtonColors(background: UIColor(argb: 0xff005569), tint: UIColor(argb: 0xffffffff))
        Labiba.UserInputView.sendButton.backgroundColor = UIColor(argb: 0xff005569)
        Labiba.UserInputView.sendButton.tintColor = UIColor(argb: 0xffffffff)
        
        //Labiba.setAttachmentMenuColors(background: UIColor(argb: 0xff005569), tint: UIColor(argb: 0xffffffff))
        Labiba.attachmentThemeModel.menu.background = UIColor(argb: 0xff005569)
        Labiba.attachmentThemeModel.menu.tint = UIColor(argb: 0xffffffff)
        
       // Labiba.setMicButtondAlpha(alpha: 0.8)
    }
    
     static func  setNatHealth_Theme() {
        LabibaThemes.isThemeApplied = true
        Labiba.setBotType(botType: .voiceAndKeyboard)
        let gTColor1 = UIColor(argb: 0xff5488B8)
        let gCColor1 = UIColor(argb: 0xff5488B8)
        let gEColor1 = UIColor(argb: 0x005488B8)
        //Labiba.setHeaderBackground(gradient: Labiba.GradientSpecs.init(colors: [gTColor1 ,gCColor1 , gEColor1], locations: [0 ,0.85,1], start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0, y: 1) , viewBackgroundColor: .clear)) // Toolbar
        
        Labiba.setStatusBarColor(color: gTColor1) // Statusbar
        let gTColor2 = UIColor(argb: 0xff5488B8)
        let gEColor2 = UIColor(argb: 0xff6FC1EB)
        Labiba.BackgroundView.background = .gradient(gradientSpecs: Labiba.GradientSpecs.init(colors: [gTColor2  , gEColor2], locations: [0 ,1],  start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0, y: 1) ))
        Labiba.UserChatBubble.background = .solid(color:  UIColor(argb: 0x803a5b76))
        Labiba.UserChatBubble.textColor = UIColor(argb: 0xffffffff)
        
        
        Labiba.BotChatBubble.background = .solid(color: UIColor(argb: 0x10ffffff))
        Labiba.BotChatBubble.textColor = UIColor(argb: 0xffffffff)
        Labiba.BotChatBubble.textAlignment = .justified
        Labiba.BotChatBubble.typingIndicatorColor = UIColor(argb: 0xffffffff)
        
        
        Labiba.VoiceAssistantView.micButton.backgroundColor =  UIColor(argb: 0x904670A2)
        Labiba.VoiceAssistantView.micButton.tintColor =  UIColor(argb: 0xffffffff)
        
        
        Labiba.MenuCardView.backgroundColor = UIColor(argb: 0x00ffffff)
        Labiba.MenuCardView.clearNonSelectedItems = false
        Labiba.MenuCardView.textColor =  UIColor(argb: 0xffffffff)
        Labiba.MenuCardView.fontSize = 12
        
        Labiba.CarousalCardView.backgroundColor = UIColor(argb: 0xaa292929)
        Labiba.CarousalCardView.titleColor = UIColor(argb: 0xffffffff)
        Labiba.CarousalCardView.subtitleColor = UIColor(argb: 0xffffffff)
        Labiba.CarousalCardView.buttonTitleColor = UIColor(argb: 0xffffffff)
        
        
        
        Labiba.ChoiceView.backgroundColor = .clear
        Labiba.ChoiceView.tintColor = UIColor(argb: 0xffffffff)
        Labiba.ChoiceView.borderColor =  UIColor(argb: 0xffffffff)
        
        Labiba.UserInputView.sendButton.backgroundColor = UIColor(argb: 0xff005569)
        Labiba.UserInputView.sendButton.tintColor = UIColor(argb: 0xffffffff)
        Labiba.UserInputView.backgroundColor = .white
        Labiba.UserInputView.tintColor = UIColor(argb: 0xff4670A2)
        Labiba.UserInputView.textColor = .black
        Labiba.UserInputView.hintColor = .gray
        
        Labiba.attachmentThemeModel.menu.background = UIColor(argb: 0xff4670A2)
        Labiba.attachmentThemeModel.menu.tint = UIColor(argb: 0xffffffff)
       
        Labiba.VoiceAssistantView.background = .gradient(gradientSpecs: Labiba.GradientSpecs.init(colors: [UIColor(argb:   0x000069aa)  , UIColor(argb:  0xff0069aa)], locations: [0 ,1],  start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0, y: 1) ))
        
        
        
      
        let header = QuickChoicesHeaderView.create( centerImage:  UIImage(named: "natali"))
        Labiba.setCustomHeaderView(header, withHeight: 260)
        
        Labiba._WithRatingVC = true
        Labiba.setFont(regAR: "TheSans-Plain", boldAR: "TheSans-Bold", regEN: "AvantGarde-Medium", boldEN: "AvantGarde-Bold")
        Labiba.setVoiceAssistanteRate(ARrate: 0.9, ENRate: 0.9)
    }
    
    public static func  setSharja_Theme() {
        LabibaThemes.isThemeApplied = true
//        Labiba.Bot_Type = .voiceAndKeyboard
//        Labiba.Temporary_Bot_Type = .voiceAndKeyboard
        
        switch SharedPreference.shared.botLangCode  {
        case .ar:
            Labiba.setBotType(botType: .voiceAndKeyboard)
        default:
            Labiba.setBotType(botType: .keyboardWithTTS)
        }
//        Blue: #0069aa
//        Light Blue: #00a6dd
        
        let gTColor1 = UIColor(argb: 0xff00a6dd)
        let gCColor1 = UIColor(argb: 0xff00a6dd)
        let gEColor1 = UIColor(argb: 0x0000a6dd)
        Labiba.setHeaderBackground(gradient: Labiba.GradientSpecs.init(colors: [gTColor1 ,gCColor1 , gEColor1], locations: [0 ,0.85,1], start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0, y: 1) , viewBackgroundColor: .clear)) // Toolbar
        
        Labiba.setStatusBarColor(color:  gTColor1) // Statusbar
        let gTColor2 = UIColor(argb:0xff00a6dd)
         let gCColor2 = UIColor(argb:0xff00a6dd)
        let gEColor2 = UIColor(argb:0xff0069aa)
//        Labiba.setChatMainBackground(gradient: Labiba.GradientSpecs.init(colors: [gTColor2 , gCColor2 , gEColor2], locations: [0 ,0.5,1],  start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0, y: 1) ))
        Labiba.BackgroundView.background = .gradient(gradientSpecs: Labiba.GradientSpecs.init(colors: [gTColor2 , gCColor2 , gEColor2], locations: [0 ,0.5,1],  start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0, y: 1) ))
//        Labiba.setUserBubbleBackground(color:  UIColor(argb: 0x803a5b76))
//        Labiba.setUserBubbleTextColor( color : UIColor(argb: 0xffffffff))
        Labiba.UserChatBubble.background = .solid(color:  UIColor(argb: 0x803a5b76))
        Labiba.UserChatBubble.textColor = UIColor(argb: 0xffffffff)
        
        
//        Labiba.setBotBubbleBackground(color: UIColor(argb: 0x50ffffff))
//        Labiba.setBotBubbleText(color: UIColor(argb: 0xffffffff))
//        Labiba.setTypingIndicatorColor(color: UIColor(argb: 0xffffffff))
        
        Labiba.BotChatBubble.background = .solid(color: UIColor(argb: 0x50ffffff))
        Labiba.BotChatBubble.textColor = UIColor(argb: 0xffffffff)
        Labiba.BotChatBubble.typingIndicatorColor = UIColor(argb: 0xffffffff)
        
       // Labiba.setMicButtonColors(background: UIColor(argb: 0xee0069aa), tint: UIColor(argb: 0xeeffffff))
        Labiba.VoiceAssistantView.micButton.backgroundColor = UIColor(argb: 0xee0069aa)
        Labiba.VoiceAssistantView.micButton.tintColor = UIColor(argb: 0xeeffffff)
        
        Labiba.MenuCardView.backgroundColor = UIColor(argb: 0xffffffff)
        Labiba.MenuCardView.textColor = UIColor(argb: 0xff7ab125)
        
       //Labiba.setMenuCardsCollectionColor(color: .clear)
       // Labiba.setMenuCardSetup(color: UIColor(argb: 0xffffffff))
        // Labiba.setMenuCardText(color:  UIColor(argb: 0xff7ab125), fontSize: 11)
        Labiba.CarousalCardView.backgroundColor = UIColor(argb: 0xaa292929)
        Labiba.CarousalCardView.titleColor = UIColor(argb: 0xffffffff)
        Labiba.CarousalCardView.subtitleColor = UIColor(argb: 0xffffffff)
        Labiba.CarousalCardView.buttonTitleColor = UIColor(argb: 0xffffffff)
        
//        Labiba.setCarousalCardColor(backgroundColor: UIColor(argb: 0xaa292929))
//        Labiba._CarousalCardTitleColor = UIColor(argb: 0xffffffff)
//        Labiba._CarousalCardSubtitleColor = UIColor(argb: 0xffffffff)
//        Labiba._CarousalCardButtonTitleColor = UIColor(argb: 0xffffffff)
        
        
        
       // Labiba.setChoicesButtonColors(background: .clear, tint: UIColor(argb: 0xffffffff), borderColor:  UIColor(argb: 0xffffffff))
        Labiba.ChoiceView.backgroundColor = .clear
        Labiba.ChoiceView.tintColor = UIColor(argb: 0xffffffff)
        Labiba.ChoiceView.borderColor =  UIColor(argb: 0xffffffff)
        
      //  Labiba.setSendButtonColors(background: UIColor(argb: 0xff005569), tint: UIColor(argb: 0xffffffff))
        Labiba.UserInputView.sendButton.backgroundColor = UIColor(argb: 0xff005569)
        Labiba.UserInputView.sendButton.tintColor = UIColor(argb: 0xffffffff)
        
        // Labiba.setUserInputColors(background: .white, tintColor: UIColor(argb: 0xff4670A2), textColor: .black, hintColor: .gray)
        Labiba.UserInputView.backgroundColor = .white
        Labiba.UserInputView.tintColor = UIColor(argb: 0xff4670A2)
        Labiba.UserInputView.textColor = .black
        Labiba.UserInputView.hintColor = .gray
        
        //Labiba.setAttachmentMenuColors(background: UIColor(argb: 0xff4670A2), tint: UIColor(argb: 0xffffffff))
        Labiba.attachmentThemeModel.menu.background = UIColor(argb: 0xff4670A2)
        Labiba.attachmentThemeModel.menu.tint = UIColor(argb: 0xffffffff)
//         Labiba.setBottomBackground(gradient: Labiba.GradientSpecs.init(colors: [UIColor(argb:   0x000069aa)  , UIColor(argb:  0xff0069aa)], locations: [0 ,1],  start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0, y: 1) ))
        Labiba.VoiceAssistantView.background = .gradient(gradientSpecs:  Labiba.GradientSpecs.init(colors: [UIColor(argb:   0x000069aa)  , UIColor(argb:  0xff0069aa)], locations: [0 ,1],  start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0, y: 1) ))
        
        let bodyAndTitles = ["en_title":"\"Hi, I’m Fatima!\"",
                             "ar_title":"\"مرحبا، أنا فاطمة\"" ,
                             "de_title": "\"Hi, ich bin Fatima!\"" ,
                             "ru_title": "\"Привет, я Фатима!\"" ,
                             "zh_title":"\"嗨，我是法蒂瑪!\"",
                             "en_body":"Type in what you are looking for",
                             "ar_body":"الرجاء الضغط على زر الميكرفون لكي تتحدث معي أو كتابة ما تبحث عنه"  ,
                             "de_body":"Geben Sie ein, was Sie suchen",
                             "ru_body":"Введите то, что ищете",
                             "zh_body":"输入你要找的东西。" ]
        let header = GreetingHeaderView.create(withAction: false, appLogoImgURl: "https://botbuilder.labiba.ai/maker/files/87c7f1da-fcdf-45f5-bd4c-63bce290e9fe.png",centerImageURL:  "https://botbuilder.labiba.ai/maker/files/d818657b-91f5-4b38-ae93-e65f5e240004.png",bodyAndTitle: bodyAndTitles)
        Labiba.setCustomHeaderView(header, withHeight: 210)
        Labiba.setVoiceAssistanteRate(ARrate: 0.9, ENRate: 0.9)
       // Labiba.setFont(font: .DINNextLTW23)
        Labiba.setFont(regAR: "DINNextLTW23-Regular", boldAR: "DINNextLTW23-Bold", regEN: "DINNextLTW23-Regular", boldEN: "DINNextLTW23-Bold")
        //Labiba.setDefaultLocation(latitude: 25.322327, longitude: 55.513641)
        Labiba.MapView.defaultLocation = ( 25.322327, 55.513641)
        // Labiba.setMicButtondAlpha(alpha: 0.8)
    }
   
    
    
    
      public static func  set_IA_Theme() {
        LabibaThemes.isThemeApplied = true
            Labiba.setBotType(botType: .voiceAndKeyboard)
            let gTColor1 = UIColor(argb: 0xffE33D49)
            let gCColor1 = UIColor(argb: 0x00E33D49)
            Labiba.setHeaderBackground(gradient: Labiba.GradientSpecs.init(colors: [gTColor1 ,gCColor1], locations: [0,1], start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0, y: 1) , viewBackgroundColor: .clear)) // Toolbar
            
            Labiba.setStatusBarColor(color:  gTColor1) // Statusbar
        
        let gTColor2 = UIColor(argb: 0xffE33D49)
        let gCColor2 = UIColor(argb: 0xffFEA18B)
        
        
//        Labiba.setChatMainBackground(gradient: Labiba.GradientSpecs.init(colors: [gTColor2 , gCColor2 ], locations: [0,1],  start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0, y: 1) ))
        Labiba.BackgroundView.background = .gradient(gradientSpecs: Labiba.GradientSpecs.init(colors: [gTColor2 , gCColor2 ], locations: [0,1],  start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0, y: 1) ))
        
        
        let vTColor2 = UIColor(argb: 0x00FEA18B)
        let vCColor2 = UIColor(argb: 0xffFEA18B)
//        Labiba.setBottomBackground(gradient:  Labiba.GradientSpecs.init(colors: [ vTColor2 ,vCColor2  ], locations: [0,1],  start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0, y: 1) ))
        Labiba.VoiceAssistantView.background = .gradient(gradientSpecs: Labiba.GradientSpecs.init(colors: [ vTColor2 ,vCColor2  ], locations: [0,1],  start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0, y: 1) ))
        
           //Labiba.setLogo(Image(named: "ia"))
//            Labiba.setUserBubbleBackground(color:  UIColor(argb: 0x803a5b76))
//            Labiba.setUserBubbleTextColor( color : UIColor(argb: 0xffffffff))
        Labiba.UserChatBubble.background = .solid(color:  UIColor(argb: 0x803a5b76))
        Labiba.UserChatBubble.textColor = UIColor(argb: 0xffffffff)
            
//            Labiba.setBotBubbleBackground(color: UIColor(argb: 0x50ffffff))
//        Labiba.setBotBubbleText(color: UIColor(argb: 0xffffffff))
//        Labiba.setTypingIndicatorColor(color: UIColor(argb: 0xffffffff))
        
        Labiba.BotChatBubble.background = .solid(color: UIColor(argb: 0x50ffffff))
        Labiba.BotChatBubble.textColor = UIColor(argb: 0xffffffff)
        Labiba.BotChatBubble.typingIndicatorColor = UIColor(argb: 0xffffffff)
            
         //   Labiba.setMicButtonColors(background: UIColor(argb: 0x80E33D49), tint: UIColor(argb: 0x10ffffff))
        Labiba.VoiceAssistantView.micButton.backgroundColor = UIColor(argb: 0x80E33D49)
        Labiba.VoiceAssistantView.micButton.tintColor = UIColor(argb: 0x10ffffff)
        
        Labiba.MenuCardView.backgroundColor = UIColor(argb: 0xffffffff)
        Labiba.MenuCardView.textColor = UIColor(argb: 0xff7ab125)
          //  Labiba.setMenuCardsCollectionColor(color: .clear)
//            Labiba.setMenuCardSetup(color: UIColor(argb: 0xffffffff))
//            Labiba.setMenuCardText(color:  UIColor(argb: 0xff7ab125), fontSize: 11)
        Labiba.CarousalCardView.backgroundColor = UIColor(argb: 0xaa292929)
        Labiba.CarousalCardView.titleColor = UIColor(argb: 0xffffffff)
        Labiba.CarousalCardView.subtitleColor = UIColor(argb: 0xffffffff)
        Labiba.CarousalCardView.buttonTitleColor = UIColor(argb: 0xffffffff)
        
//        Labiba.setCarousalCardColor(backgroundColor: UIColor(argb: 0xaa292929))
//        Labiba._CarousalCardTitleColor = UIColor(argb: 0xffffffff)
//        Labiba._CarousalCardSubtitleColor = UIColor(argb: 0xffffffff)
//        Labiba._CarousalCardButtonTitleColor = UIColor(argb: 0xffffffff)
        
            
            
      //  Labiba.setChoicesButtonColors(background: .clear, tint: UIColor(argb: 0xffffffff), borderColor: UIColor(argb: 0xffffffff))
        Labiba.ChoiceView.backgroundColor = .clear
        Labiba.ChoiceView.tintColor = UIColor(argb: 0xffffffff)
        Labiba.ChoiceView.borderColor =  UIColor(argb: 0xffffffff)
        
       // Labiba.setSendButtonColors(background: UIColor(argb: 0xffE33D49), tint: UIColor(argb: 0xffffffff))
        Labiba.UserInputView.sendButton.backgroundColor = UIColor(argb: 0xffE33D49)
        Labiba.UserInputView.sendButton.tintColor = UIColor(argb: 0xffffffff)
        
          //  Labiba.setAttachmentMenuColors(background: UIColor(argb: 0xff4670A2), tint: UIColor(argb: 0xffffffff))
        Labiba.attachmentThemeModel.menu.background = UIColor(argb: 0xff4670A2)
        Labiba.attachmentThemeModel.menu.tint = UIColor(argb: 0xffffffff)
            
            Labiba.setFont(regAR: "DINNextLTW23-Regular", boldAR: "DINNextLTW23-Bold", regEN: "DINNextLTW23-Regular", boldEN: "DINNextLTW23-Bold")
            Labiba.setVoiceAssistanteRate(ARrate: 1.3, ENRate: 1.1)
            //Labiba.setDefaultLocation(latitude: 25.322327, longitude: 55.513641)
        Labiba.MapView.defaultLocation = ( 25.322327, 55.513641)
            Labiba.setEnableTextToSpeech(enable: true)
            // Labiba.setMicButtondAlpha(alpha: 0.8)
        }
    
    public static func  setBahrainCredit_Theme() {

        LabibaThemes.isThemeApplied = true
        Labiba.setBotType(botType: .voiceAndKeyboard)
       let gTColor1 = UIColor(argb: 0xff253996)

        Labiba.setHeaderBackground(gradient: Labiba.GradientSpecs.init(colors: [gTColor1 ,gTColor1 ], locations: [0 ,1], start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0, y: 1) , viewBackgroundColor: .clear)) // Toolbar
        
        Labiba.setStatusBarColor(color: gTColor1) // Statusbar
//         Labiba.setChatMainBackground(gradient: Labiba.GradientSpecs.init(colors: [UIColor.white , UIColor.white ], locations: [0,1],  start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0, y: 1) ))
        Labiba.BackgroundView.background = .gradient(gradientSpecs: Labiba.GradientSpecs.init(colors: [UIColor.white , UIColor.white ], locations: [0,1],  start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0, y: 1) ))
      //  Labiba.setChatMainBackground(color: UIColor.white)
        
//        Labiba.setUserBubbleBackground(color:  UIColor(argb: 0xffE6E6E6))
//        Labiba.setUserBubbleTextColor( color : UIColor(argb: 0xff253996))
        Labiba.UserChatBubble.background = .solid(color:  UIColor(argb: 0xffE6E6E6))
        Labiba.UserChatBubble.textColor = UIColor(argb: 0xff253996)
        
        
//        Labiba.setBotBubbleBackground(color: UIColor(argb: 0xffE6E6E6))
//        Labiba.setBotBubbleText(color: UIColor(argb: 0xff253996))
//        Labiba.setTypingIndicatorColor(color: UIColor(argb: 0xff253996))
        
        Labiba.BotChatBubble.background = .solid(color: UIColor(argb: 0xffE6E6E6))
        Labiba.BotChatBubble.textColor = UIColor(argb: 0xff253996)
        Labiba.BotChatBubble.typingIndicatorColor = UIColor(argb: 0xff253996)
        
       // Labiba.setMicButtonColors(background: UIColor(argb: 0xffE6E6E6), tint: UIColor(argb: 0xff00008B) , wave: UIColor(argb: 0xff253996))
        Labiba.VoiceAssistantView.micButton.backgroundColor = UIColor(argb: 0xffE6E6E6)
        Labiba.VoiceAssistantView.micButton.tintColor = UIColor(argb: 0xff00008B)
        Labiba.VoiceAssistantView.waveColor = UIColor(argb: 0xff253996)
        
        let vTColor2 = UIColor(argb: 0x00ffffff)
        let vCColor2 = UIColor(argb: 0xffffffff)
        let vEColor2 = UIColor(argb: 0xffffffff)
//        Labiba.setBottomBackground(gradient:  Labiba.GradientSpecs.init(colors: [ vTColor2 ,vCColor2 ,vEColor2 ], locations: [0,0.1,1],  start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0, y: 1) ))
        Labiba.VoiceAssistantView.background = .gradient(gradientSpecs: Labiba.GradientSpecs.init(colors: [ vTColor2 ,vCColor2 ,vEColor2 ], locations: [0,0.1,1],  start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0, y: 1) ))
        
        
        Labiba.MenuCardView.backgroundColor = UIColor(argb: 0x00ffffff)
        Labiba.MenuCardView.clearNonSelectedItems = false
        Labiba.MenuCardView.textColor = UIColor(argb: 0xff253996)
        Labiba.MenuCardView.fontSize = 12
       // Labiba.setMenuCardsCollectionColor(color: .clear)
       // Labiba.setMenuCardSetup(color: UIColor(argb: 0x00ffffff), clearNonSelectedItems: false)
       // Labiba.setMenuCardText(color: UIColor(argb: 0xff253996), fontSize: 12)
        Labiba.CarousalCardView.backgroundColor = UIColor(argb: 0xaa9199a1)
        Labiba.CarousalCardView.titleColor = UIColor(argb: 0xff253996)
        Labiba.CarousalCardView.subtitleColor = UIColor(argb: 0xff253996)
        Labiba.CarousalCardView.buttonTitleColor = UIColor(argb: 0xff253996)
        
//        Labiba.setCarousalCardColor(backgroundColor: UIColor(argb: 0xaa9199a1))
//        Labiba._CarousalCardTitleColor = UIColor(argb: 0xff253996)
//        Labiba._CarousalCardSubtitleColor = UIColor(argb: 0xff253996)
//        Labiba._CarousalCardButtonTitleColor = UIColor(argb: 0xff253996)
        
        
        
        //Labiba.setChoicesButtonColors(background: .clear, tint: UIColor(argb: 0xff253996), borderColor: UIColor(argb: 0xff253996))
        Labiba.ChoiceView.backgroundColor = .clear
        Labiba.ChoiceView.tintColor = UIColor(argb: 0xff253996)
        Labiba.ChoiceView.borderColor =  UIColor(argb: 0xff253996)
        
       // Labiba.setSendButtonColors(background: UIColor(argb: 0xff253996), tint: UIColor(argb: 0xffffffff))
        Labiba.UserInputView.sendButton.backgroundColor = UIColor(argb: 0xff253996)
        Labiba.UserInputView.sendButton.tintColor = UIColor(argb: 0xffffffff)
        //Labiba.setUserInputColors(background: UIColor(argb: 0xffE6E6E6), tintColor: UIColor(argb: 0xff253996), textColor: UIColor(argb: 0xff253996), hintColor: .darkGray)
        Labiba.UserInputView.backgroundColor = UIColor(argb: 0xffE6E6E6)
        Labiba.UserInputView.tintColor = UIColor(argb: 0xff253996)
        Labiba.UserInputView.textColor = UIColor(argb: 0xff253996)
        Labiba.UserInputView.hintColor = .darkGray
        
        
        //Labiba.setAttachmentMenuColors(background: UIColor(argb: 0xff253996), tint: UIColor(argb: 0xffffffff))
        Labiba.attachmentThemeModel.menu.background = UIColor(argb: 0xff253996)
        Labiba.attachmentThemeModel.menu.tint = UIColor(argb: 0xffffffff)
       
       // Labiba.setFont(regAR: "TheSans-Plain", boldAR: "TheSans-Bold", regEN: "AvantGarde-Medium", boldEN: "AvantGarde-Bold")
           let bodyAndTitles = ["en_title":"\"Hi, I’m Yousif!\"","ar_title": "\"مرحبا، أنا يوسف!\""  , "en_body": "Please tap the mic icon below to ask me a question.", "ar_body":"يمكنك الضغط على زر الميكرفون أدناه لكي تتحدث معي وتسألني أي سؤال"  ]
        let header = GreetingHeaderView.create(centerImageURL:  "https://botbuilder.labiba.ai/maker/files/6f1ec32f-89cb-47f8-8894-9f579be75f09.png" ,bodyAndTitle: bodyAndTitles)
        Labiba.setCustomHeaderView(header, withHeight: 230)
        Labiba.setVoiceMan(ar: "ar-XA-Wavenet-B", en: "en-US-Wavenet-A")
        Labiba.setVoiceAssistanteRate(ARrate: 0.9, ENRate: 0.9)
      }
    
    
    // public static func setVoiceAssistantDefaultTheme()
    //    {
    //        LabibaThemes.isThemeApplied = true
    //        Labiba.Bot_Type = .voiceAssistance
    //        Labiba.Temporary_Bot_Type = .voiceAssistance
    //        let gTColor1 = UIColor(argb: 0xff213F7F)
    //        let gMColor1 = UIColor(argb: 0x20213F7F)
    //        let gEColor1 = UIColor(argb: 0x00213F7F)
    //        Labiba.setHeaderBackground(gradient: Labiba.GradientSpecs.init(colors: [gTColor1 , gMColor1 , gEColor1], locations: [0 , 0.75 ,1], start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0, y: 1) , viewBackgroundColor: .clear)) // Toolbar
    //        Labiba.setStatusBarColor(color:  gTColor1) // Statusbar
    //
    //        let gTColor2 = UIColor(argb: 0xff657495)
    //        let gMColor2 = UIColor(argb: 0xff3D508A)
    //        let gEColor2 = UIColor(argb: 0xff234181)
    //        Labiba.setChatMainBackground(gradient: Labiba.GradientSpecs.init(colors: [gTColor2 , gMColor2 , gEColor2], locations: [0 , 0.5 ,1], start: CGPoint.init(x: 1, y: 0.5), end: CGPoint.init(x: 0, y: 1.5) ))
    //
    //        let gTColor3 = UIColor(argb: 0x80566785)
    //        let gEColor3 = UIColor(argb: 0xff566785)
    //        Labiba.setUserBubbleBackground(gradient: Labiba.GradientSpecs.init(colors: [gTColor3, gEColor3], locations: [0,1], start: CGPoint.init(x: 1, y: 1), end:   CGPoint.init(x: 0, y: 0)))
    //        Labiba.setUserBubbleTextColor( color : UIColor(argb: 0xffffffff))
    //        Labiba.setUserBubbleAlpha(alpha: 0.5)
    //
    //        Labiba.setBotBubbleBackground(color: UIColor(argb: 0x10ffffff))
    //        Labiba.setBotBubbleTextColor(UIColor(argb: 0xffffffff))
    //        Labiba.setBotBubbleAlpha(alpha: 0.8)
    //
    //        Labiba.setLogo(Image(named: ""))
    //        Labiba.setBotAvatar(Image(named: ""))
    //
    //        Labiba.setCardsCollectionColor(color: .clear)
    //        Labiba.setMenuCardColor(color: UIColor(argb: 0xff3A3E49))
    //         Labiba.setMenuCardText(color:  .white, fontSize: 11)
    //        Labiba.setMenuCardAlpha(alpha: 0.5)
    //
    //        Labiba.setCarousalCardAlpha(alpha: 0.5)
    //        Labiba.setTypingIndicatorColor(color: UIColor(argb: 0xffffffff))
    //
    //    }
    
    
}
