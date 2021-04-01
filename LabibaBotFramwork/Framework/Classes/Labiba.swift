//
//  Labiba.swift
//  LabibaBotClient_Example
//
//  Created by Suhayb Ahmad on 8/8/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
//import GooglePlaces
//import GoogleMaps

public enum BotType:Int {
    case keyboardType = 1
    case keyboardWithTTS = 2
    case voiceAssistance = 3
    case voiceAndKeyboard = 4
    case voiceToVoice = 5
    case visualizer = 6
}


@objc public class Labiba: NSObject
{

    
    
  //  static var _basePath = "ws://whatsapp.labibabot.com/api/mws"
   // static var _basePath = "ws://botbuilder.labiba.ai/api/mws"
    static var _socketBasePath = "wss://botbuilder.labiba.ai/api/mws"
    static var _basePath = "https://botbuilder.labiba.ai"
    static var _messagingServicePath = "/api/MobileAPI/MessageHandler"
    static var _voiceBasePath = "https://voice.labibabot.com"
    static var _voiceServicePath = "/translate/texttospeech"
    //static var _voiceServicePath = "/Handlers/Translate.ashx")
   // static var _helpPath = "https://botbuilder.labiba.ai/api/MobileAPI/FetchHelpPage"
//    static var _submitRatingPath = "https://botbuilder.labiba.ai/api/ratingform/submit"
//    static var _ratingQuestionsPath = "https://botbuilder.labiba.ai/api/MobileAPI/FetchQuestions"
  //  static var _loggingPath = "http://api.labiba.ai/api/Mobile/LogAPI"
    
    static var  delegate:LabibaDelegate?
    
    static var _BubbleChatImage:UIImage?// = Image(named: "labiba_icon")
   
  //  static var _GoogleApiKey: String!
   
    static var _pageId: String = "NOT_VALID"
    static var _senderId: String!
  
    
    private(set) static var hintsArray:[String]? = nil // add localized keys in ordeer to support both languages
    private(set) static var _OpenFromBubble:Bool = false
    
    public static var liveChatModel:LiveChatModel?
    public static let labibaThemes = LabibaThemes()
    public  static var _WithRatingVC: Bool = false
    public  static var isLoggingEnabled: Bool = false

     // MARK:- Main Settings
    
    public static func initialize(RecipientIdAR: String,RecipientIdEng: String , language:Language = .ar)
    {
       // registerFonts()
        print(Bundle.main.bundleIdentifier)
        SharedPreference.shared.setUserIDs(ar: RecipientIdAR, en: RecipientIdEng)
        setBotLanguage(LangCode: language)
        self._pageId = SharedPreference.shared.currentUserId
       
        LocationService.shared.updateLocation()
        var uuid = "";
        let preferences = UserDefaults.standard
        let SenderId = "SenderId"
        if preferences.object(forKey: SenderId) == nil
        {
            uuid = UUID().uuidString
            preferences.set(uuid, forKey: SenderId)
            preferences.synchronize()
        }
        else
        {
            uuid = preferences.string(forKey: SenderId)!
        }
        setSenderId(uuid)
        if _Referral == nil { createReferral()} // to handel the case (if setUserParams call befor initialize)
        _OpenFromBubble = false
        switch UIScreen.current {
        case .iPad10_5 ,.iPad12_9 ,.iPad9_7 ,.ipad:
            ipadFactor = 1
        default:
            break
        }
    }
    
    public static func setDelegate( delegate: LabibaDelegate)
       {
           self.delegate = delegate
       }
    
    
    public static func setSenderId(_ senderId: String)
    {
        self._senderId = senderId
    }
    
    public static func set_basePath(_ path: String)
    {
        self._basePath = path
    }
    public static func set_messagingServicePath(_ path: String)
    {
        self._messagingServicePath = path
    }
    
    
    
    public static func set_voiceBasePath(_ path: String)
    {
        self._voiceBasePath = path
    }
    
    public static func set_voiceServicePath(_ path: String)
    {
        self._voiceServicePath = path
    }
    
//    public static func set_helpPath(_ path: String)
//    {
//        self._helpPath = path
//    }
      
//    public static func set_ratingQuestionsPath(_ path: String)
//    {
//        self._ratingQuestionsPath = path
//    }
//
//    public static func set_submitRatingPath(_ path: String)
//    {
//        self._submitRatingPath = path
//    }
//
    
    
    
