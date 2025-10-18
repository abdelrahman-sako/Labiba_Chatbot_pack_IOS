//
//  BubbleView.swift
//  LabibaBotClient_Example
//
//  Created by Suhayb Ahmad on 8/15/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import NaturalLanguage
enum BubbleSource
{
    case incoming
    case outgoing
}

public class BubbleView: UIView {
    
    class func createBubble(withWidth width:CGFloat) -> BubbleView { return BubbleView()}
    
    var considersAvatar:Bool = true
    
    @IBOutlet weak var bubbleHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeStackview: UIStackView!
    @IBOutlet weak var timeImageView: UIImageView!
    @IBOutlet weak var textLabel: KGCopyableLabel!
    @IBOutlet weak var bubbleContainer: UIView!
    @IBOutlet weak var timestampLbl: UILabel!
    public override  func accessibilityElementDidBecomeFocused() {
        guard let urlString = currentDialog?.voiceUrl, let url = URL(string: urlString)  else {
            return
        }
        TextToSpeechManeger.Shared.downloadFileFromURL(url:url )
    }
    
    
    var posY:CGFloat = 0
    var maxWidth:CGFloat = 0
    var currentDialog:ConversationDialog?
    var _message:String = ""
    var isFirstTime = true
    var nameCompletion:(()->Void)?
    var doSetMessage:String {
        set {
            getBotName()
            if Labiba.hasBubbleTimestamp {
                if let timestamp = currentDialog?.timestamp {
                    let dateFormatter = DateFormatter()
                    
                    
                    dateFormatter.dateFormat = source == .incoming ? Labiba.BotChatBubble.timestamp.formate : Labiba.UserChatBubble.timestamp.formate
                    getBotName()
                    nameCompletion = { [unowned self] in
                        
                        let botName = currentDialog?.agentName
                    let userName = Labiba.UserChatBubble.userName == nil ? "you".localForChosnLangCodeBB : Labiba.UserChatBubble.userName!
                    
                        DispatchQueue.main.async { [unowned self] in
                            if SharedPreference.shared.botLangCode == .ar{
                                dateFormatter.locale = Locale(identifier: "ar")
                                timestampLbl.text = "\(source == .incoming ? botName ?? "" : userName) - \(dateFormatter.string(from: timestamp))"
                                timestampLbl.textAlignment = source == .incoming  ? .right : .left
                                timeStackview?.semanticContentAttribute = source == .incoming  ? .forceRightToLeft : .forceLeftToRight
                            }else {
                                dateFormatter.locale = Locale(identifier: "en")
                                timestampLbl.text = "\(source == .incoming ? botName ?? "": userName) - \(dateFormatter.string(from: timestamp))"
                                timestampLbl.textAlignment = source == .incoming  ? .left : .right
                                timeStackview?.semanticContentAttribute = source == .incoming  ? .forceLeftToRight : .forceRightToLeft
                            }
                        }
                    }

                    
                    timestampLbl.isHidden  = false
                    //                    if botName == "bot".localForChosnLangCodeBB {
                    timeImageView?.isHidden = false
                    //                    }
                    timeStackview?.isHidden = false
                    
                }else {
                    timestampLbl.isHidden  = true
                    timeImageView?.isHidden = true
                    timeStackview?.isHidden = true
                    
                }
            }else{
                timestampLbl.isHidden  = true
                timeImageView?.isHidden = true
                timeStackview?.isHidden = true
                
                
            }
            if let frame = currentDialog?.frame {
                self.frame = frame
                self.textLabel.attributedText = currentDialog?.attributedMessage
                self.textLabel.textAlignment = currentDialog?.alignment ?? .natural// (lang ?? "ar" ) == "ar" ? .right : .left
                self.isAccessibilityElement = true
                self.accessibilityLabel = "رسالة منك \(currentDialog?.attributedMessage?.string) "
                addLinkGesture()
                
            }else
            {
                checkHyperLink(text:newValue)
                var text = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
                print("TrackSteps Bubble " + text)
                print("TrackSteps ########################################")
                /////////////////////////////////////html
                
                self._message = text
                self.isAccessibilityElement = true
                self.accessibilityLabel = "رسالة منك \(_message) "
                var fontSize:CGFloat = 13
                if(source != .incoming)
                {
                    fontSize = Labiba.UserChatBubble.fontsize
                    let lang = text.detectedLangauge()
                    let attribute = [NSAttributedString.Key.font :applyBotFont(textLang: LabibaLanguage(rawValue: lang ?? "") ?? .ar,size: fontSize),NSAttributedString.Key.foregroundColor:Labiba.UserChatBubble.textColor]
                    let attributedText = NSAttributedString(string: text, attributes: attribute )
                    self.textLabel.attributedText = attributedText
                }
                else
                {
                    var formattedLinestext = text.replacingOccurrences(of: "\n", with: "<br>", options: .literal, range: nil)
                    fontSize = Labiba.BotChatBubble.fontsize
                    let lang = formattedLinestext.detectedLangauge()
                    if lang == "ar" {formattedLinestext.addArabicAlignment()}
                    let boldFont =  applyBotFont(textLang: LabibaLanguage(rawValue: lang ?? "") ?? .ar ,bold:true, size: fontSize )
                    let regularFont =  applyBotFont(textLang: LabibaLanguage(rawValue: lang ?? "") ?? .ar , size: fontSize)
                    self.textLabel.attributedText = formattedLinestext.htmlAttributedString(regularFont:regularFont, boldFont: boldFont ,color: Labiba.BotChatBubble.textColor)
                }
                
                let lang = textLabel.text?.detectedLangauge()
                if let alignment = Labiba.BotChatBubble.textAlignment{
                    self.textLabel.textAlignment = alignment
                    if  alignment == .justified {
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.alignment = .justified
                        paragraphStyle.baseWritingDirection = (lang ?? "ar" ) == "ar" ? .rightToLeft :.leftToRight
                        paragraphStyle.lineBreakMode = .byWordWrapping
                        let text: NSMutableAttributedString = NSMutableAttributedString(attributedString: self.textLabel.attributedText!)
                        text.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, text.length))
                        self.textLabel.attributedText = text
                        
                    }
                }else{
                    self.textLabel.textAlignment = (lang ?? "ar" ) == "ar" ? .right : .left
                }
                
                currentDialog?.alignment = textLabel.textAlignment
                currentDialog?.attributedMessage = textLabel.attributedText
                currentDialog?.message = textLabel.text
                currentDialog?.langCode = lang
                self.adjustForContent(text:textLabel.attributedText , lang: LabibaLanguage(rawValue: lang ?? "") ?? .ar, fontSize: fontSize)
                
            }
            
            
        }
        
        get
        {
            return self._message
        }
    }
    
    func getBotName(){
        DispatchQueue.main.async{ [unowned self] in
            if source == .incoming{
                if currentDialog?.isFromAgent ?? false{
                    if currentDialog?.senderName == nil{
                        if Labiba.currentAgentName == nil{
                            DispatchQueue.global(qos: .background).async {
                                DataSource.shared.getAgentName { [unowned self] result in
                                    switch result{
                                    case .success(let data):
                                        Labiba.currentAgentName = data.name
                                        currentDialog?.agentName = data.name
                                        nameCompletion?()
                                    case .failure(let error):
                                        print(error)
                                        nameCompletion?()
                                    }
                                }
                            }
                        }else{
                            currentDialog?.agentName =  Labiba.currentAgentName
                            nameCompletion?()
                        }
                    }else{
                        currentDialog?.agentName = currentDialog?.senderName
                        nameCompletion?()
                    }
                }else{
                    currentDialog?.agentName =  "bot".localForChosnLangCodeBB
                    nameCompletion?()
                }
            }else{
                currentDialog?.agentName =  "you".localForChosnLangCodeBB
                nameCompletion?()
            }
        }
    }
    
    func checkHyperLink(text:String)  {
        guard let range = text.detectedHyperLinkRange() , let url = URL(string: String(text[range])) else {
            return
        }
        currentDialog?.link = url
        addLinkGesture()
        
    }
    func addLinkGesture()   {
        guard let _ = currentDialog?.link else {
            return
        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(bubbleDidTap))
        gesture.numberOfTapsRequired = 1
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)
    }
    
    @objc func bubbleDidTap(_ gesture:UITapGestureRecognizer){
        guard let link = currentDialog?.link else {
            return
        }
        if UIApplication.shared.canOpenURL(link)
        {
            UIApplication.shared.open(link, options: [:], completionHandler: nil)
        }
    }
    
    var source:BubbleSource = .incoming
    
    func adjustForContent(text:NSAttributedString? ,lang:LabibaLanguage,fontSize:CGFloat) -> Void
    {
        let margin = self.source == .incoming ? Labiba._Margin.left:Labiba._Margin.right
        var _bubbleMargin = self.considersAvatar ? BubbleMargin : BubbleMargin - AvatarWidth
        _bubbleMargin += margin
        
        let TextXPosition = self.textLabel.frame.origin.x + 1.0
        let TextPadding = CGFloat(TextXPosition * 2.0) // Text padding
        
        let BubbleXPosition:CGFloat
        let avatarWidth = self.considersAvatar ? AvatarWidth : 0.0
        let avatarMargin:CGFloat = self.considersAvatar ? 5 : 0.0
        
        let totalMargin = avatarMargin + avatarWidth + ipadMargin + margin
        
        
        let maxWidth =  self.maxWidth - _bubbleMargin - TextPadding  - ipadFactor*(ipadMargin + 70)
        let size = text?.size(maxWidth: maxWidth   , font: applyBotFont(textLang:lang, size: fontSize)) ?? CGSize(width: 50, height: 50)
        var height = size.height
        
        height += (20 + ipadFactor*6)
        let width = size.width < 55.0 ? 55.0 : size.width
        
        if self.source == .incoming
        {
            BubbleXPosition = LbLanguage.isArabic ? screenWidth - (width + 20 + 5 + totalMargin ) : 5 + totalMargin
        }
        else
        {
            let screenWidth = UIScreen.main.bounds.width
            BubbleXPosition = LbLanguage.isArabic ? 5 + totalMargin : screenWidth - (width + 20 + 5 + totalMargin )
        }
        //
        height  = height < 44 ? 44 : height
        height = (currentDialog?.timestamp != nil && Labiba.hasBubbleTimestamp ) ? height + 20 : height
        self.frame = CGRect(x: BubbleXPosition, y: self.posY, width: width + 20 , height: height )
        currentDialog?.frame = self.frame
        //self.frame = CGRect(x: BubbleXPosition, y: self.posY, width: BubbleWidth, height: height )
        
    }
    
    func popUp() -> Void
    {
        // self.alpha = 0
        self.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        UIView.animate(withDuration: 0.2)
        {
            //self.alpha = 1
            self.transform = CGAffineTransform.identity
        }
    }
    
    
    
    
    
    
}



