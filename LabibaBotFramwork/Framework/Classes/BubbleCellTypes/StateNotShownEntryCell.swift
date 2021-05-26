//
//  BotTableViewCell.swift
//  ImagineBot
//
//  Created by Suhayb Al-Absi on 10/21/16.
//  Copyright © 2016 Suhayb Al-Absi. All rights reserved.
//

import UIKit

let BlueColor = UIColor(red: 0.08, green: 0.48, blue: 0.9, alpha: 1.0)
let BubbleMargin: CGFloat = 65 + AvatarWidth + 5

class StateNotShownEntryCell: StateEntryCell, SelectableCardViewDelegate, SelectableCollectionCellViewDelegate
{
   
    
    
    var buttonsContainer: UIScrollView!
    
    override func displayEntry(_ entryDisplay: EntryDisplay) -> Void
    {
        //titi render views from response
        super.displayEntry(entryDisplay)
        
        let dialog = entryDisplay.dialog
        
        self.currentDisplay.height = 0
        clearSubViews(view: self.buttonsContainer)
        
        renderTextBox()
        
        if let photo = dialog.media?.image
        {
            
            renderAsPhoto(photo)
            
        }
        else if dialog.media != nil
        {
            
            renderAsAction()
            
        }
        else if let choices = dialog.choices
        {
            let action = DialogChoice(title: "QR code")
           // action.action = .camera
            renderAsChoicesEntry(choices )
            
        }
        else if let cards = dialog.cards
        {
             if(cards.presentation == .menu)
             {
                renderAsCollectionsEntry(cards.items)
            }
            else
             {
            renderAsCardsEntry(cards.items)
            }
            
        }
        else if let map = dialog.map
        {
            
            renderAsMap(map)
            
        }else if let attachment = dialog.attachment {
            renderAsAttachment(attachment)
        }
        else
        {
            
            self.currentDisplay.status = .Shown
            self.delegate?.finishedDisplayForDialog(dialog: dialog)
        }
    }
    
    
    
    func renderAsPhoto(_ photo: UIImage) -> Void
    {
        
        DispatchQueue.main.async
            {
                
                let renderer = PhotoReponseRenderer()
                
                self.currentDisplay.height += 2
                renderer.renderPhoto(forDisplay: self.currentDisplay, onView: self)
                
                self.currentDisplay.status = .Shown
                self.currentDisplay.reload()
        }
    }
    
    func renderAsMap(_ map: DialogMap) -> Void
    {
        
        DispatchQueue.main.async
            {
                
                let renderer = MapReponseRenderer()
                
                self.currentDisplay.height += 2
                renderer.renderMap(display: self.currentDisplay, onView: self)
                
                self.currentDisplay.status = .Shown
                self.currentDisplay.reload()
        }
    }
    func renderAsAttachment(_ item: AttachmentCard) -> Void
    {
        
        DispatchQueue.main.async
            {
                self.currentDisplay.height += 2
                let renderer = AttachmentReponseRenderer()
                renderer.renderAttachment(display: self.currentDisplay, onView: self)
                self.currentDisplay.status = .Shown
                self.currentDisplay.reload()
        }
    }
    
    func renderTextBox() -> Void
    {
        if self.currentDialog.hasMessage
        {
            self.bubble.posY = 5
            self.addSubview(self.bubble)
            let dateFormatter = DateFormatter()
           // self.bubble.timeLabel.text = dateFormatter.string(from: self.currentDialog.timestamp)
            //
            self.bubble.currentDialog = self.currentDialog
            //
            self.bubble.doSetMessage = self.currentDialog.message!
            self.bubble.popUp()
            self.currentDisplay.height = self.bubble.frame.maxY
            self.renderAvatar(animated: false)
        }
    }
    
