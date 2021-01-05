//
//  StateOnHoldEntryCell.swift
//  ImagineBot
//
//  Created by Suhayb Al-Absi on 10/21/16.
//  Copyright © 2016 Suhayb Al-Absi. All rights reserved.
//

import UIKit
//import NVActivityIndicatorView

class StateOnHoldEntryCell: StateEntryCell, EntryDisplayDelegate, SelectableCardViewDelegate
{

    var buttonsContainer: UIScrollView!

    override func displayEntry(_ entryDisplay: EntryDisplay) -> Void
    {

        super.displayEntry(entryDisplay)

        let dialog = entryDisplay.dialog

        clearSubViews(view: self.buttonsContainer)
        self.loadingIndicator?.removeFromSuperview()

        renderBotText()

        if dialog.media != nil
        {

            renderAsMedia()

        }
        else if let choices = dialog.choices
        {

            renderAsChoicesDialog(choices)

        }
        else if let cards = dialog.cards
        {

            renderAsCardsDialog(cards.items)
            self.renderAvatar(animated: false)
        }
    }

    var botBubbleMaxY: CGFloat = 0

    func renderBotText() -> Void
    {

        if self.currentDialog.hasMessage
        {

            self.bubble.posY = 5.0
            self.addSubview(self.bubble)
            let dateFormatter = DateFormatter()
          //  self.bubble.timeLabel.text = dateFormatter.string(from: self.currentDialog.timestamp)
            //
            self.bubble.currentDialog = self.currentDialog
            //
            self.bubble.doSetMessage = self.currentDialog.message!
            self.botBubbleMaxY = self.bubble.frame.maxY
            self.renderAvatar(animated: false)

        }
        else
        {

            self.botBubbleMaxY = 0
        }
    }

    func renderAsMedia() -> Void
    {

        if let media = self.currentDisplay.dialog.media
        {

            if media.type == .Photo
            {

                self.currentDisplay.delegate = self
                if self.currentDisplay.isActionAttempted == false
                {
                    self.currentDisplay.performConversationMediaAction()
                }

                self.showLoadingIndicator()

            }
            else
            {

                self.renderMediaActionResponse(media)
            }
        }
    }

