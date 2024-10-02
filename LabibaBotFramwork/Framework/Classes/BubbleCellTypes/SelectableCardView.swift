//
//  CardDynView.swift
//  LabibaClient
//
//  Created by AhmeDroid on 7/5/17.
//  Copyright © 2017 Imagine Technologies. All rights reserved.
//

import UIKit
import QuartzCore
//
//import AlamofireImage
//import  Kingfisher
protocol SelectableCardViewDelegate: class
{

    func cardView(_ cardView: SelectableCardView, didSelectCardButton cardButton: DialogCardButton, ofCard card: DialogCard) -> Void
}

class SelectableCardView: UIView
{

    @IBOutlet var buttonContainerViews: [UIView]!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var borders: [UIView]!
    @IBOutlet weak var buttonBordersLeadingCons: NSLayoutConstraint!
    @IBOutlet weak var buttonBordersTrailingCons: NSLayoutConstraint!
    @IBOutlet weak var totalCardButton: UIButton!
    @IBOutlet weak var imageHightCons: NSLayoutConstraint!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bacgroundImage: UIImageView!
    @IBOutlet weak var bottomGradientView: UIView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    
    weak var delegate: SelectableCardViewDelegate?
    var selectionEnabled:Bool = true
    class func create(frame: CGRect) -> SelectableCardView
    {

        let view = UIView.loadFromNibNamedFromDefaultBundle("SelectableCardView") as! SelectableCardView
        view.frame = frame
        
        view.layer.shadowColor = Labiba.CarousalCardView.shadow.shadowColor
        view.layer.shadowOffset = Labiba.CarousalCardView.shadow.shadowOffset
        view.layer.shadowRadius = Labiba.CarousalCardView.shadow.shadowRadius
        view.layer.shadowOpacity = Labiba.CarousalCardView.shadow.shadowOpacity
        view.layer.cornerRadius = Labiba.CarousalCardView.cornerRadius + 30*ipadFactor
        view.layer.borderWidth = Labiba.CarousalCardView.border.width
        view.layer.borderColor = Labiba.CarousalCardView.border.color.cgColor
        view.backgroundColor =  Labiba.CarousalCardView.backgroundColor
        view.alpha = Labiba.CarousalCardView.alpha
        view.bacgroundImage.layer.cornerRadius = Labiba.CarousalCardView.cornerRadius + 30*ipadFactor
        view.imageView.layer.cornerRadius = Labiba.CarousalCardView.cornerRadius + 30*ipadFactor
        view.imageView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        if let grad = Labiba.CarousalCardView.bottomGradient{
            view.bottomGradientView.applyGradient(colours: grad.colors, locations: nil)
            view.bottomGradientView.layer.cornerRadius = Labiba.CarousalCardView.cornerRadius + 30*ipadFactor
        }
        view.borders.forEach { (view) in
            view.backgroundColor = #colorLiteral(red: 0.9377940315, green: 0.930705514, blue: 0.9825816319, alpha: 1)
        }
        //view.layer.masksToBounds = false // prevent corner radius
        
        return view
    }

  

    func reassureIndicatorState() -> Void
    {

        DispatchQueue.main.async
        {

            if self.imageView.image == nil
            {
                self.showIndicator()
            }
            else
            {
                self.hideIndicator()
            }

            self.setNeedsDisplay()
        }
    }

    func showIndicator() -> Void
    {

        DispatchQueue.main.async
        {

            self.indicator.isHidden = false
            self.indicator.startAnimating()
        }
    }

    func hideIndicator() -> Void
    {

        DispatchQueue.main.async
        {

            self.indicator.isHidden = true
            self.indicator.stopAnimating()
        }
    }

    func removeImage() -> Void
    {
        self.showImage(nil)
    }

