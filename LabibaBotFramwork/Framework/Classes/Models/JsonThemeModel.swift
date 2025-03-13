
import Foundation

// MARK: - JSONThemeModel
struct LabibaThemeModel: Codable {
    let config: Config
    let theme: Theme
}

// MARK: - Config
struct Config: Codable {
    let urls: Urls
    let botIDS: BotIDS
    let startLang: String
    let textToSpeechVoice: TextToSpeechVoice
    
    enum CodingKeys: String, CodingKey {
        case urls
        case botIDS = "botIds"
        case startLang, textToSpeechVoice
    }
}

// MARK: - BotIDS
struct BotIDS: Codable {
    let ar, en, fr, du: String
}

// MARK: - TextToSpeechVoice
struct TextToSpeechVoice: Codable {
    let arabic, english: String
}

// MARK: - Urls
struct Urls: Codable {
    let basePath: String
    let messagingServicePath: String
    let voiceBasePath: String
    let voiceServicePath: String
    let humanAgentURL, mediaUploadURL: String
    let loggingURL: String
    
    enum CodingKeys: String, CodingKey {
        case basePath, messagingServicePath, voiceBasePath, voiceServicePath
        case humanAgentURL = "humanAgentUrl"
        case mediaUploadURL = "mediaUploadUrl"
        case loggingURL = "loggingUrl"
    }
}

// MARK: - Theme
struct Theme: Codable {
    let settting: Settting
    let fonts: Fonts
    let backGroundColor: Back
    let header: Header
    let userUI: UserUI
    let botChat: BotChat
    let labibaRatingForm: LabibaRatingForm1
    
    enum CodingKeys: String, CodingKey {
        case settting, fonts, backGroundColor, header, userUI
        case botChat = "BotChat"
        case labibaRatingForm = "LabibaRatingForm"
    }
}

// MARK: - Back
struct Back: Codable {
    let type, color: String
    let image: String
    let gradiant: [String]
}

// MARK: - BotChat
struct BotChat: Codable {
    let typingIndicatorColor: String
    let backGround: Back
    let textColor: String
    let fontsize, alpha, cornerRadius: Int
    let timeImage: String
    let shadow: Shadow
    let timestamp: Timestamp
    let botName: String
}

// MARK: - Shadow
struct Shadow: Codable {
    let shadowColor: String
    let shadowOffset: ShadowOffset
    let shadowRadius, shadowOpacity: Double
}

// MARK: - ShadowOffset
struct ShadowOffset: Codable {
    let width, height: Int
}

// MARK: - Timestamp
struct Timestamp: Codable {
    let fontSize: Int
    let color, formate: String
}

// MARK: - Fonts
struct Fonts: Codable {
    let regAR, boldAR, regEN, boldEN: String
}

// MARK: - Header
struct Header: Codable {
    let headerBean: [HeaderBean]
    let headerTopMargine, headerImageSize: Int
    let statusbarColor: String
    let headerBackgroundColor: [String]
    let headerIconColor: String
    let centerImageView, titleLbl, homeButton, settingButton: RateLaterButton
    let vedioCallButton, muteButton: RateLaterButton
}

// MARK: - RateLaterButton
struct RateLaterButton: Codable {
    let icon, tintColor: String
    let isHidden: Bool
    let backgroundColor: Color
    let alpha: Int
}

enum Color1: String, Codable {
    case cdffb7 = "#CDFFB7"
}

// MARK: - HeaderBean
struct HeaderBean: Codable {
    let language: String
    let image: String
    let title, body: String
}

// MARK: - LabibaRatingForm
struct LabibaRatingForm1: Codable {
    let style: String
    let background: Back
    let titleColor: String
    let titleFont: TitleFont
    let questionsColor: String
    let questionsFont: Font
    let fullStarTintColor, emptyStarTintColor, starsContainerBorderColor, commentContainerColor: String
    let commentContainerCornerRadius: Int
    let commentFont: Font
    let commentColor, mobileNumContainerColor: String
    let mobileNumFont: Font
    let mobileNumColor: String
    let submitButton, rateLaterButton: RateLaterButton
}