    // MARK:- UserParameters and Referrals
    public static var _ReferralSource:String = "mobile"
    static var _Referral:[String:Any]?
    
    public static func setUserParams( first_name:String? = nil , last_name:String? = nil , profile_pic:String? = nil , gender:String? = nil , location:String? = nil, country:String? = nil , username:String? = nil , email:String? = nil , token:String? = nil , customParameters:[String:String]? = nil){
        let access_token = SharedPreference.shared.refreshToken
        let model = RefModel(access_token: access_token, clientfirstname: first_name, clientlastname: last_name, clientprofilepic: profile_pic, clientgender: gender, client_location: location, client_country: country, client_username: username, client_email: email, token: token , customParameters: customParameters)
        _Referral = ReferralModel(ref: model.arrayJsonString()).modelAsDic()
    }
    
    public static func setRefreshToken(refreshtoken:String){ // this method must call befor setUserParams() not after
        if  refreshtoken != SharedPreference.shared.refreshToken {
            SharedPreference.shared.refreshToken = refreshtoken
            if _Referral == nil {createReferral()}
        }
    }
    
    private static func createReferral()  {
        let model = RefModel(access_token: SharedPreference.shared.refreshToken)
        _Referral = ReferralModel(ref: model.arrayJsonString()).modelAsDic()
    }
    
    static func resetReferral() {
        createCustomReferral(object: nil)
    }
    
    static func createCustomReferral(object:[String:Any]?) {
        let model = RefModel()
        _Referral = ReferralModel(ref: model.customRefModel(object: object)).modelAsDic()
    }
    
    
    
    
    
    // MARK:- Language Settings
    
    static var _LastMessageLangCode = "en"
    
    public static func setBotLanguage(LangCode:Language){
        SharedPreference.shared.botLangCode = LangCode
        self._pageId = SharedPreference.shared.currentUserId
    }
    
    public static func setLastMessageLangCode(_ text: String)
    {
        _LastMessageLangCode = text.detectedLangauge() ?? "en"
        print( _LastMessageLangCode)
    }
    
    
    
    
    
    // MARK:- Bot Type And Font
    
    static var Bot_Type:BotType = .keyboardType
    static var Temporary_Bot_Type:BotType = .keyboardType
    static var font:(regAR:String , boldAR:String , regEN:String , boldEN:String)? =  ( "ChalkboardSE-Light", "ChalkboardSE-Bold",  "ChalkboardSE-Light", "ChalkboardSE-Bold")
    
    public static func setBotType(botType:BotType){
        self.Bot_Type = botType
        self.Temporary_Bot_Type = botType
        if botType == .keyboardType {
            EnableTextToSpeech = false
        }
    }
    
    public static func setFont(regAR:String , boldAR:String , regEN:String , boldEN:String){
        self.font = (regAR,boldAR ,regEN,boldEN)
    }
    
    
    
    
    
    // MARK:- [Text to Speech] And [Speech to Text] Settings
    
    static var ARVoiceRate:Float = 1.3
    static var ENVoiceRate:Float = 1.3
    static var VoiceMan:(ar: String? ,en:String?, de:String?,ru:String?,cn:String?) //= ("ar-XA-Wavenet-A","en-US-Wavenet-F","de-DU-Wavenet-F ","ru-RU-Wavenet-E","cmn-CN-Wavenet-D")
    static private(set) var EnableTextToSpeech:Bool = true
    static private(set) var EnableAutoListening:Bool = false
    static var ListeningDuration:Double = 2
    
    public static func setVoiceAssistanteRate(ARrate:Float ,ENRate:Float){
        ARVoiceRate = ARrate
        ENVoiceRate = ENRate
    }
    
    public static func setVoiceMan(ar:String? ,en:String?){
        VoiceMan.ar = ar != nil ? ar! : VoiceMan.ar
        VoiceMan.en = en != nil ? en! : VoiceMan.en
    }
    
    public static func setEnableTextToSpeech(enable:Bool){
        EnableTextToSpeech = enable
    }
    
    public static func setEnableAutoListening(enable:Bool){
        EnableAutoListening = enable
    }
    
    public static func setListeningDuration(Duration:Double){
        ListeningDuration = Duration
    }
    
    

  
    
    public static func setHintsArray(hints:[String]){
        hintsArray = hints
    }
    
    
    
   
    
  
    //MARK:- ******************THEME SETTING******************
    
