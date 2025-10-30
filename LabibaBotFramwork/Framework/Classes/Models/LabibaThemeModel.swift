import Foundation

// MARK: - LabibaThemeResponseModel
struct LabibaThemeModel: Codable {
    let theme: Theme?
    let config: Config?
}

// MARK: - Config
struct Config: Codable {
    let urls: Urls?
    let botIDS: BotIDS?
    let startLang: String?
    let textToSpeechVoice: TextToSpeechVoice?
    
    enum CodingKeys: String, CodingKey {
        case urls
        case botIDS = "botIds"
        case startLang, textToSpeechVoice
    }
}

// MARK: - BotIDS
struct BotIDS: Codable {
    let ar, du, en, fr: String?
}

// MARK: - TextToSpeechVoice
struct TextToSpeechVoice: Codable {
    let arabic, english: String?
}

// MARK: - Urls
struct Urls: Codable {
    let basePath: String?
    let loggingURL: String?
    let humanAgentURL, voiceBasePath, mediaUploadURL: String?
    let voiceServicePath, messagingServicePath: String?
    
    enum CodingKeys: String, CodingKey {
        case basePath
        case loggingURL = "loggingUrl"
        case humanAgentURL = "humanAgentUrl"
        case voiceBasePath
        case mediaUploadURL = "mediaUploadUrl"
        case voiceServicePath, messagingServicePath
    }
}

// MARK: - Theme
struct Theme: Codable {
    let fonts: Fonts1?
    let header: Header?
    let userUI: UserUI?
    let botChat: BotChat?
    let settting: Settting?
    let backGroundColor: Back?
    let labibaRatingForm: LabibaRatingForm1?
    
    enum CodingKeys: String, CodingKey {
        case fonts, header, userUI
        case botChat = "BotChat"
        case settting, backGroundColor
        case labibaRatingForm = "LabibaRatingForm1"
    }
}

// MARK: - Back
struct Back: Codable {
    let type, color: String?
    let image: String?
    let gradiant: [String]?
}

// MARK: - BotChat
struct BotChat: Codable {
    let alpha: Int?
    let shadow: Shadow?
    let botName: String?
    let fontsize: Int?
    let textColor, timeImage: String?
    let timestamp: Timestamp?
    let backGround: Back?
    let cornerRadius: Int?
    let typingIndicatorColor: String?
}

// MARK: - Shadow
struct Shadow: Codable {
    let shadowColor: String?
    let shadowOffset: ShadowOffset?
    let shadowRadius, shadowOpacity: Double?
}

// MARK: - ShadowOffset
struct ShadowOffset: Codable {
    let width, height: Int?
}

// MARK: - Timestamp
struct Timestamp: Codable {
    let color, formate: String?
    let fontSize: Int?
}

// MARK: - Fonts1
struct Fonts1: Codable {
    let regAR, regEN, boldAR, boldEN: String?
}

// MARK: - Header
struct Header: Codable {
    let titleLbl: RateLaterButton?
    let headerBean: [HeaderBean]?
    let homeButton, muteButton, settingButton: RateLaterButton?
    let statusbarColor: String?
    let centerImageView: RateLaterButton?
    let headerIconColor: String?
    let headerImageSize: Int?
    let vedioCallButton: RateLaterButton?
    let headerTopMargine: Int?
    let headerBackgroundColor: [String]?
}

// MARK: - RateLaterButton
struct RateLaterButton: Codable {
    let icon: String?
    let alpha: Int?
    let isHidden: Bool?
    let tintColor: String?
    let backgroundColor: String?
}

enum Color1: String, Codable {
    case cdffb7 = "#CDFFB7"
}

// MARK: - HeaderBean
struct HeaderBean: Codable {
    let body: String?
    let image: String?
    let title, language: String?
}

// MARK: - LabibaRatingForm1
struct LabibaRatingForm1: Codable {
    let style: String?
    let titleFont: TitleFont?
    let background: Back?
    let titleColor: String?
    let commentFont: Font1?
    let commentColor: String?
    let submitButton: RateLaterButton?
    let mobileNumFont, questionsFont: Font1?
    let mobileNumColor, questionsColor: String?
    let rateLaterButton: RateLaterButton?
    let fullStarTintColor, emptyStarTintColor, commentContainerColor, mobileNumContainerColor: String?
    let starsContainerBorderColor: String?
    let commentContainerCornerRadius: Int?
}

