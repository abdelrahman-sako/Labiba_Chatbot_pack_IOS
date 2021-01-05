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
    
    @IBOutlet weak var textLabel: UILabel!
    
    var posY:CGFloat = 0
    var maxWidth:CGFloat = 0
    var currentDialog:ConversationDialog?
    var _message:String = ""
    var doSetMessage:String {
        
        set {
            //let text = Emoticonizer.emoticonizeString(aString: newValue.trimmingCharacters(in: .whitespacesAndNewlines))
            if let frame = currentDialog?.frame {
                self.frame = frame
                self.textLabel.attributedText = currentDialog?.attributedMessage
               // let lang = currentDialog?.langCode
                self.textLabel.textAlignment = currentDialog?.alignment ?? .natural// (lang ?? "ar" ) == "ar" ? .right : .left
               // self.textLabel.font = applyBotFont(textLang: Language(rawValue: lang ?? ""),size: 13)
                addLinkGesture()
               
            }else
            {
            checkHyperLink(text:newValue)
            let text = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
//               let text = """
//                        <p style="color:blue"> Saturday <br> اوقات الدوام: 09:00:00 AM - 11:00:00 PM <br><br> Sunday <br> اوقات الدوام: 09:00:00 AM - 11:00:00 PM <br><br> Monday <br> اوقات الدوام: 09:00:00 AM - 11:00:00 PM <br><br> <strong>Tuesday <br> اوقات الدوام: 09:00:00 AM - 11:00:00 PM</strong> <br><br> Wednesday <br> اوقات الدوام: 09:00:00 AM - 11:00:00 PM <br><br> Thursday <br> اوقات الدوام: 09:00:00 AM - 11:00:00 PM <br><br> Friday <br> اوقات الدوام: 09:00:00 AM - 11:00:00 PM <br><br></p>
//                       """
            print("TrackSteps Bubble " + text)
            print("TrackSteps ########################################")
            /////////////////////////////////////html
            
                self._message = text
                
                if(source != .incoming)
                {
                    let lang = text.detectedLangauge()
                    let attribute = [NSAttributedString.Key.font :applyBotFont(textLang: Language(rawValue: lang ?? "") ?? .ar,size: 13),NSAttributedString.Key.foregroundColor:Labiba._userBubbleTextColor]
                    print(Labiba._userBubbleTextColor)
                    let attributedText = NSAttributedString(string: text, attributes: attribute )
                    self.textLabel.attributedText = attributedText
                }
                else
                {
                    let lang = text.detectedLangauge()
                    let boldFont =  applyBotFont(textLang: Language(rawValue: lang ?? "") ?? .ar ,bold:true, size: 13 )
                    let regularFont =  applyBotFont(textLang: Language(rawValue: lang ?? "") ?? .ar , size: 13)
                    self.textLabel.attributedText = text.htmlAttributedString(regularFont:regularFont, boldFont: boldFont ,color: Labiba._botBubbleTextColor ?? UIColor.black)
                }
                
                let lang = textLabel.text?.detectedLangauge()
                if let alignment = Labiba._botBubbleTextAlignment{
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
                self.adjustForContent(text:textLabel.attributedText , lang: Language(rawValue: lang ?? "") ?? .ar)
                
            }
        }
        
        get
        {
            return self._message
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
    
    func adjustForContent(text:NSAttributedString? ,lang:Language) -> Void
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
        let size = text?.size(maxWidth: maxWidth   , font: applyBotFont(textLang:lang, size: 13)) ?? CGSize(width: 50, height: 50)
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
