//
//  RatingStarsRatingCell.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman on 10/7/19.
//  Copyright © 2019 Abdul Rahman. All rights reserved.
//

import UIKit

class RatingStarsRatingCell: RatingCell {
 @IBOutlet var rateingImages: [UIImageView]!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var starsStack: UIStackView!
    
     var questionModel:RatingQuestionModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rateingImages.forEach { (image) in
            image.image = Image(named: "emptyStar")
            image.tintColor = Labiba.RatingForm.emptyStarTintColor
        }
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(swipGesture(_:)))
        starsStack.addGestureRecognizer(gesture)
        titleLbl.font =  applyBotFont( bold: Labiba.RatingForm.questionsFont.weight == .bold, size: Labiba.RatingForm.questionsFont.size) 
        titleLbl.textColor = Labiba.RatingForm.questionsColor
    }

    
    @IBAction func rateingButtons(_ sender: UIButton) {
        setRating(forTag: sender.tag)
       questionModel?.rating = sender.tag + 1
    }
   
    @objc func swipGesture(_ gesture:UIPanGestureRecognizer){
       
        let starwidth = starsStack.frame.width/5
        let location = gesture.location(in: starsStack).x
        let tag = Int((location - starwidth/2)/starwidth)
        // print("tag  ", tag ,"location " , location )
         setRating(forTag: tag)
        if gesture.state == .ended {
            if tag < 0 {
            questionModel?.rating = nil
            }else if tag > 4{
                questionModel?.rating = 5
            }else{
                questionModel?.rating = tag + 1
            }
        }
       
    }
    
    func setRating(forTag tag:Int) {
        
        
        rateingImages.forEach { (image) in
            if image.tag <= tag{
                image.image = Image(named: "fullStar")
                image.tintColor = Labiba.RatingForm.fullStarTintColor
            }else{
                image.image = Image(named: "emptyStar")
                image.tintColor = Labiba.RatingForm.emptyStarTintColor
            }
        }
    }
    
}
