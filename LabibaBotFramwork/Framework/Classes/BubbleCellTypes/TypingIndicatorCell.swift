//
//  TypingIndicatorCell.swift
//  LabibaClient_DL
//
//  Created by AhmeDroid on 9/20/17.
//  Copyright © 2017 Imagine Technologies. All rights reserved.
//

import UIKit
//import NVActivityIndicatorView

class TypingIndicatorCell: EntryViewCell
{

    var loadingIndicator: NVActivityIndicatorView!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        loadingIndicator = NVActivityIndicatorView(frame: CGRect.zero)
        loadingIndicator.type = NVActivityIndicatorType.ballPulse
        loadingIndicator.color = Labiba._TypingIndicatorColor ?? UIColor.gray
        loadingIndicator.backgroundColor = UIColor.white
        loadingIndicator.padding = 7.0

        loadingIndicator.layer.shadowColor = UIColor.black.cgColor
        loadingIndicator.layer.shadowOffset = CGSize(width: 0, height: 1)
        loadingIndicator.layer.shadowRadius = 1.0
        loadingIndicator.layer.shadowOpacity = 0.2
        loadingIndicator.layer.cornerRadius = 10
        loadingIndicator.layer.masksToBounds = false

        self.addSubview(loadingIndicator)
        self.resetAvatar()
         setBackgroundColor()
    }

    override var conversationParty: ConversationParty
    {
        return .bot
    }

    var isShown: Bool = false

    func showLoadingIndicator() -> Void
    {

        if !self.isShown
        {
             let avatarWidth = Labiba._botAvatar == nil ? 0 : AvatarWidth + 5
            let margin = LbLanguage.isArabic ? Labiba._Margin.right : Labiba._Margin.left
           // var px = LbLanguage.isArabic ? self.frame.width - 50 - 5 - AvatarWidth - 5 : 5 + AvatarWidth + 5
            let totalMargin = avatarWidth + ipadMargin + margin
            let px = LbLanguage.isArabic ? screenWidth - (50 + 5  + 5 + totalMargin ) : 5  + 5 + totalMargin
          //  px = Labiba._botAvatar == nil ? 5 : px
            let ipadAddition = ipadFactor*10
            loadingIndicator.frame = CGRect(x: px, y: 10, width: 50 + ipadAddition, height: 38 + ipadAddition)
            loadingIndicator.alpha = 0

            UIView.animate(withDuration: 0.3)
            {
                self.loadingIndicator.alpha = 1
            }

            loadingIndicator.startAnimating()
            self.renderAvatar()
        }

        self.isShown = true
    }

    func hideLoadingIndicator() -> Void
    {

        self.isShown = false
        self.loadingIndicator.stopAnimating()
        self.loadingIndicator.isHidden = true
    }
    
    
    func setBackgroundColor() {
        if let grad = Labiba._botBubbleBackgroundGradient {
            
            let gview = GradientView(frame: loadingIndicator.bounds)
            gview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            gview.setGradient(grad)
            
            loadingIndicator.insertSubview(gview, at: 0)
            
        } else if let bgColor = Labiba._botBubbleBackgroundColor {
            
            loadingIndicator.backgroundColor = bgColor
        }
    }
}
