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
        submitButton.titleLabel?.textColor = Labiba.RatingForm.submitButton.tint
        submitButton.backgroundColor = Labiba.RatingForm.submitButton.background
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = Labiba.RatingForm.submitButton.tint.cgColor
        submitButton.layer.cornerRadius =  submitButton.frame.height/2 + ipadFactor*12.5
        
        rateLaterButton.titleLabel?.textColor = Labiba.RatingForm.rateLaterButton.tint
        rateLaterButton.backgroundColor = Labiba.RatingForm.rateLaterButton.background
       
        
       let submitButtonAttribute = [NSAttributedString.Key.foregroundColor : Labiba.RatingForm.submitButton.tint,NSAttributedString.Key.font : applyBotFont(size: 18)]
        
        let rateLaterButtonAttribute = [NSAttributedString.Key.foregroundColor : Labiba.RatingForm.rateLaterButton.tint,NSAttributedString.Key.font : applyBotFont(size: 18)]
        
        submitButton.setAttributedTitle(NSAttributedString(string: "submit".localForChosnLangCodeBB, attributes: submitButtonAttribute), for: .normal)
        rateLaterButton.setAttributedTitle(NSAttributedString(string: "rateLater".localForChosnLangCodeBB, attributes: rateLaterButtonAttribute), for: .normal)
        
    }

   
    
}
