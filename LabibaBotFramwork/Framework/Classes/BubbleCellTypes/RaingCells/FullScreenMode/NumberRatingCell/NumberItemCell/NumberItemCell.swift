//
//  NumberItemCell.swift
//  LabibaBotFramwork
//
//  Created by Osama Hasan on 06/04/2025.
//  Copyright © 2025 Abdul Rahman. All rights reserved.
//

import UIKit

class NumberItemCell: UICollectionViewCell {

    @IBOutlet weak var contanierView: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    override var isSelected: Bool {
        didSet {
            contanierView.backgroundColor = isSelected ? .white :  .clear
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contanierView.layer.cornerRadius = contanierView.frame.height/2
        
        contanierView.layer.borderColor = UIColor.black.cgColor
        contanierView.layer.borderWidth = 0.5
    }

}
