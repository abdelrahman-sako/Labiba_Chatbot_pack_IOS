//
//  PrechatFormHeaderCell.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman Qasem on 16/09/2021.
//  Copyright © 2021 Abdul Rahman. All rights reserved.
//

import UIKit

class PrechatFormHeaderCell: UITableViewCell {

    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLbl.font = applyBotFont(size: 19)
        titleLbl.textColor = Labiba.PrechatForm.header.titleColor
        titleLbl.text = "PersonalData".localForChosnLangCodeBB
        imageContainer.isHidden = Labiba.PrechatForm.header.image == nil
        imageview.image = Labiba.PrechatForm.header.image
        
        contentView.applyHierarchicalSemantics(flipImage: false)
    }

    
}