// MARK: - Font
struct Font1: Codable {
    let size: Int
    let weight: String
}

// MARK: - TitleFont
struct TitleFont: Codable {
    let bold: Bool
    let size: Int
}

// MARK: - Settting
struct Settting: Codable {
    let humanAgentType, botType: String
    let isLoggingEnabled, isSuccessLoggingEnabled, isSwitchableInputs, isAutoListining: Bool
    let isFullImageCards, isAddHeader, isUseBackgroundLocation, isAddTimeToBubbles: Bool
    let isEnableTTS: Bool
}

// MARK: - UserUI
struct UserUI: Codable {
    let bottomBarColor: [String]
    let userChatBubble: UserChatBubble
    let labibaAttachmentTheme: LabibaAttachmentTheme
    let labibaMapView: LabibaMapView1
    let voiceAssistantView: VoiceAssistantView1
    let inputView: InputView
    let labibaChoiceView: LabibaChoiceView1
    let labibaMenuCardView: LabibaMenuCardView1
    let carousalCardView: CarousalCardView
    
    enum CodingKeys: String, CodingKey {
        case bottomBarColor, userChatBubble
        case labibaAttachmentTheme = "LabibaAttachmentTheme"
        case labibaMapView = "LabibaMapView"
        case voiceAssistantView, inputView
        case labibaChoiceView = "LabibaChoiceView"
        case labibaMenuCardView = "LabibaMenuCardView"
        case carousalCardView = "CarousalCardView"
    }
}

// MARK: - CarousalCardView
struct CarousalCardView: Codable {
    let backgroundColor: String
    let border: Border
    let alpha: Int
    let backgroundImageStyleEnabled: Bool
    let bottomGradient: BottomGradient
    let cornerRadius: Int
    let titleColor, subtitleColor: String
    let buttonsSpacing: Int
    let buttonTitleColor: String
    let titleFont: Font
    let buttonCornerRadius: Int
    let buttonFont: Font
    let shadow: Shadow
    let button1, button2, button3: RateLaterButton
}

// MARK: - Border
struct Border: Codable {
    let width: Int
    let color: String
}

// MARK: - BottomGradient
struct BottomGradient: Codable {
    let colors: [String]
    let locations: [Int]
    let start, end: End
    let viewBackgroundColor: String
}

// MARK: - End
struct End: Codable {
    let x, y: Int
}

// MARK: - InputView
struct InputView: Codable {
    let tintColor: Color
    let hintColor, textColor, backgroundColor: String
    let sendButton, attachmentButton: RateLaterButton
}

// MARK: - LabibaAttachmentTheme
struct LabibaAttachmentTheme: Codable {
    let card, menu: Card
}

// MARK: - Card
struct Card: Codable {
    let tint, background: String
}

// MARK: - LabibaChoiceView
struct LabibaChoiceView1: Codable {
    let backgroundColor, tintColor: String
    let font: Font
    let borderColor: String
    let cornerRadius: Int
}

// MARK: - LabibaMapView
struct LabibaMapView1: Codable {
    let cornerRadius: Int
    let defaultLocation: DefaultLocation
}

// MARK: - DefaultLocation
struct DefaultLocation: Codable {
    let latitude, longitude: Double
}

// MARK: - LabibaMenuCardView
struct LabibaMenuCardView1: Codable {
    let backgroundColor, textColor: String
    let fontSize, alpha: Int
    let collectionColor: String
    let clearNonSelectedItems: Bool
}

// MARK: - UserChatBubble
struct UserChatBubble: Codable {
    let background: Back
    let textColor: String
    let fontsize, alpha, cornerRadius: Int
    let username: String
    let timestamp: Timestamp
}

// MARK: - VoiceAssistantView
struct VoiceAssistantView1: Codable {
    let background: Back
    let micButton, keyboardButton, attachmentButton: RateLaterButton
    let waveColor: String
}