    func renderAsAction() -> Void
    {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3)
        {
            
            self.currentDisplay.height += 4 + 40 //Indicator height
            self.currentDisplay?.status = .OnHold
            self.currentDisplay?.reload()
        }
    }
    
    func ensureButtonsContainer(_ bch: CGFloat, forCards: Bool)
    {
      //  let avatarWidth = Labiba._botAvatar == nil ? -5 : AvatarWidth
        let avatarWidth = Labiba.BotChatBubble.avatar == nil ? -5 : AvatarWidth
        let ty = self.currentDisplay.height + 10
        let dx:CGFloat = (forCards) ? avatarWidth + 10 : 0
        
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
        
        self.currentDisplay.height = self.buttonsContainer.frame.maxY
    }
    
    let margin = max(Labiba._Margin.left, Labiba._Margin.right)
    
    func renderAsChoicesEntry(_ choices: [DialogChoice]) -> Void
    {
        let ipadIncease = ipadFactor*10 //mine
        ensureButtonsContainer(45 + ipadIncease , forCards: false)
        
        let bch = self.buttonsContainer.frame.height
        let (choicesBtns, bcw , realWidth) = createChoicesButtons(display: self.currentDisplay, choices: choices, maxWidth: self.frame.width , ipadIncease : ipadIncease)
        self.buttonsContainer.contentSize = CGSize(width: bcw, height: bch)
        
        var i: Double = 0
        for choiceBtn in choicesBtns
        {
            self.buttonsContainer.addSubview(choiceBtn)
            choiceBtn.tapEventhandler = self.choiceWasSelected(choice:)
            
            let p = LbLanguage.isArabic ? Double(choicesBtns.count) - i - 1 : i
            
            // Animating
            choiceBtn.alpha = 0
            choiceBtn.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
            UIView.animate(withDuration: 0.2, delay: 0.2 + (p * 0.05),
                           options: .curveEaseOut, animations: {
                            
                            choiceBtn.alpha = 1
                            choiceBtn.transform = CGAffineTransform.identity
            }, completion: { _ in })
            
            i += 1.0
        }
        let totalMargin = margin + ipadMargin
        let w = self.buttonsContainer.frame.width
        let widthWithMargin = screenWidth - 2*totalMargin
        var margin = realWidth >= widthWithMargin ?  (realWidth - widthWithMargin)/2 : 0
        if margin > totalMargin {
            margin = totalMargin
        }
        let point = LbLanguage.isArabic ? CGPoint(x: bcw - w + margin, y: 0) : CGPoint(x: -margin, y: 0)
        self.buttonsContainer.setContentOffset(point, animated: false)
        self.buttonsContainer.contentInset = LbLanguage.isArabic ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: margin) : UIEdgeInsets(top: 0, left: margin, bottom: 0, right: 0)
        
        self.currentDisplay.status = .OnHold
    }
    
    func renderAsCardsEntry(_ cards: [DialogCard]) -> Void
    {
//       // DispatchQueue.main.async{
//            //self.currentDisplay.status = .NotShown
//                    self.currentDisplay.reload()
//            self.currentDisplay.status = .OnHold
//            let renderer = ScrollViewCellView()
//            renderer.renderScrollViewCell(delegate: self, display: self.currentDisplay, onView: self, cards: cards ,firstTime: true,complitionHandler: {
//                //DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
//                    self.currentDisplay.status = .OnHold
//                    self.delegate?.finishedDisplayForDialog(dialog: self.currentDialog)
//              //  })
//
//            })
        let renderer = CardsReponseRenderer()

        self.currentDisplay.height += 2
        renderer.renderCollection(forDisplay: self.currentDisplay, onView: self)

        self.currentDisplay.status = .Shown
        self.currentDisplay.reload()

        self.ensureButtonsContainer(10, forCards: true) // 10 doesn't mean anything

        let (cardsViews, bcw) = createCardsViews(display: self.currentDisplay, cards: cards)

        var bf = self.buttonsContainer.frame

        for card in cardsViews{
            if bf.size.height < card.frame.height{
                bf.size.height = card.frame.height + 15
            }
        }


        self.buttonsContainer.frame = bf
        self.currentDisplay.height = bf.maxY
        self.buttonsContainer.contentSize = CGSize(width: bcw , height: bf.height)

        var i: Double = 0
        for cardView in cardsViews
        {
            self.buttonsContainer.addSubview(cardView)
            cardView.delegate = self

            let p = LbLanguage.isArabic ? Double(cardsViews.count) - i - 1 : i
            let doRenderAvatars = (i == 0)

            // Animating
            if let animations = currentDialog.inAnimations{
                for animation in animations {
                    cardView.layer.add(animation, forKey: "animation\(p)")
                }
            }else{
                cardView.transform = CGAffineTransform(translationX: 0, y: -10)
                UIView.animate(withDuration: 0.35, delay: 0.4 + 0.15 * p,
                               options: .curveEaseOut, animations: {
                                
                                // cardView.alpha = 1
                                cardView.transform = CGAffineTransform.identity
                }, completion: { (finish) in
                    
                    if doRenderAvatars
                    {
                        self.renderAvatar()
                    }
                })
                
                i += 1.0
            }
        }
        let totalMargin = margin + ipadMargin
        let w = self.buttonsContainer.frame.width
        let point = LbLanguage.isArabic ? CGPoint(x: bcw - w + totalMargin, y: 0) : CGPoint(x: -totalMargin, y: 0)
        self.buttonsContainer.setContentOffset(point, animated: false)
        self.buttonsContainer.contentInset = LbLanguage.isArabic ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: totalMargin) : UIEdgeInsets(top: 0, left: totalMargin, bottom: 0, right: 0)
        
        self.currentDisplay.status = .OnHold
        self.delegate?.finishedDisplayForDialog(dialog: self.currentDialog)
        
        
        
           //  }
       
    }
    
    func renderAsCollectionsEntry(_ cards: [DialogCard]) -> Void
    {
        
        let renderer = CardsReponseRenderer()
        
        self.currentDisplay.height += 2
        renderer.renderCollection(forDisplay: self.currentDisplay, onView: self)
        
        self.currentDisplay.status = .Shown
        self.currentDisplay.reload()
        
        ensureButtonsContainer(10, forCards: true) // 10 doesn't mean anything
        
        let (cardsViews, bcw) = createCollectionViews(display: self.currentDisplay, cards: cards)
        
        var bf = self.buttonsContainer.frame
        //bf.size.height = (cardsViews.max(by: {  $0.0.frame.height < $0.1.frame.height })?.frame.height ?? 0) + 15
        bf.size.height = (max(cardsViews[0].frame.height, cardsViews[1].frame.height)) + 15
        
        
        self.buttonsContainer.frame = bf
        self.currentDisplay.height = bf.maxY
        self.buttonsContainer.contentSize = CGSize(width: bcw, height: bf.height)
        
        var i: Double = 0
        for cardView in cardsViews
        {
            self.buttonsContainer.addSubview(cardView)
            cardView.delegate = self
            
            let p = LbLanguage.isArabic ? Double(cardsViews.count) - i - 1 : i
            let doRenderAvatars = (i == 0)
            
            // Animating
            cardView.alpha = 0
            cardView.transform = CGAffineTransform(translationX: 0, y: -10)
            UIView.animate(withDuration: 0.35, delay: 0.4 + 0.15 * p,
                           options: .curveEaseOut, animations: {
                            
                            cardView.alpha = 1
                            cardView.transform = CGAffineTransform.identity
            }, completion: { (finish) in
                
                if doRenderAvatars
                {
                    self.renderAvatar()
                }
            })
            
            i += 1.0
        }
        
        let w = self.buttonsContainer.frame.width
        let point = LbLanguage.isArabic ? CGPoint(x: bcw - w, y: 0) : CGPoint.zero
        self.buttonsContainer.setContentOffset(point, animated: false)
        
        self.currentDisplay.status = .OnHold
        self.delegate?.finishedDisplayForDialog(dialog: self.currentDialog)
    }
    func eraseOutAnimation()  {
//        var i: Double = 0
//        if let outAnimations = currentDialog.outAnimations {
//            for (index,sView)in self.buttonsContainer.subviews.enumerated() {
//                let p = LbLanguage.isArabic ? Double(self.buttonsContainer.subviews.count) - i - 1 : i
//               // for animation in outAnimations {
//                    let cardOutAnimation = CABasicAnimation(keyPath: "position.y")
//                cardOutAnimation.fromValue =  0
//                    cardOutAnimation.toValue =  -(120.0 )
//                cardOutAnimation.duration = 0.2
//                cardOutAnimation.beginTime = 0
//                print("animation \(p) \(index)")
//                    sView.layer.add(cardOutAnimation, forKey: "animation\(index)")
//                    i += 1
//               // }
//                
//            }
//        }
    }
    func cardView(_ cardView: SelectableCardView, didSelectCardButton cardButton: DialogCardButton, ofCard card: DialogCard)
    {
        
       // self.currentDisplay.status = .OnHold  // change to OnHold to keep the carousal menu appear after selection
        eraseOutAnimation() 
        self.delegate?.cardButton(cardButton, ofCard: card, wasSelectedForDialog: self.currentDialog)
    }
    
    func cardCollectionView(_ cardView: SelectableCollectionCellView, didSelectCardButton cardButton: DialogCardButton, ofCard card: DialogCard)
    {
        self.currentDisplay.status = .Shown
        self.delegate?.cardButton(cardButton, ofCard: card, wasSelectedForDialog: self.currentDialog)
    }
    
    func choiceWasSelected(choice: DialogChoice) -> Void
    {
        
        //        self.currentDisplay.status = .Shown
        self.delegate?.choiceWasSelectedFor(display: self.currentDisplay, choice: choice)
    }
}