    func showImage(_ image: UIImage?)
    {
        var myImage = image
        
        DispatchQueue.main.async
            {
            if Labiba.CarousalCardView.backgroundImageStyleEnabled {
                    self.bacgroundImage.image = image
                }else{
                    self.imageView.image = image
                    self.imageView.backgroundColor = .clear //Labiba.CarousalCardView.backgroundColor
                    self.imageView.contentMode = .scaleAspectFill
                }
                
        }
    }

    private weak var card: DialogCard?
    private var imageLoadingTask: DataRequest?

    var currentButtons: [UIButton]!

    func displayCard(_ card: DialogCard) -> Void
    {
        let imageHight = imageHightCons.constant
        let backgroundStyle = Labiba.CarousalCardView.backgroundImageStyleEnabled
        imageHightCons.constant = backgroundStyle ? 10 : (card.type.imageSize.hight + ipadFactor*70)
        var height:CGFloat = imageHight + 5
        buttonsStackView.spacing = Labiba.CarousalCardView.buttonsSpacing
        if card.buttons.count > 1 {
            height += CGFloat(card.buttons.count - 1)*Labiba.CarousalCardView.buttonsSpacing
        }
        //
        self.card = card
        self.titleLabel.text = card.title
        self.titleLabel.font = applyBotFont(bold: Labiba.CarousalCardView.titleFont.weight == .bold, size: Labiba.CarousalCardView.titleFont.size + ipadFactor*1)

        self.descriptionLabel.attributedText = card.subtitle?.htmlAttributedString(regularFont:applyBotFont(size:  Labiba.CarousalCardView.subtitleFont.size + ipadFactor*1), boldFont: applyBotFont(bold: Labiba.CarousalCardView.subtitleFont.weight == .bold,size: Labiba.CarousalCardView.subtitleFont.size + ipadFactor*1) ,color: Labiba.CarousalCardView.subtitleColor )
        self.descriptionLabel.textAlignment = .center
        
        self.titleLabel.textColor = Labiba.CarousalCardView.titleColor
        //
        
        if !(titleLabel.text?.isEmpty ?? true) {
            let size = titleLabel.text?.size(maxWidth: self.frame.width - 10, font: self.titleLabel.font)
            let titleHight = size?.height ?? 40
            if Labiba.CarousalCardView.backgroundImageStyleEnabled && card.imageUrl != nil{
                height += 40 + ipadFactor*50
            }else{
                height += (titleHight < 40 ? 40 : titleHight) + ipadFactor*70
            }
        }else{
            titleLabel.isHidden = true
        }
        //
        if let desc = card.subtitle, desc.isEmpty == false
        {
            let size = descriptionLabel.attributedText?.size(maxWidth: self.frame.width - 10)
            self.descriptionLabel.isHidden = false
            if Labiba.CarousalCardView.backgroundImageStyleEnabled && card.imageUrl != nil{
                
            }else{
            height += (size?.height ?? 0)
            }
            
        }
        else
        {
            self.descriptionLabel.isHidden = true
            self.titleLabel.numberOfLines = 3
        }
        
        //self.titleLabel.frame = tf
        

        self.removeImage()
        self.hideIndicator()

        if let image = card.image
        {

            self.showImage(image)

        }
        else if let imageUrl = card.imageUrl
        {

            self.showIndicator()
            let currentImageView:UIImageView = Labiba.CarousalCardView.backgroundImageStyleEnabled ? bacgroundImage : imageView
            if let url = URL(string: imageUrl) {
                currentImageView.af_setImage(withURL: url) { (result) in
                    self.hideIndicator()
                    if let image = result.value {
                        card.image = image
                        self.showImage(image)
                    }
                }
            }
//            imageLoadingTask?.cancel()
//            imageLoadingTask = request(imageUrl).responseImage(completionHandler: { (response) in
//
//                self.hideIndicator()
//                if let image = UIImage(data: response.data ?? Data())
//                {
//
//                    card.image = image
//                    self.showImage(image)
//
//                }
//                else if let err = response.result.error
//                {
//
//                    print("Error loading image for place: \(err.localizedDescription)")
//                }
//            })
        }else{
            height -= (imageHight - 15)
            imageHightCons.constant = 0
            bottomGradientView.isHidden = true
        }
        
        self.buildButtons(card , height: &height)
    }

