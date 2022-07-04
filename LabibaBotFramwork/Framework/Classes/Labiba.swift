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
   // static var _socketBasePath = "wss://botbuilder.labiba.ai/api/mws"
    
    static var _basePath = ""     //"https://botbuilder.labiba.ai"
    static var _messagingServicePath = ""    //"/api/MobileAPI/MessageHandler"
    static var _voiceBasePath = ""     //"https://voice.labibabot.com"
    static var _voiceServicePath = ""      // "/translate/texttospeech"
    static var _loggingServicePath = ""//"/api/MobileAPI/MobileLogging"
    static var _prechatFormServicePath = "/api/PreChatFrom/FetchPreChatFrom"
    static var _uploadUrl = "https://botbuilder.labiba.ai/WebBotConversation/UploadHomeReport"
    static var _helpUrl = ""   //"https://botbuilder.labiba.ai/api/MobileAPI/FetchHelpPage"
    static var _updateTokenUrl = ""   //"http://api.labiba.ai/api/Auth/Login"
    
   // static var _helpServicePath = "/api/Mobile/FetchHelpPage"
    //static var _voiceServicePath = "/Handlers/Translate.ashx")
   
//    static var _submitRatingPath = "https://botbuilder.labiba.ai/api/ratingform/submit"
//    static var _ratingQuestionsPath = "https://botbuilder.labiba.ai/api/MobileAPI/FetchQuestions"
  
    
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
  //  public  static var isLoggingEnabled: Bool = false

     // MARK:- Main Settings
    
    public static func initialize(RecipientIdAR: String,RecipientIdEng: String)
    {
        SharedPreference.shared.setUserIDs(ar: RecipientIdAR, en: RecipientIdEng)
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
    
    public static func set_loggingServicePath(_ path: String)
    {
        self._loggingServicePath = path
    }
    
    public static func set_uploadUrl(_ path: String)
    {
        self._uploadUrl = path
    }
    
    public static func set_helpUrl(_ path: String)
    {
        self._helpUrl = path
    }
    
    public static func set_prechatFormServicePath(_ path: String)
    {
        self._prechatFormServicePath = path
    }
    
    public static func set_updateTokenUrl(_ path: String)
    {
        self._updateTokenUrl = path
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
    
    // MARK:- JWT Token
    static var jwtAuthParamerters:(username:String,password:String) = ("","")
    public static func setJWTAuthParameters(username:String, password:String) {
        jwtAuthParamerters = (username,password)
    }
    // MARK:- Language Settings
    
    static var _LastMessageLangCode = "en"
    
    public static func setBotLanguage(LangCode:LabibaLanguage){
        SharedPreference.shared.botLangCode = LangCode
        self._pageId = SharedPreference.shared.currentUserId
    }
    
    
    
     static func setLastMessageLangCode(_ text: String)
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
    
    // MARK:- Human Agent Transfer
    public static let HumanAgent = HumanAgentSettings() 
    static var isHumanAgentStarted:Bool = false
    
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
    public static var hasBubbleTimestamp:Bool = false
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
    public static var backButtonIcon: UIImage? = Image(named: "ps_back")
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
    public static let BackgroundView = LabibaBackgroundView()

    //MARK:- Requests setting
    public static var timeoutIntervalForRequest:TimeInterval = 60
    public static var bypassSSLCertificateValidation:Bool = false
    
    public static let Logging = LabibaLogging()
    
    //MARK:- Menu Card View UIConfiguration
    public static let MenuCardView = LabibaMenuCardView()
        
    //MARK:- Carousal Card View UIConfiguration
    public static let CarousalCardView = LabibaCarousalCardView()
    
    //MARK:- Bottom View : Voice Assistance,keyboard and AttachmentMenu Views UIConfiguration
    public static let UserInputView = LabibaUserInputView()
    public static let VoiceAssistantView = LabibaVoiceAssistantView()

    //MARK:- Choices Button View UIConfiguration
    public static let ChoiceView = LabibaChoiceView()
    
       //MARK:- Location Setting and Map View UIConfiguration
    public static let MapView = LabibaMapView()
    public static var backgroundLocationUpdate:Bool = true
    
    //MARK:- Attachment Card View UIConfiguration
    public static let attachmentThemeModel = LabibaAttachmentThemeModel()
    
    //MARK:- Chat Bubble View UIConfiguration
    public static let UserChatBubble = LabibaUserChatBubble()
    public static let BotChatBubble = LabibaBotChatBubble()

    //MARK:- Rating Form
    public static let RatingForm = LabibaRatingForm()

    //MARK:- Prechat Form
    public static let PrechatForm = PrechatFormThemeModel()
    
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
    static var prechatFormStoryboard: UIStoryboard
    {
        return UIStoryboard(name: "PrechatForm", bundle: bundle)
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

    static var navigationController:LabibaNavigationController?
    static func createLabibaNavigation(rootViewController:UIViewController) ->LabibaNavigationController{
        navigationController = LabibaNavigationController(rootViewController: rootViewController)
        navigationController!.modalPresentationStyle = .fullScreen
        navigationController!.modalTransitionStyle = .crossDissolve
        if #available(iOS 13.0, *) {
            navigationController?.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        return navigationController!
    }
    public static func startConversation(onView vc: UIViewController, animated: Bool = true)
    {
        
        guard self._senderId != nil
        else
        {
            fatalError(SENDER_ERROR)
        }
        
        let convVC = ConversationViewController.create()
        convVC.delegate = Labiba.delegate
        //convVC.closeHandler = onClose
        //UIApplication.shared.keyWindow?.rootViewController?.present(nav, animated: animated, completion: nil)
        vc.present(createLabibaNavigation(rootViewController: convVC), animated: animated, completion: nil)
    }
    public static func startConversationWithPrechatForm(onView vc: UIViewController, animated: Bool = true)
    {

        guard self._senderId != nil
        else
        {
            fatalError(SENDER_ERROR)
        }
        let prechatVC = Labiba.prechatFormStoryboard.instantiateViewController(withIdentifier: "PrechatFormVC") as! PrechatFormVC
        prechatVC.modalPresentationStyle = .fullScreen
        prechatVC.modalTransitionStyle = .crossDissolve
        vc.present(createLabibaNavigation(rootViewController: prechatVC), animated: animated, completion: nil)
    }

    static func dismiss(tiggerDelegate:Bool = true,compeletion:(()->Void)? = nil ){
        if tiggerDelegate{Labiba.delegate?.labibaWillClose?()}
        LabibaRestfulBotConnector.shared.close()
        navigationController?.dismiss(animated: true, completion: {
            compeletion?()
            if tiggerDelegate{Labiba.delegate?.labibaDidClose?()}
        })
    }
    
//    static func createConversation(closable: Bool = true, onClose: ConversationCloseHandler? = nil) -> UIViewController
//    { // this is should not be public
//
//        guard self._senderId != nil
//        else
//        {
//            fatalError(SENDER_ERROR)
//        }
//
//        let convVC = ConversationViewController.create()
//        convVC.delegate = Labiba.delegate
//        convVC.isClosable = closable
//        convVC.closeHandler = onClose
//
//        return convVC
//    }

    
  
    
    public static func createVoiceExperienceConversation( ) -> UIViewController
    {
        guard self._senderId != nil
            else
        {
            fatalError(SENDER_ERROR)
        }
       // let VoiceConvVC = VoiceExperienceVC.create()
        let VoiceConvVC = PresentationVC.create()
        VoiceConvVC.delegate = Labiba.delegate
       // VoiceConvVC.closeHandler = onClose
        return VoiceConvVC
    }
    
    public static func createWatchConnectivity() -> UIViewController
    {
        let convVC = WatchConnectivityViewController.create()
        return convVC
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
    @objc optional func labibaDidClose()
}

class LabibaNavigationController:UINavigationController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
        
    }
    override open var shouldAutorotate: Bool {
        return false
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        addTransitionAnimation()
        super.pushViewController(viewController, animated: false)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        addTransitionAnimation()
        return super.popViewController(animated: animated)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        addTransitionAnimation()
        super.dismiss(animated: flag, completion: completion)
    }
    func addTransitionAnimation(){
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromRight
        view.layer.add(transition, forKey: kCATransition)
    }
    
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


 

