//
//  MessageView.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman Qasem on 4/27/20.
//  Copyright © 2020 Abdul Rahman. All rights reserved.
//

import UIKit

class MessageView: VoiceExperienceBaseView{
   
    
    enum Role{
        case bot
        case user
    }
    class func create() -> MessageView{
        return Labiba.bundle.loadNibNamed(String(describing: MessageView.self), owner: nil, options: nil)![0] as! MessageView
    }
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var widthConst: NSLayoutConstraint!
    @IBOutlet weak var leadingConst: NSLayoutConstraint!
    
    let messageWidth = UIScreen.main.bounds.width*0.6
    let screenWidth = UIScreen.main.bounds.width
    var didComplete:Bool = false
    let sideMargin:CGFloat = 20
    let fontSize:CGFloat = 17
    var currentRole:Role = .bot
    {
        didSet {
            widthConst.constant = messageWidth
            switch currentRole {
            case .bot:
                leadingConst.constant = sideMargin - messageWidth/2
            case .user:
               leadingConst.constant = (screenWidth - messageWidth ) + messageWidth/2  - sideMargin
            }
        }
    }
    var message:String = ""{
        didSet{
            setMessage()
        }
    }
    
    var newOriginX:CGFloat = 0.0
    override func awakeFromNib() {
        messageLbl.font = applyBotFont( bold: false,size: fontSize)
        messageLbl.textColor = Labiba._botBubbleTextColor
        messageLbl.text = ""
        containerView.applySemanticAccordingToBotLang()
    }
    
    private func setMessage()  {
        var filteredMessage:String = message
        filteredMessage.removeArabicDiacritic()
        if !filteredMessage.isEmpty{
            Labiba.setLastMessageLangCode(filteredMessage)
        }
        let lang = Labiba._LastMessageLangCode
        
        let boldFont =  applyBotFont(textLang: Language(rawValue: lang ) ?? .ar ,bold:true, size: fontSize )
        let regularFont =  applyBotFont(textLang: Language(rawValue: lang ) ?? .ar , size: fontSize)
        self.messageLbl.attributedText = filteredMessage.htmlAttributedString(regularFont:regularFont, boldFont: boldFont ,color: Labiba._botBubbleTextColor)
        setAlignment()
        self.messageLbl.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            UIView.animate(withDuration: 0.3) {
                self.messageLbl.alpha = 1
            }
            self.transitionToCenter()
        }
        
        
    }
    
    func setAlignment() {
        if LbLanguage.isArabic {
            messageLbl.textAlignment = currentRole == .user ? .left : .right
        }else{
            messageLbl.textAlignment = currentRole == .user ? .right : .left
        }
    }
    func setMessage(message:String)  {
        UIView.transition(with: messageLbl, duration: 0.3, options: .transitionCrossDissolve, animations: { [weak self] in
            self?.messageLbl.text = message
        }, completion: nil)
    }
    
    override func startAnimation() {
        let labelSpringAnimationIn = CASpringAnimation(keyPath: "position.y")
        labelSpringAnimationIn.fromValue = 350.0
        // labelSpringAnimationIn.toValue = 0 // comment this will make to value is the view origin
        labelSpringAnimationIn.duration = 10.0
        labelSpringAnimationIn.initialVelocity = 1.0
        labelSpringAnimationIn.damping = 20
        layer.add(labelSpringAnimationIn, forKey: "labelSpringAnimationIn")

        let labelAlphaAnimationIn = CABasicAnimation(keyPath: "opacity")
        labelAlphaAnimationIn.fromValue = 0.3
        labelAlphaAnimationIn.toValue = 1
        labelAlphaAnimationIn.duration = 1.0
        layer.add(labelAlphaAnimationIn, forKey: "labelAlphaAnimationIn")

        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeOut)
        animation.type = CATransitionType.fade
        animation.duration = 0.5
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
        
//        self.transform = CGAffineTransform(translationX: 0, y: 250)
//        let font = self.messageLbl.font
//        self.messageLbl.font = UIFont(name:self.messageLbl.font.fontName , size: 30)
//        UIView.animate(withDuration: 0.5) {
//            self.transform = CGAffineTransform.identity
//            self.messageLbl.font = font
//
//        }
    }
    
    override func removeWithAnimation() {
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: [], animations: {
            self.transform = CGAffineTransform(translationX: 0, y: -50)
            self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    var firstTime = true
    func transitionToCenter()  {
        //  if firstTime {
        switch currentRole {
        case .bot:
            self.messageLbl.layer.anchorPoint = LbLanguage.isArabic ? CGPoint(x: 1, y: 0.5) : CGPoint(x: 0, y: 0.5)
        case .user:
            self.messageLbl.layer.anchorPoint = LbLanguage.isArabic ? CGPoint(x: 0, y: 0.5) : CGPoint(x: 1, y: 0.5)
        }
        //   }
        let topMostView = getTheMostTopView()
        let point = messageLbl.convert(messageLbl.frame.origin, to: topMostView)
//        print("origin ",messageLbl.frame.origin)
//        print("point ",point)
      //  let yTranslation = ((topMostView?.frame.height ?? 400) - 100 )/2  - messageLbl.frame.height/2
        let mh:CGFloat = messageLbl.frame.height
        let vh:CGFloat = topMostView?.frame.height ?? 400
        var yTranslation  = ((vh/2) - mh - point.y) - 20
        yTranslation = yTranslation > 30 ? yTranslation : 30
        self.messageLbl.transform = CGAffineTransform(scaleX: 1.5, y: 1.5).translatedBy(x: 0, y: yTranslation)
        
    }
    func transitionToOrigin(completion:@escaping(Bool)->Void)  {
//        didComplete = true
        UIView.animate(withDuration: 0.55, animations: {
            self.messageLbl.transform = CGAffineTransform.identity
          //  print("origin after animation",self.messageLbl.frame)
        }, completion: { (result) in
            self.didComplete = true
            completion(result)
        })
        
      
        
    }
    
    
}
