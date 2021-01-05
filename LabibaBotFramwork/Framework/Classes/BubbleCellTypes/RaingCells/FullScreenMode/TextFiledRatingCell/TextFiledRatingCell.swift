//
//  TextFiledRatingCell.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman Qasem on 6/3/20.
//  Copyright © 2020 Abdul Rahman. All rights reserved.
//

import UIKit

class TextFiledRatingCell: RatingCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var containerView: UIView!
    
    var questionModel:RatingQuestionModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let placeHolder = "Phone Number(optional)".localForChosnLangCodeBB
        let attribbutedStr = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor : Labiba.RatingForm.mobileNumColor,NSAttributedString.Key.font:Labiba.RatingForm.mobileNumFont])
        phoneTextField.attributedPlaceholder = attribbutedStr
        titleLbl.font =  applyBotFont( bold: Labiba.RatingForm.questionsFont.weight == .bold, size: Labiba.RatingForm.questionsFont.size) 
        titleLbl.textColor = Labiba.RatingForm.questionsColor
        phoneTextField.font = Labiba.RatingForm.mobileNumFont
        phoneTextField.textColor = Labiba.RatingForm.mobileNumColor
        containerView.backgroundColor = Labiba.RatingForm.mobileNumContainerColor
        phoneTextField.addTarget(self, action: #selector(textFiledDidChange), for: .editingChanged)
        phoneTextField.textAlignment =  SharedPreference.shared.botLangCode  == .ar ? .right : .left
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    @objc func textFiledDidChange(_ textFiled:UITextField){
        if textFiled.text == "" {
            questionModel?.text = " "
        }else{
           questionModel?.text = textFiled.text
        }
        
    }
    
    
}