     //MARK:- General Theme UIConfiguration
    static var _Margin : (left:CGFloat,right:CGFloat) = (0,0)
    
    public static func setMargin(left:CGFloat, right:CGFloat)
       {
        self._Margin = (left,right)
       }
    
    
    
    //MARK:- Status Bar View UIConfiguration
    
    static var _StatusBarColor : UIColor = .clear
    static var _StatusBarStyle:UIStatusBarStyle = .default
    
    public static func setStatusBarColor(color: UIColor)
    {
        self._StatusBarColor = color
        UIApplication.shared.setStatusBarColor(color: color)
    }
    
    public static func setStatusBarStyle(style:UIStatusBarStyle){
        _StatusBarStyle = style
    }
    
    
    
    
    //MARK:- Header View UIConfiguration
    
    public static var isMuteButtonHidden:Bool = true
    public static var isVedioButtonHidden:Bool = true

    public static var _HeaderTintColor: UIColor = .white
    static var _headerBackgroundGradient: GradientSpecs?
    static var _headerBackgroundColor: UIColor?
    static var _customHeaderView: LabibaChatHeaderView?
    static var _customHeaderViewHeight: CGFloat?
    static var _Logo = Image(named: "")
    
    public static func setHeaderBackground(gradient: GradientSpecs)
    {
        self._headerBackgroundGradient = gradient
    }
    
    public static func setHeaderBackground(color: UIColor)
    {
        self._headerBackgroundColor = color
    }
    
    public static func setCustomHeaderView(_ view: LabibaChatHeaderView, withHeight height: CGFloat = 90)
    {
        self._customHeaderView = view
        self._customHeaderViewHeight = height
    }
    
//    public static func setCustomHeaderView(image:UIImage,lables:[String:String] , hight:CGFloat = 220 , homeImage:UIImage? = nil , settingImage:UIImage? = nil , closeImage:UIImage? = nil,volumUpImage:UIImage? = nil,volumOffImage:UIImage? = nil)
//    {
//        let header = GreetingHeaderView.create( centerImage: image,bodyAndTitle: lables )
//        header.setIcons(homeImage: homeImage, settingImage: settingImage, closeImage: closeImage)
//        header.volumUpImage = volumUpImage
//        header.volumOffImage = volumOffImage
//        Labiba.setCustomHeaderView(header, withHeight: hight)
//    }
    
    public static func setLogo(_ image: UIImage?)
    {
        self._Logo = image
    }
    
    
    
    
    
    //MARK:- Main Background View UIConfiguration
    
    static var _ChatMainBackgroundColor : UIColor?
    static var _ChatMainBackgroundGradient : GradientSpecs?
    static var _ChatMainBackgroundImage : UIImage?
    
    public static func setChatMainBackground(color: UIColor)
    {
        self._ChatMainBackgroundColor = color
    }
    
    public static func setChatMainBackground(gradient: GradientSpecs)
    {
        self._ChatMainBackgroundGradient = gradient
    }
    
    public static func setChatMainBackground(image: UIImage?)
    {
        self._ChatMainBackgroundImage = image
    }
    
    
    
    
    
    //MARK:- Menu Card View UIConfiguration
    public static let MenuCardView = LabibaMenuCardView()
    
//    static var _MenuCardColor: UIColor?
//    static var _MenuCardClearNonSelectedItems: Bool = true
//    static var _MenuCardText:(color: UIColor? , fontSize:CGFloat) = (UIColor.white , 11)
//    static var _MenuCardAlpha: CGFloat? = 1
//    static var _MenuCardsCollectionColor: UIColor?
//    
//    public static func setMenuCardSetup(color: UIColor ,clearNonSelectedItems:Bool = true)
//    {
//        self._MenuCardColor = color
//        self._MenuCardClearNonSelectedItems = clearNonSelectedItems
//    }
//    
//    public static func setMenuCardText(color: UIColor , fontSize:CGFloat = 11)
//    {
//        self._MenuCardText = (color, fontSize)
//    }
//    
//    public static func setMenuCardAlpha(alpha: CGFloat)
//    {
//        self._MenuCardAlpha = alpha
//    }
//    
//    public static func setMenuCardsCollectionColor(color: UIColor)
//    {
//        self._MenuCardsCollectionColor = color
//    }
    
    
    
    
    
