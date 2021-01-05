//
//  SubmitRatingLightCell.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman Qasem on 12/15/20.
//  Copyright © 2020 Abdul Rahman. All rights reserved.
//

import UIKit

class SubmitRatingLightCell: RatingCell {
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var rateLaterButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        submitButton.titleLabel?.textColor = Labiba.RatingForm.buttonTintColor
        submitButton.layer.cornerRadius =  submitButton.frame.height/2 + ipadFactor*12.5
        rateLaterButton.layer.cornerRadius =  rateLaterButton.frame.height/2 + ipadFactor*12.5
       let buttonAttribute = [NSAttributedString.Key.foregroundColor : Labiba.RatingForm.buttonTintColor,NSAttributedString.Key.font : applyBotFont(size: 13)]
        submitButton.setAttributedTitle(NSAttributedString(string: "submit".localForChosnLangCodeBB, attributes: buttonAttribute), for: .normal)
        rateLaterButton.setAttributedTitle(NSAttributedString(string: "rateLater".localForChosnLangCodeBB, attributes: buttonAttribute), for: .normal)
        submitButton.backgroundColor = Labiba.RatingForm.buttonBackgroundColor
        rateLaterButton.backgroundColor = UIColor(argb: 0xffCCCCCC)
    }
}