// MARK: - Font1
struct Font1: Codable {
    let size: Int?
    let weight: String?
}

// MARK: - TitleFont
struct TitleFont: Codable {
    let bold: Bool?
    let size: Int?
}

// MARK: - Settting
struct Settting: Codable {
    let botType: String?
    let isAddHeader, isEnableTTS: Bool?
    let humanAgentType: String?
    let isAutoListining, isFullImageCards, isLoggingEnabled, isAddTimeToBubbles: Bool?
    let isSwitchableInputs, isSuccessLoggingEnabled, isUseBackgroundLocation: Bool?
}

// MARK: - UserUI
struct UserUI: Codable {
    let inputView: InputView?
    let labibaMapView: LabibaMapView1?
    let bottomBarColor: [String]?
    let userChatBubble: UserChatBubble?
    let carousalCardView: CarousalCardView?
    let labibaChoiceView: LabibaChoiceView1?
    let labibaMenuCardView: LabibaMenuCardView1?
    let voiceAssistantView: VoiceAssistantView1?
    let labibaAttachmentTheme: LabibaAttachmentTheme?
    
    enum CodingKeys: String, CodingKey {
        case inputView
        case labibaMapView = "LabibaMapView1"
        case bottomBarColor, userChatBubble
        case carousalCardView = "CarousalCardView"
        case labibaChoiceView = "LabibaChoiceView1"
        case labibaMenuCardView = "LabibaMenuCardView1"
        case voiceAssistantView
        case labibaAttachmentTheme = "LabibaAttachmentTheme"
    }
}

// MARK: - CarousalCardView
struct CarousalCardView: Codable {
    let alpha: Int?
    let border: Border?
    let shadow: Shadow?
    let button1, button2, button3: RateLaterButton?
    let titleFont, buttonFont: Font1?
    let titleColor: String?
    let cornerRadius: Int?
    let subtitleColor: String?
    let bottomGradient: BottomGradient?
    let buttonsSpacing: Int?
    let backgroundColor, buttonTitleColor: String?
    let buttonCornerRadius: Int?
    let backgroundImageStyleEnabled: Bool?
}

// MARK: - Border
struct Border: Codable {
    let color: String?
    let width: Int?
}

// MARK: - BottomGradient
struct BottomGradient: Codable {
    let end, start: End?
    let colors: [String]?
    let locations: [Int]?
    let viewBackgroundColor: String?
}

// MARK: - End
struct End: Codable {
    let x, y: Int?
}

// MARK: - InputView
struct InputView: Codable {
    let hintColor, textColor: String?
    let tintColor: String?
    let sendButton: RateLaterButton?
    let backgroundColor: String?
    let attachmentButton: RateLaterButton?
}

// MARK: - LabibaAttachmentTheme
struct LabibaAttachmentTheme: Codable {
    let card, menu: Card?
}

// MARK: - Card
struct Card: Codable {
    let tint, background: String?
}

// MARK: - LabibaChoiceView1
struct LabibaChoiceView1: Codable {
    let font: Font1?
    let tintColor, borderColor: String?
    let cornerRadius: Int?
    let backgroundColor: String?
}

// MARK: - LabibaMapView1
struct LabibaMapView1: Codable {
    let cornerRadius: Int?
    let defaultLocation: DefaultLocation?
}

// MARK: - DefaultLocation
struct DefaultLocation: Codable {
    let latitude, longitude: Double?
}

// MARK: - LabibaMenuCardView1
struct LabibaMenuCardView1: Codable {
    let alpha, fontSize: Int?
    let textColor, backgroundColor, collectionColor: String?
    let clearNonSelectedItems: Bool?
}

// MARK: - UserChatBubble
struct UserChatBubble: Codable {
    let alpha, fontsize: Int?
    let username, textColor: String?
    let timestamp: Timestamp?
    let background: Back?
    let cornerRadius: Int?
}

// MARK: - VoiceAssistantView1
struct VoiceAssistantView1: Codable {
    let micButton: RateLaterButton?
    let waveColor: String?
    let background: Back?
    let keyboardButton, attachmentButton: RateLaterButton?
}
