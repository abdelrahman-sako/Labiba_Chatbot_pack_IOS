//
//  SubmitRatingCell.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman on 10/8/19.
//  Copyright © 2019 Abdul Rahman. All rights reserved.
//

import UIKit

class SubmitRatingCell: RatingCell {

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var rateLaterButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        submitButton.titleLabel?.textColor = Labiba.RatingForm.buttonTintColor
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = Labiba.RatingForm.buttonTintColor.cgColor
        submitButton.layer.cornerRadius =  submitButton.frame.height/2 + ipadFactor*12.5
       let buttonAttribute = [NSAttributedString.Key.foregroundColor : Labiba.RatingForm.buttonTintColor,NSAttributedString.Key.font : applyBotFont(size: 18)]
        submitButton.setAttributedTitle(NSAttributedString(string: "submit".localForChosnLangCodeBB, attributes: buttonAttribute), for: .normal)
        rateLaterButton.setAttributedTitle(NSAttributedString(string: "rateLater".localForChosnLangCodeBB, attributes: buttonAttribute), for: .normal)
        
    }

   
    
}
