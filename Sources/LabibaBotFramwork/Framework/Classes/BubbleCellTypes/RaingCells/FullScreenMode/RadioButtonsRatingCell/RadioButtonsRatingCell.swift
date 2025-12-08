//
//  RadioButtonsRatingCell.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman on 10/8/19.
//  Copyright © 2019 Abdul Rahman. All rights reserved.
//

import UIKit

class RadioButtonsRatingCell: RatingCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var radioButtons: [SSRadioButton]!
   
    var radioButtonController: SSRadioButtonsController?
      var questionModel:RatingQuestionModel?
    override func awakeFromNib() {
        
        super.awakeFromNib()
        radioButtonController = SSRadioButtonsController(buttons: radioButtons.map({$0}) ?? [])
        radioButtonController!.delegate = self
               radioButtonController!.shouldLetDeSelect = true
        radioButtons.forEach { (button) in
            button.titleLabel?.font = applyBotFont(size: 15)
            button.circleRadius = 12
            button.cornerRadius = 12
            button.strokeColor = .gray
            button.circleColor = .green
            button.layoutIfNeeded()
           button.applyReversedSemanticAccordingToBotLang()
        }
        
       // contentView.applySemanticAccordingToBotLang()
    }

   
    
}

extension RadioButtonsRatingCell : SSRadioButtonControllerDelegate {
    func didSelectButton(selectedButton: SSRadioButton?) {
        if selectedButton?.isSelected ?? false {
            questionModel?.option = selectedButton?.tag
        }else{
            questionModel?.option = nil
        }
        
    }
    
    
}
