//
//  PrechatFormFieldCell.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman Qasem on 16/09/2021.
//  Copyright © 2021 Abdul Rahman. All rights reserved.
//

import UIKit

class PrechatFormFieldCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tfContainerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        tfContainerView.layer.cornerRadius = 10
        tfContainerView.layer.borderWidth = 1
        tfContainerView.layer.borderColor = UIColor(argb: 0xffD1D2D2).cgColor
        titleLbl.font = applyBotFont(size: 17)
        textField.font = applyBotFont(size: 15)
        contentView.applyHierarchicalSemantics()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
