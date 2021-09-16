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
    @IBOutlet weak var titleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLbl.font = applyBotFont(size: 22)
        
    }

    
}