    //MARK:- Carousal Card View UIConfiguration
    public static let CarousalCardView = LabibaCarousalCardView()
    
//    static var _CarousalCardBackgroundColor: UIColor = UIColor(argb: 0xFFf7f7f7)
//    static var _CarousalCardCornerRadius: CGFloat = 10
//    static var _CarousalCardTintColor: UIColor = #colorLiteral(red: 0.03137254902, green: 0.3725490196, blue: 1, alpha: 1)
//    public static var _CarousalCardTitleColor: UIColor = UIColor(argb: 0xffffffff)
//    public static var _CarousalCardTitleFont:(size:CGFloat,weight:LabibaFontWeight) = (11,.bold)
//    public static var _CarousalCardSubtitleColor: UIColor =  UIColor(argb: 0xffffffff)
//    public static var _CarousalCardSubtitleFont:(size:CGFloat,weight:LabibaFontWeight) = (11,.regular)
//    public static var _CarousalCardButtonTitleColor:UIColor = UIColor(argb: 0xffffffff)
//    public static var _CarousalCardButtonFont:(size:CGFloat,weight:LabibaFontWeight) = (11,.regular)
//    public static var _CarousalCardButtonBorder:(color:UIColor,inset:CGFloat) = (.white,0)
//    static var _CarousalCardAlpha: CGFloat = 1
//    static var _CarousalBottomGradient: GradientSpecs?
//    static var _CarousalBackgroundImageStyleEnabled: Bool = false
//    
//    public static func setCarousalCardColor(backgroundColor: UIColor , cornerRadius:CGFloat = 10)
//    {
//        self._CarousalCardBackgroundColor = backgroundColor
//        self._CarousalCardCornerRadius = cornerRadius
//    }
//    
//    public static func setCarousalCardAlpha(alpha: CGFloat)
//    {
//        self._CarousalCardAlpha = alpha
//    }
//
//    public static func setCarousalCardBottom(gradient: GradientSpecs)
//    {
//        self._CarousalBottomGradient = gradient
//        self._CarousalBackgroundImageStyleEnabled = true
//    }
//    
//    
    
    
    
    //MARK:- Bottom View : Voice Assistance,keyboard and AttachmentMenu Views UIConfiguration
    public static let UserInputView = LabibaUserInputView()
    public static let VoiceAssistantView = LabibaVoiceAssistantView()
//    static var _UserInputColors:(background: UIColor ,tintColor:UIColor, textColor:UIColor ,hintColor:UIColor) = (UIColor.white ,UIColor.black, UIColor.black , UIColor(white: 0, alpha: 0.3))
//    static var _SendButtonTintColor : UIColor = #colorLiteral(red: 0.03137254902, green: 0.3725490196, blue: 1, alpha: 1)
//    static var _SendButtonBackgroundColor : UIColor?
    
//    static var _MicButtonTintColor: UIColor = UIColor(argb: 0xFFFFFFFF)
//    static var _KeyboardIconTintColor: UIColor = UIColor(argb: 0xFFFFFFFF)
  //  static var _MicButtonBackGroundColor: UIColor = UIColor(argb: 0x8066439F)
   // static var _MicButtonWaveColor: UIColor = UIColor(argb: 0xFFFFFFFF)
  //  static var _MicButtonAlpha: CGFloat = 1
   // static var _MicButtonIcon: UIImage = Image(named: "micIcon")!
   // static var _KeyboardButtonIcon: UIImage = Image(named: "keyboard_icon")!
   // static var _AttachmentButtonIcon: UIImage = Image(named: "paperclip-solid")!
   // public static var  isAttachmentButtonHidden:Bool  = true
   // static var _bottomBackgroundGradient: GradientSpecs?
   
    
//    public static func setUserInputColors(background: UIColor,tintColor:UIColor ,  textColor:UIColor , hintColor:UIColor )
//    {
//        self._UserInputColors = (background ,tintColor ,textColor, hintColor)
//    }
//
//    public static func setSendButtonColors(background: UIColor , tint:UIColor)
//    {
//        self._SendButtonBackgroundColor = background
//        self._SendButtonTintColor = tint
//    }
    
//    public static func setMicButtonColors(background: UIColor , tint:UIColor , wave:UIColor = .white , keyboardTint:UIColor? = nil)
//    {
//        self._MicButtonTintColor = tint
//        self._MicButtonBackGroundColor = background
//        self._MicButtonWaveColor = wave
//        self._KeyboardIconTintColor = keyboardTint ?? tint
//    }
//
//    public static func setMicButtondAlpha(alpha: CGFloat)
//    {
//        self._MicButtonAlpha = alpha
//    }
//    public static func setMicButtondIcon(icon: UIImage)
//       {
//           self._MicButtonIcon = icon
//       }
//    public static func setKeyboardButtondIcon(icon: UIImage)
//    {
//        self._KeyboardButtonIcon = icon
//    }
//    
//    
//    public static func setBottomBackground(gradient: GradientSpecs)
//    {
//        self._bottomBackgroundGradient = gradient
//    }
    
   
    