class ChoiceButton: UIButton
{
    
    var tapEventhandler: (DialogChoice) -> (Void) = { _ in
    }
    private weak var choice: DialogChoice?
    
    init(title: String, choice: DialogChoice)
    {
        self.choice = choice
        super.init(frame: CGRect(x: 0, y: 0, width: 1, height: 35))
        if Labiba.ChoiceView.cornerRadius < self.bounds.height/2{
            self.layer.cornerRadius =  Labiba.ChoiceView.cornerRadius
        }else{
            self.layer.cornerRadius =  self.bounds.height/2
        }
        self.layer.masksToBounds = true
        self.layer.borderColor = Labiba.ChoiceView.borderColor.cgColor
        self.layer.borderWidth = 1.0
        self.titleLabel?.font = applyBotFont(bold: Labiba.ChoiceView.font.weight == .bold, size: Labiba.ChoiceView.font.size)
        
        //let text = Emoticonizer.emoticonizeString(aString: title)
        let text = title
        
        self.setTitle(text, for: .normal)
        self.backgroundColor = Labiba.ChoiceView.backgroundColor //UIColor(white: 0.98, alpha: 1.0)
        
        self.tintColor = Labiba.ChoiceView.tintColor
        self.setTitleColor(Labiba.ChoiceView.tintColor, for: .normal)
        self.setTitleColor(Labiba.ChoiceView.tintColor, for: .highlighted)
        
        self.titleLabel?.sizeToFit()
        self.sizeToFit()
        
        self.addTarget(self, action: #selector(buttonTouchedDown), for: .touchDown)
        self.addTarget(self, action: #selector(buttonTouchedUp), for: .touchUpInside)
        self.addTarget(self, action: #selector(buttonTouchedUp), for: .touchUpOutside)
        self.addTarget(self, action: #selector(buttonTouchedUp), for: .touchCancel)
        
        self.addTarget(self, action: #selector(buttonWasTapped), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    @objc func buttonTouchedDown() -> Void
    {
        
        UIView.animate(withDuration: 0.2)
        {
            self.setTitleColor(UIColor.lightGray, for: .normal)
        }
    }
    
    @objc func buttonTouchedUp() -> Void
    {
        
        UIView.animate(withDuration: 0.2)
        {
            self.setTitleColor(Labiba.ChoiceView.tintColor, for: .normal)
        }
    }
    
    @objc func buttonWasTapped() -> Void
    {
        
        tapEventhandler(self.choice!)
    }
}

@discardableResult func createChoicesButtons(display: EntryDisplay, choices: [DialogChoice], maxWidth: CGFloat , ipadIncease:CGFloat ) -> ([ChoiceButton], CGFloat , CGFloat)
{
    
    var tw: CGFloat = 10
    var choicesButtons = [ChoiceButton]()
    for i in 0..<choices.count
    {
        
        let p = LbLanguage.isArabic ? choices.count - i - 1 : i
        
        let choice = choices[p]
        let text = choice.title
        
        let choiceBtn = ChoiceButton(title: text, choice: choice)
        let csize = choiceBtn.frame.size
        
        choiceBtn.frame = CGRect(x: tw, y: 5.0, width: csize.width + 20, height: 35 + ipadIncease)
        tw += csize.width + 20 + 10
        
        choicesButtons.append(choiceBtn)
    }
    let realContentWidth = tw
    if tw < maxWidth
    {
        
        var cx = (maxWidth - tw + 20) / 2.0
        
        for choiceBtn in choicesButtons
        {
            
            var f = choiceBtn.frame
            f.origin.x = cx
            
            choiceBtn.frame = f
            cx += f.width + 10
        }
        
        tw = maxWidth
    }
    
    return (choicesButtons, tw , realContentWidth)
}

@discardableResult func createCardsViews(display: EntryDisplay, cards: [DialogCard]) -> ([SelectableCardView], CGFloat)
{
    
    var tw: CGFloat = 10
    var cardsViews = [SelectableCardView]()
    
    for (i , card) in cards.enumerated()
    {
        
        let p = LbLanguage.isArabic ? cards.count - i - 1 : i
        let cframe = CGRect(x: tw, y: 5.0, width: card.type.imageSize.width +  ipadFactor*150, height: 245) // 245 doesn't mean anything
        
        let cardView = SelectableCardView.create(frame: cframe)
        cardView.displayCard(cards[p])
        
        tw += cframe.width + 10
        cardsViews.append(cardView)
    }
    
    return (cardsViews, tw)
}

@discardableResult func createCollectionViews(display: EntryDisplay, cards: [DialogCard]) -> ([SelectableCollectionCellView], CGFloat)
{
    
    var tw: CGFloat = 10
    var cardsViews = [SelectableCollectionCellView]()
    
    for i in 0..<cards.count
    {
        
        let p = LbLanguage.isArabic ? cards.count - i - 1 : i
        let cframe = CGRect(x: tw, y: 5.0, width: 180, height: 2000) // 245 doesn't mean anything
        
        let cardView = SelectableCollectionCellView.create(frame: cframe)
        cardView.displayCard(cards[p])
        
        tw += cframe.width + 10
        cardsViews.append(cardView)
    }
    
    return (cardsViews, tw)
}

