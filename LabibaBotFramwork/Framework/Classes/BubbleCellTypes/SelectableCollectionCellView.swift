//
//  SelectableCollectionCellView.swift
//  DubaiPoliceBot
//
//  Created by Yehya Titi on 4/23/19.
//  Copyright © 2019 Yehya Titi. All rights reserved.
//

import UIKit
import QuartzCore
//import Alamofire
//import AlamofireImage
//import Kingfisher
protocol SelectableCollectionCellViewDelegate: class
{
    
    func cardCollectionView(_ cardView: SelectableCollectionCellView, didSelectCardButton cardButton: DialogCardButton, ofCard card: DialogCard) -> Void
}

class SelectableCollectionCellView: UIView
{
    
    @IBOutlet var buttons: [UIButton]!
    
    weak var delegate: SelectableCollectionCellViewDelegate?
    
    class func create(frame: CGRect) -> SelectableCollectionCellView
    {
        
        let view = UIView.loadFromNibNamedFromDefaultBundle("SelectableCollectionCellView") as! SelectableCollectionCellView
        view.frame = frame
       
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 1.5
        view.layer.shadowOpacity = 0.15
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = false
        
        return view
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func reassureIndicatorState() -> Void
    {
        
        DispatchQueue.main.async
            {
                self.setNeedsDisplay()
        }
    }
    
    
    func removeImage() -> Void
    {
        self.showImage(nil)
    }
    
    func showImage(_ image: UIImage?)
    {
        
        DispatchQueue.main.async
            {
                self.imageView.image = image
        }
    }
    
    private weak var card: DialogCard?
    private var imageLoadingTask: DataRequest?
    
    var currentButtons: [UIButton]!
    
    func displayCard(_ card: DialogCard) -> Void
    {
        
        self.card = card
        self.titleLabel.text = card.title
        
        var TitleFrame = self.titleLabel.frame
        if let desc = card.subtitle, desc.isEmpty == false
        {
            
            self.titleLabel.numberOfLines = 1
            TitleFrame.size.height = 22;
            
        }
        else
        {
            
            self.titleLabel.numberOfLines = 3
            TitleFrame.size.height = 55;
        }
        
        self.titleLabel.frame = TitleFrame
        //self.buildButtons(card)
        
        self.removeImage()
        
        if let image = card.image
        {
            
            self.showImage(image)
            
        }
        else if let imageUrl = card.imageUrl
        {
            
//            imageView.kf.setImage(with: URL(string: imageUrl),completionHandler: { result in
//                switch result {
//                case .success(let image):
//                    card.image = image.image
//                    self.showImage(image.image)
//                case .failure(let err):
//                    print("Error loading image for place: \(err.localizedDescription)")
//                }
//            })
            imageLoadingTask?.cancel()
            imageLoadingTask = request(imageUrl).responseImage(completionHandler: { (response) in


                if let image = response.result.value
                {

                    card.image = image
                    self.showImage(image)

                }
                else if let err = response.result.error
                {

                    print("Error loading image for place: \(err.localizedDescription)")
                }
            })
        }
    }
    
    var borders = [UIView]()
    
    func buildButtons(_ card: DialogCard) -> Void
    {
        
        self.borders.forEach
            { (v) in
                v.removeFromSuperview()
        }
        
        self.borders.removeAll()
        
        self.currentButtons = Array(self.buttons.prefix(card.buttons.count))
        self.buttons.suffix(self.buttons.count - card.buttons.count).forEach { (btn) in
            btn.removeFromSuperview()
        }
        
        let ty = (self.titleLabel.frame.maxY) + 7.0
        
        for i in 0..<card.buttons.count
        {
            
            let card_btn = card.buttons[i]
            let btn = self.currentButtons[i]
            
            let bf = CGRect(x: 0.0, y: ty + CGFloat(i) * 35, width: self.frame.width, height: 35)
            
            btn.tintColor = Labiba.CarousalCardView.tintColor
            btn.frame = bf
            btn.setTitle(card_btn.title, for: .normal)
            self.addSubview(btn)
            
            let border = UIView(frame: CGRect(x: 2, y: bf.minY, width: bf.width - 4, height: 1))
            border.backgroundColor = #colorLiteral(red: 0.9377940315, green: 0.930705514, blue: 0.9825816319, alpha: 1)
            
            self.borders.append(border)
            self.addSubview(border)
        }
        
        var sf = self.frame
        sf.size.height = ty + CGFloat(self.currentButtons.count) * 35.0 + 2
        self.frame = sf
    }
    
    @IBAction func selectButtonTapped(_ sender: Any)
    {
        
        let btn = sender as! UIButton
        let card_btn = (self.card?.buttons[btn.tag])!
        
        self.delegate?.cardCollectionView(self, didSelectCardButton: card_btn, ofCard: self.card!)
    }
}

