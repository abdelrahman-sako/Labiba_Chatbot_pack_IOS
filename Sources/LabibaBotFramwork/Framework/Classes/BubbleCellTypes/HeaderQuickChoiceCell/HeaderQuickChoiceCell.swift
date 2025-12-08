//
//  HeaderQuickChoiceCell.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman Qasem on 9/3/20.
//  Copyright © 2020 Abdul Rahman. All rights reserved.
//

import UIKit

class HeaderQuickChoiceCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var selectItemBtn: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutIfNeeded()
        containerView.layer.cornerRadius = containerView.frame.height/2
    }


}
