//
//  EntryViewCell.swift
//  LabibaBotClient_Example
//
//  Created by Suhayb Ahmad on 8/15/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

let AvatarWidth: CGFloat = 36

class EntryViewCell: UITableViewCell
{

    private var _components = [String: ReusableComponent]()

    func dequeueReusableComponent<T: UIView & ReusableComponent>(frame: CGRect) -> T
    {

        if let view = _components[T.reuseId] as? T
        {

            view.frame = frame
            return view

        }
        else
        {

            let view: T = T.create(frame: frame)
            self._components[T.reuseId] = view
            return view
        }
    }

    weak var currentDisplay: EntryDisplay!

    var avatar = UIImageView()

    override func awakeFromNib()
    {
        super.awakeFromNib()

        self.avatar.frame = CGRect(x: 0, y: 0, width: AvatarWidth, height: AvatarWidth)
        self.avatar.layer.cornerRadius = AvatarWidth / 2.0
        self.avatar.layer.masksToBounds = true
    }

    var conversationParty: ConversationParty
    {
        return .bot
    }

    func calculateContentHeight() -> CGFloat
    {

        return self.subviews.reduce(0.0)
        { (res, view) -> CGFloat in
            max(res, view.frame.maxY)
        }
    }

    func resetAvatar() -> Void
    {

        var bf = self.avatar.frame
        bf.origin.y = 0

      //  if let img = self.conversationParty == .user ? Labiba._userAvatar : Labiba._botAvatar
        if let img = self.conversationParty == .user ? Labiba.UserChatBubble.avatar : Labiba.BotChatBubble.avatar
        {
            self.avatar.frame = bf
            self.avatar.image = img
            self.avatar.isHidden = false
        }
        else
        {
            self.avatar.isHidden = true
        }
    }

    func displayEntry(_ entryDisplay: EntryDisplay) -> Void
    {

        self.resetAvatar()
        self.currentDisplay = entryDisplay
        clearSubViews(view: self)
    }
    
    func clearSubViews(view:UIView?) {
        
        if let cView = view {
            for sView in cView.subviews {
                sView.removeFromSuperview()
            }
        }
    }

    func renderAvatar(animated: Bool = true) -> Void
    {

        guard self.avatar.isHidden == false
        else
        {
            return
        }

        self.avatar.layer.removeAllAnimations()
        self.addSubview(self.avatar)

        var f = self.avatar.frame
        if self.conversationParty == .bot
        {
            f.origin.x = LbLanguage.isArabic ? self.frame.maxX - f.width - 5 : 5
        }
        else
        {
            f.origin.x = LbLanguage.isArabic ? 5 : self.frame.maxX - f.width - 5
        }

        self.avatar.frame = f
        f.origin.y = self.calculateContentHeight() - f.height - 5

        if animated
        {

            self.avatar.alpha = 0
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {

                self.avatar.frame = f
                self.avatar.alpha = 1

            }, completion: { _ in })

        }
        else
        {

            self.avatar.alpha = 1
            self.avatar.frame = f
        }
    }
}