   // var borders = [UIView]()

    func buildButtons(_ card: DialogCard , height:inout CGFloat) -> Void
    {

        buttonContainerViews.forEach { (view) in
           view.isHidden = true
        }
        borders.forEach { (view) in
            view.backgroundColor = Labiba.CarousalCardView.buttonSeparatorLine.color
        }
        buttonBordersLeadingCons.constant = Labiba.CarousalCardView.buttonSeparatorLine.inset
        buttonBordersTrailingCons.constant = Labiba.CarousalCardView.buttonSeparatorLine.inset

        if card.buttons.count == 1 {
            borders[0].isHidden = true
        }else{
            borders[0].isHidden = false
            
        }
        if card.buttons.count == 1 {
            if Labiba.CarousalCardView.HideCardOneButton{
                    height += 15
                    self.frame.size.height = height
                    return
            }

            totalCardButton.isHidden = false
            if card.buttons[0].title == card.title {
                height += 15
                self.frame.size.height = height
                return
            }
        }else{
            totalCardButton.isHidden = true
        }
        
        for i in 0..<card.buttons.count
        {
            
            let buttonHeight:CGFloat = 35
            height += buttonHeight + ipadFactor*25
            buttonContainerViews[i].isHidden = false
            let card_btn = card.buttons[i]
            
            
            buttons[i].tintColor = Labiba.CarousalCardView.buttonTitleColor
            if i == 0{
                let btn1 = Labiba.CarousalCardView.button1
                buttons[i].tintColor = btn1?.titleColor
                buttons[i].backgroundColor = btn1?.backgroundColor
            }
            if i == 1{
                 let btn2 = Labiba.CarousalCardView.button2
                buttons[i].tintColor = btn2?.titleColor
                buttons[i].backgroundColor = btn2?.backgroundColor
            }
            if i == 2{
                let btn3 = Labiba.CarousalCardView.button3
                buttons[i].tintColor = btn3?.titleColor
                buttons[i].backgroundColor = btn3?.backgroundColor
            }
            
            
            //  btn.frame = bf
            if card_btn.title.verifyUrl() {
                buttons[i].setTitle("", for: .normal)
                //buttons[i].kf.setImage(with: URL(string: card_btn.title), for: .normal)
                if let url =  URL(string: card_btn.title) {
                    buttons[i].af_setImage(for: .normal, url: url)
                }
                buttons[i].imageView?.contentMode = .scaleAspectFit
                buttons[i].imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            }else{
                //buttons[i].setAttributedTitle(card_btn.title.underLine(), for: .normal)
                buttons[i].setTitle(card_btn.title, for: .normal)
                buttons[i].titleLabel?.font = applyBotFont( bold: Labiba.CarousalCardView.buttonFont.weight == .bold,size: Labiba.CarousalCardView.buttonFont.size - ipadFactor)
                buttons[i].layer.borderColor = Labiba.CarousalCardView.buttonBorder.color.cgColor
                buttons[i].layer.borderWidth = Labiba.CarousalCardView.buttonBorder.width
                if Labiba.CarousalCardView.buttonCornerRadius >  buttons[i].frame.height {
                    buttons[i].layer.cornerRadius = buttons[i].frame.height/2
                }else{
                buttons[i].layer.cornerRadius = Labiba.CarousalCardView.buttonCornerRadius
                }
            }
            
        }
        self.frame.size.height = height + 10
    }
    
    
    @IBAction func selectButtonTapped(_ sender: Any)
    {
        let btn = sender as! UIButton
        let card_btn = (self.card?.buttons[btn.tag])!
        
        self.delegate?.cardView(self, didSelectCardButton: card_btn, ofCard: self.card!)
        NotificationCenter.default.post(name: Constants.NotificationNames.CardSelectionAbility, object: false)
        // }
    }
}

