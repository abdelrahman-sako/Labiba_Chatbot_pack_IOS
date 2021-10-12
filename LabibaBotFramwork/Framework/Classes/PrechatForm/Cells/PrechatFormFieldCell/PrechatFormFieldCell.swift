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
    @IBOutlet weak var optionalLbl: UILabel!
    
    weak var prechatModel: PrechatFormModel.Item?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tfContainerView.layer.cornerRadius = 10
        tfContainerView.layer.borderWidth = 1
        tfContainerView.layer.borderColor = Labiba.PrechatForm.field.borderColor.cgColor
        tfContainerView.backgroundColor = Labiba.PrechatForm.field.backgroundColor

        titleLbl.font = applyBotFont(size: 16)
        titleLbl.textColor = Labiba.PrechatForm.field.titleColor
        
        textField.delegate = self
        textField.font = applyBotFont(size: 14)
        textField.textColor = Labiba.PrechatForm.field.textColor
        
        optionalLbl.text = "optional".localForChosnLangCodeBB
        optionalLbl.font = applyBotFont(size: 16)
        contentView.applyHierarchicalSemantics()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCell()  {
        titleLbl.text = prechatModel?.title ?? "Title"
        textField.text = prechatModel?.fieldValue ?? ""
        optionalLbl.isHidden = !(prechatModel?.isOptional ?? false)
        if let type =  prechatModel?.getType()  {
            switch type {
            case .email:
                textField.keyboardType = .emailAddress
            case .phone:
                textField.keyboardType = .phonePad
            case .number:
                textField.keyboardType = .numberPad
            case .text:
                textField.keyboardType = .default
            }
        }
       
    }
    
}

extension PrechatFormFieldCell:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        prechatModel?.fieldValue = textField.text ?? ""
    }
}