    //MARK:- Choices Button View UIConfiguration
    public static let ChoiceView = LabibaChoiceView()
    
//    static var _ChoicesButtonBackgroundColor: UIColor = .white
//    static var _ChoicesButtonTintColor: UIColor = .white
//    static var _ChoicesButtonBorderColor: UIColor = .white
//    static var _ChoicesButtonCornerRadius: CGFloat = 10
//    
//    public static func setChoicesButtonColors(background: UIColor ,  tint:UIColor ,borderColor:UIColor,  cornerRadius:CGFloat = 10) // for choice buttons , while border and text color set by setTintColor()
//    {
//        self._ChoicesButtonBackgroundColor = background
//        self._ChoicesButtonTintColor = tint
//        self._ChoicesButtonBorderColor = borderColor
//        self._ChoicesButtonCornerRadius = cornerRadius
//    }
    
    
       //MARK:- Location Setting and Map View UIConfiguration
    public static let MapView = LabibaMapView()
    
//    public static var _MapViewCornerRadius: CGFloat = 10
//    static var  defaultLocation:(latitude:Double , longitude:Double) = (31.9499895,  35.9394769)
//    
//    public static func setDefaultLocation(latitude:Double , longitude:Double)
//    {
//        self.defaultLocation = (latitude  , longitude)
//    }
    
    //MARK:- Attachment Card View UIConfiguration
 public static let attachmentThemeModel = LabibaAttachmentThemeModel()
    
    
//    static var _AttachmentMenuBackgroundColor : UIColor = #colorLiteral(red: 0.03137254902, green: 0.3725490196, blue: 1, alpha: 1)
//    static var _AttachmentMenuTintColor : UIColor = .white
//    
//    public static func setAttachmentMenuColors(background: UIColor , tint:UIColor)
//    {
//        self._AttachmentMenuBackgroundColor = background
//        self._AttachmentMenuTintColor = tint
//    }
    
    //MARK:- Chat Bubble View UIConfiguration
    
    
    public static let UserChatBubble = LabibaUserChatBubble()
    public static let BotChatBubble = LabibaBotChatBubble()
//    static var _userBubbleBackgroundGradient: GradientSpecs?
//    static var _userBubbleBackgroundColor: UIColor = #colorLiteral(red: 0.03137254902, green: 0.3725490196, blue: 1, alpha: 1)
//    static var _userBubbleTextColor: UIColor = UIColor.gray
//    static var _userBubbleAlpha: CGFloat = 1
//    static var _userBubbleCorner: CGFloat = 10
//    static var _userBubbleCornerMask: CACornerMask = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner ,.layerMinXMaxYCorner ,.layerMinXMinYCorner]
//    static var _userAvatar:UIImage?
    
//    static var _TypingIndicatorColor: UIColor?
//    static var _botBubbleBackgroundGradient: GradientSpecs?
//    static var _botBubbleBackgroundColor: UIColor?
//    static var _botBubbleTextColor: UIColor = UIColor.black
//    static var _botBubbleTextAlignment:NSTextAlignment?
//    static var _botBubbleAlpha: CGFloat = 1
//    static var _botBubbleCorner: CGFloat = 10
//    static var _botBubbleCornerMask: CACornerMask = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner ,.layerMinXMaxYCorner ,.layerMinXMinYCorner]
//    public static var _botBubbleShadow: LabibaShadowModel = LabibaShadowModel(shadowColor: UIColor.clear.cgColor, shadowOffset: .zero, shadowRadius: 0, shadowOpacity: 0)
//    static var _botAvatar:UIImage?
    
    
    
//    public static func setUserBubbleBackground(gradient: GradientSpecs)
//    {
//        self._userBubbleBackgroundGradient = gradient
//    }
//
//    public static func setUserBubbleBackground(color: UIColor)
//    {
//        self._userBubbleBackgroundColor = color
//    }
//
//    public static func setUserBubbleTextColor( color: UIColor)
//    {
//        self._userBubbleTextColor = color
//    }
//
//    public static func setUserBubbleAlpha( alpha: CGFloat)
//    {
//        self._userBubbleAlpha = alpha
//    }
//    public static func setUserBubbleCorner( corner: CGFloat,mask:CACornerMask)
//    {
//        self._userBubbleCorner = corner
//        self._userBubbleCornerMask = mask
//    }
//
//    public static func setUserAvatar(_ image: UIImage?)
//    {
//        self._userAvatar = image
//    }
    
//    public static func setTypingIndicatorColor(color: UIColor)
//    {
//        self._TypingIndicatorColor = color
//    }
//
//    public static func setBotBubbleBackground(gradient: GradientSpecs)
//    {
//        self._botBubbleBackgroundGradient = gradient
//    }
//
//    public static func setBotBubbleBackground(color: UIColor)
//    {
//        self._botBubbleBackgroundColor = color
//    }
//
//    public static func setBotBubbleText(color: UIColor , alignment:NSTextAlignment? = nil)
//    {
//        self._botBubbleTextColor = color
//        self._botBubbleTextAlignment = alignment
//    }
//
//    public static func setBotBubbleAlpha( alpha: CGFloat)
//    {
//        self._botBubbleAlpha = alpha
//    }
//
//    public static func setBotBubbleCorner( corner: CGFloat,mask:CACornerMask)
//    {
//        self._botBubbleCorner = corner
//        self._botBubbleCornerMask = mask
//    }
//
//    public static func setBotAvatar(_ image: UIImage?)
//    {
//        self._botAvatar = image
//    }
    
    
    
