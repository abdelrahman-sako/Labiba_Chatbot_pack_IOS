//
//  WriteCommentRatingCell.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman on 10/7/19.
//  Copyright © 2019 Abdul Rahman. All rights reserved.
//

import UIKit

class WriteCommentRatingCell: RatingCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var placeHolderLabel: UILabel!
    var questionModel:RatingQuestionModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLbl.font =  applyBotFont( bold: Labiba.RatingForm.questionsFont.weight == .bold, size: Labiba.RatingForm.questionsFont.size) 
        titleLbl.textColor =  Labiba.RatingForm.questionsColor
        commentTextView.font = applyBotFont(bold: Labiba.RatingForm.commentFont.weight == .bold, size: Labiba.RatingForm.commentFont.size)
        commentTextView.textColor = Labiba.RatingForm.commentColor
        placeHolderLabel.font = applyBotFont(bold: Labiba.RatingForm.commentFont.weight == .bold, size: Labiba.RatingForm.commentFont.size) 
        placeHolderLabel.textColor = Labiba.RatingForm.commentColor
        commentTextView.delegate = self
        placeHolderLabel.text = "writeComment".localForChosnLangCodeBB
        containerView.backgroundColor = Labiba.RatingForm.commentContainerColor
        containerView.layer.cornerRadius = Labiba.RatingForm.commentContainerCornerRadius
        containerView.clipsToBounds = true
    }
    
    
    
}

extension WriteCommentRatingCell:UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeHolderLabel.text = ""
        questionModel?.text = ""
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        questionModel?.text = textView.text
        if (textView.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) ?? true {
            placeHolderLabel.text = "writeComment".localForChosnLangCodeBB
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            questionModel?.text = " "
        }else {
            questionModel?.text = textView.text
        }
    }
}