    func displayActionResponseForDialog(_ dialog: ConversationDialog) -> Void
    {

        print("Data recieved for action: ")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {

            self.hideLoadingIndicator()
            if let media = self.currentDialog?.media
            {

                self.renderMediaActionResponse(media)
            }
        })
    }

    func failLoadingActionResponseForDialog(_ dialog: ConversationDialog, error: Error?)
    {

        DispatchQueue.main.async
        {

            self.hideLoadingIndicator()
            self.currentDisplay.height = self.botBubbleMaxY
            self.currentDisplay.status = .Shown
            self.currentDisplay.reload()

            self.delegate?.actionFailedFor(dialog: self.currentDialog)
        }
    }

    var loadingIndicator: LoadingIndicator!

    func showLoadingIndicator() -> Void
    {

        DispatchQueue.main.async
        {

            let w: CGFloat = 50
            let h: CGFloat = 40

            if self.loadingIndicator == nil
            {
                self.loadingIndicator = LoadingIndicator(size: CGSize(width: w, height: h))
            }

            let ty = self.currentDisplay.height - h

            let px: CGFloat
            if self.currentDialog.party == .bot
            {

                self.loadingIndicator.mode = .typing
                px = LbLanguage.isArabic ? self.frame.width - w - 5 - AvatarWidth - 5 : 5 + AvatarWidth + 5
            }
            else
            {

                self.loadingIndicator.mode = .uploading
                px = LbLanguage.isArabic ? 5 + AvatarWidth + 5 : self.frame.width - w - 5 - AvatarWidth - 5
            }

            var f = self.loadingIndicator.frame
            f.origin = CGPoint(x: px, y: ty)

            self.loadingIndicator.isHidden = false
            self.loadingIndicator.frame = f

            self.addSubview(self.loadingIndicator)

            UIView.animate(withDuration: 0.3)
            {
                self.loadingIndicator.alpha = 1
            }

            self.loadingIndicator.start()
            self.renderAvatar()
        }
    }

    func hideLoadingIndicator() -> Void
    {

        self.loadingIndicator.stop()
        self.loadingIndicator.isHidden = true
    }

    func renderMediaActionResponse(_ media: DialogMedia) -> Void
    {

        self.currentDisplay.height = self.botBubbleMaxY

        DispatchQueue.main.async
        {

            let renderer: ResponseRenderer?
            if self.currentDisplay.actionResponse != nil
            {
                renderer = PhotoReponseRenderer()
            }
            else
            {
                renderer = MediaStreamResponseRenderer()
            }

            renderer?.renderResponse(display: self.currentDisplay, onView: self)
            self.renderAvatar()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4)
        {
            self.currentDisplay.status = .Shown
            self.currentDisplay.reload()
        }
    }

    @discardableResult func ensureButtonsContainer(_ bch: CGFloat, forCards: Bool) -> CGFloat
    {
        let avatarWidth = Labiba._botAvatar == nil ? -5 : AvatarWidth
        let ty = self.botBubbleMaxY + 10
        let dx:CGFloat = 0//(forCards) ? avatarWidth + 10 : 0

        let cf = self.frame
        let bcf = CGRect(x: LbLanguage.isArabic ? 0 : dx, y: ty, width: cf.size.width - dx, height: bch)

        if self.buttonsContainer == nil
        {
            self.buttonsContainer = UIScrollView(frame: bcf)
            self.buttonsContainer.showsHorizontalScrollIndicator = false
            self.buttonsContainer.showsVerticalScrollIndicator = false
            self.addSubview(self.buttonsContainer)

        }
        else
        {

            self.buttonsContainer.frame = bcf
            self.addSubview(self.buttonsContainer)
        }

        self.currentDisplay.height = bcf.maxY
        return bch
    }
    let margin = max(Labiba._Margin.left, Labiba._Margin.right)
    
    @discardableResult func renderAsChoicesDialog(_ choices: [DialogChoice]) -> [ChoiceButton]
    {
        let ipadIncease = ipadFactor*10 //mine
        let bch = ensureButtonsContainer(45 + ipadIncease, forCards: false)
        let (choicesBtns, bcw ,realWidth) = createChoicesButtons(display: self.currentDisplay, choices: choices, maxWidth: self.frame.width , ipadIncease: ipadIncease)
        self.buttonsContainer.contentSize = CGSize(width: bcw, height: bch)

        for choiceBtn in choicesBtns
        {
            self.buttonsContainer.addSubview(choiceBtn)
            choiceBtn.tapEventhandler = self.choiceWasSelected(choice:)
        }
        let totalMargin = margin + ipadMargin
        let w = self.buttonsContainer.frame.width
        let widthWithMargin = screenWidth - 2*totalMargin
        var margin = realWidth >= widthWithMargin ?  (realWidth - widthWithMargin)/2: 0
        if margin > totalMargin {
            margin = totalMargin
        }
        let point = LbLanguage.isArabic ? CGPoint(x: bcw - w + margin, y: 0) : CGPoint(x: -margin, y: 0)
        self.buttonsContainer.setContentOffset(point, animated: false)
        self.buttonsContainer.contentInset = LbLanguage.isArabic ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: margin) : UIEdgeInsets(top: 0, left: margin, bottom: 0, right: 0)

        return choicesBtns
    }

    func renderAsCardsDialog(_ cards: [DialogCard]) -> Void
    {
        let totalMargin = margin + ipadMargin
        let avatarWidth = Labiba._botAvatar == nil ? -5 : AvatarWidth
        let ty = self.botBubbleMaxY + 10
        let dx = avatarWidth + 10

        let cf = self.frame
        let bcf = CGRect(x: LbLanguage.isArabic ? 0 : dx, y:ty, width: cf.size.width - dx, height: self.currentDisplay.height)
        ScrollViewCellView.reuseId = self.currentDisplay.id
        let cell:ScrollViewCellView  = self.dequeueReusableComponent(frame: bcf)
        if !cell.created {
            cell.buttonsContainer = UIScrollView(frame: bcf)
            cell.buttonsContainer.showsHorizontalScrollIndicator = false
            cell.buttonsContainer.showsVerticalScrollIndicator = false

        //
        let (cardsViews, bcw) = createCardsViews(display: self.currentDisplay, cards: cards)
        /////
   
        cell.buttonsContainer.frame.size.height = self.currentDisplay.height
        cell.buttonsContainer.contentSize = CGSize(width: bcw , height: self.currentDisplay.height)

        for cardView in cardsViews
        {
            cell.buttonsContainer.addSubview(cardView)

            cardView.delegate = self
        }

       
            cell.buttonsContainer.frame.origin = CGPoint(x: 0, y: 0)
            cell.addSubview(cell.buttonsContainer)
            let w = cell.buttonsContainer.frame.width
            let point = LbLanguage.isArabic ? CGPoint(x: bcw - w + totalMargin, y: 0) : CGPoint(x: -totalMargin, y: 0)
            cell.buttonsContainer.setContentOffset(point, animated: false)
            cell.buttonsContainer.contentInset = LbLanguage.isArabic ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: totalMargin) : UIEdgeInsets(top: 0, left: totalMargin, bottom: 0, right: 0)
            cell.created = true
            cell.frame.size.height = self.currentDisplay.height
         }
        let w = cell.buttonsContainer.frame.width
        if  cell.buttonsContainer.contentSize.width < w{
            let point = LbLanguage.isArabic ? CGPoint(x: cell.buttonsContainer.contentSize.width - w + totalMargin, y: 0) : CGPoint(x: -totalMargin, y: 0)
            cell.buttonsContainer.setContentOffset(point, animated: false)
            cell.buttonsContainer.contentInset = LbLanguage.isArabic ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: totalMargin) : UIEdgeInsets(top: 0, left: totalMargin, bottom: 0, right: 0)
        }
        
        self.addSubview(cell)
    }

    func choiceWasSelected(choice: DialogChoice) -> Void
    {

        self.currentDisplay.status = .NotShown
        self.delegate?.choiceWasSelectedFor(display: self.currentDisplay, choice: choice)
    }

    func cardView(_ cardView: SelectableCardView, didSelectCardButton cardButton: DialogCardButton, ofCard card: DialogCard)
    {

        self.delegate?.cardButton(cardButton, ofCard: card, wasSelectedForDialog: self.currentDialog)
    }
}