    //MARK:- Rating Form
  
    public static let RatingForm = LabibaRatingForm()

    
    //MARK:- Globals

    static var bundle: Bundle
    {
        let podBundle = Bundle(for: ConversationViewController.self)
        return podBundle
    }

    static var version:String {
        bundle.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String  ?? "0.0"
    }
    
    static var storyboard: UIStoryboard
    {
        return UIStoryboard(name: "Labiba", bundle: bundle)
    }
    static var ratingStoryboard: UIStoryboard
    {
        return UIStoryboard(name: "Rating", bundle: bundle)
    }
    
    static var voiceExperienceStoryboard: UIStoryboard
    {
        
        return UIStoryboard(name: "LabibaVoiceExperience", bundle: bundle)
    }
    
    
    static var splashStoryboard: UIStoryboard
    {
        return UIStoryboard(name: "SplashScreen", bundle: bundle)
    }

    private static func registerFonts() -> Void
    {
        bundle.urls(forResourcesWithExtension: "ttf", subdirectory: nil)?.forEach({ (fontUrl) in
            
            print(fontUrl)
            Labiba.registerFont(fontURL:fontUrl)
            // UIFont.registerFont(fontURL: fontUrl)
        })
        
        bundle.urls(forResourcesWithExtension: "otf", subdirectory: nil)?.forEach({ (fontUrl) in
            
            print(fontUrl)
            Labiba.registerFont(fontURL:fontUrl)
        })
        
        bundle.urls(forResourcesWithExtension: "TTF", subdirectory: nil)?.forEach({ (fontUrl) in
            
            print(fontUrl)
            Labiba.registerFont(fontURL:fontUrl)
            // UIFont.registerFont(fontURL: fontUrl)
        })
       
    }
    
    static func registerFont(fontURL: URL) -> Bool {
        print("font url   " , fontURL.lastPathComponent)
        FontDownloader.load(URL: fontURL, successWithName: { (fontName) in
            print("register  ", fontName)
        }) { error in
            print(error.localizedDescription)
        }
        return true
    }

    private static let SENDER_ERROR = "You must first provide a unique senderId for your app user. Call Labiba.setSenderId(_ senderId:String) at some point in your application before calling this."

    public static func startConversation(onView vc: UIViewController? = nil, animated: Bool = true, onClose: ConversationCloseHandler? = nil) -> Void
    {

        guard self._senderId != nil
        else
        {
            fatalError(SENDER_ERROR)
        }

        if let topVC = vc ?? getTheMostTopViewController()
        {

            topVC.present(createConversation(onClose: onClose), animated: animated, completion: nil)
        }
    }

