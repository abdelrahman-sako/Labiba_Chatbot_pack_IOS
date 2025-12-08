//
//  CardViewCell.swift
//  LabibaBotClient_Example
//
//  Created by Suhayb Ahmad on 8/13/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class CardViewCell: UICollectionViewCell {
    
    @IBOutlet weak var belowView: UIView!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.titleLabel.textColor = Labiba._UserInputColors.textColor
//        self.cellImageView.tintColor = Labiba._UserInputColors.tintColor
        self.titleLabel.textColor = Labiba.UserInputView.textColor
        self.cellImageView.tintColor = Labiba.UserInputView.tintColor
        
        self.belowView.backgroundColor = UIColor.white
        self.belowView.layer.cornerRadius = 4
        self.belowView.applyDarkShadow(opacity: 0.2, offsetY: 1, radius: 2)
    }
}