class KGCopyableLabel: UILabel {
    //    override init(frame: CGRect) {
    //           super.init(frame: frame)
    //           self.sharedInit()
    //       }
    //
    //       required init?(coder aDecoder: NSCoder) {
    //           super.init(coder: aDecoder)
    //           self.sharedInit()
    //       }
    //
    //       func sharedInit() {
    //           self.isUserInteractionEnabled = true
    //           let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self.showMenu))
    //           self.addGestureRecognizer(gesture)
    //       }
    //
    //       @objc func showMenu(_ recognizer: UILongPressGestureRecognizer) {
    //           self.becomeFirstResponder()
    //
    //           let menu = UIMenuController.shared
    //
    //           let locationOfTouchInLabel = recognizer.location(in: self)
    //
    //           if !menu.isMenuVisible {
    //               var rect = bounds
    //               rect.origin = locationOfTouchInLabel
    //               rect.size = CGSize(width: 1, height: 1)
    //
    //            if #available(iOS 13.0, *) {
    //                menu.showMenu(from: self, rect: rect)
    //            } else {
    //                // Fallback on earlier versions
    //            }
    //           }
    //       }
    //
    //       override func copy(_ sender: Any?) {
    //           let board = UIPasteboard.general
    //
    //           board.string = text
    //
    //           let menu = UIMenuController.shared
    //
    //           menu.setMenuVisible(false, animated: true)
    //       }
    //
    //       override var canBecomeFirstResponder: Bool {
    //           return true
    //       }
    //
    //       override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    //           return action == #selector(UIResponderStandardEditActions.copy)
    //       }
    override public var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showCopyMenu(sender:)))
        gesture.numberOfTapsRequired = 2
        
        addGestureRecognizer(gesture)
    }
    
    override func copy(_ sender: Any?) {
        UIPasteboard.general.string = text
        if #available(iOS 13.0, *) {
            UIMenuController.shared.hideMenu()
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func showCopyMenu(sender: Any?) {
        becomeFirstResponder()
        let menu = UIMenuController.shared
        if !menu.isMenuVisible {
            if #available(iOS 13.0, *) {
                menu.showMenu(from: self, rect: bounds)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return (action == #selector(copy(_:)))
    }
}