    public typealias ConversationCloseHandler = () -> Void
//    public typealias ِExternalTaskCompletionHandler = () -> Void
//
    public static func createConversation(closable: Bool = true, onClose: ConversationCloseHandler? = nil) -> UIViewController
    {

        guard self._senderId != nil
        else
        {
            fatalError(SENDER_ERROR)
        }

        let convVC = ConversationViewController.create()
        convVC.delegate = Labiba.delegate
        convVC.isClosable = closable
        convVC.closeHandler = onClose
        
        return convVC
    }
    
    public static func createVoiceExperienceConversation( onClose: ConversationCloseHandler? = nil) -> UIViewController
    {
        guard self._senderId != nil
            else
        {
            fatalError(SENDER_ERROR)
        }
        let VoiceConvVC = VoiceExperienceVC.create()
        VoiceConvVC.delegate = Labiba.delegate
        VoiceConvVC.closeHandler = onClose
        return VoiceConvVC
    }
    

    public static func createSplash<vc:SplashVC>(vc:vc.Type) -> UIViewController
    {
        return vc.create()
    }

    private static let alias = UIView.loadFromNibNamedFromDefaultBundle("MovableAlias") as! MovableAlias

    public static func showMovableAlias(corner: UIRectCorner, margin: CGFloat = 15, animated: Bool) -> Void
    {

        guard self._senderId != nil
        else
        {
            fatalError(SENDER_ERROR)
        }

        let m = margin
        let rf = UIScreen.main.bounds
        let af = alias.frame

        let pos: CGPoint
        switch corner
        {
        case UIRectCorner.topLeft:
            pos = CGPoint(x: m, y: m)

        case UIRectCorner.topRight:
            pos = CGPoint(x: rf.width - af.width - m, y: m)

        case UIRectCorner.bottomLeft:
            pos = CGPoint(x: m, y: rf.height - af.height - m)

        default:
            pos = CGPoint(x: rf.width - af.width - m, y: rf.height - af.height - m)
        }

        alias.imageView.image = Image(named: "labiba_icon")//self._botAvatar
        alias.show(position: pos, animated: animated)
        _OpenFromBubble = true
    }

    public static func showMovableAlias(position: CGPoint, animated: Bool) -> Void
    {

        guard self._senderId != nil
        else
        {
            fatalError(SENDER_ERROR)
        }

        alias.imageView.image = Image(named: "labiba_icon")//self._botAvatar
        alias.show(position: position, animated: animated)
        _OpenFromBubble = true
    }
    
    // MARK: - Classes
    @objc public class GradientSpecs: NSObject
    {
        public var colors: [UIColor]
        public var locations: [CGFloat]
        public var start: CGPoint
        public var end: CGPoint
        public var viewBackgroundColor: UIColor?
        
        public init(colors: [UIColor], locations: [CGFloat], start: CGPoint, end: CGPoint , viewBackgroundColor:UIColor? = nil)
        {
            self.colors = colors
            self.locations = locations
            self.start = start
            self.end = end
            self.viewBackgroundColor = viewBackgroundColor
        }
    }
    
}

@objc public protocol LabibaDelegate {
    @objc optional func createPost(onView view:UIView,_ data:Dictionary<String, Any> , completionHandler:@escaping(_ status:Bool , _ data:[String:Any]?)->Void)
    @objc optional func liveChatTransfer(onView view:UIView, transferMessage:String)
    @objc optional func labibaWillClose()
}



//extension UIFont
//{
//
//    func registerFont(fontURL: URL) -> Bool
//    {
//
//
//        FontDownloader.load(URL: URL(string:"s")!, successWithName: { (fontName) in
//                       self.customFontLabel.font = UIFont(name: fontName, size: 40)
//                   }) { error in
//                       print(error.localizedDescription)
//                   }
//
//        return true
//    }
//}

//extension UIFont
//{
//
//    @discardableResult static func registerFont(fontURL: URL) -> Bool
//    {
//
//        guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL)
//        else
//        {
//            print("Couldn't load data from the font \(fontURL)")
//            return false
//        }
//
//        let font = CGFont(fontDataProvider)
//
//        var error: Unmanaged<CFError>?
//        let success = CTFontManagerRegisterGraphicsFont(font!, &error)
//
//        guard success
//        else
//        {
//            print("Error registering font: maybe it was already registered.")
//            return false
//        }
//
//        return true
//    }
//}


 

