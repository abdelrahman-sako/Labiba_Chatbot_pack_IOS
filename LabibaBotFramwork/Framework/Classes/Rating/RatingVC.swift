//
//  RatingVC.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman on 10/7/19.
//  Copyright © 2019 Abdul Rahman. All rights reserved.
//

import UIKit

class RatingVC: RatingBaseVC {
    override class func present(fromVC vc:UIViewController,delegate:RatingScreenProtocol){
        let ratingVC = Labiba.ratingStoryboard.instantiateViewController(withIdentifier: "RatingVC") as! RatingBaseVC
        ratingVC.modalPresentationStyle = .fullScreen
        ratingVC.modalTransitionStyle = .crossDissolve
        ratingVC.delegate = delegate
        vc.present(ratingVC, animated: true, completion: nil)
    }
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    //var delegate:RatingScreenProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        uiConfiguration()
        cellRegistration()
    }
    
    func uiConfiguration()  {
        switch Labiba.RatingForm.background {
        case .solid(color: let color):
            self.view.backgroundColor = color
        case .gradient(colors: let colors):
            self.view.applyGradient(colours: colors, locations: nil)
        }
        ratingTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tapGesture.addTarget(self, action: #selector(didTap(_:)))
    }
    
    func cellRegistration()  {
        let nib = UINib(nibName: "RatingStarsRatingCell", bundle: self.nibBundle)
        ratingTableView.register(nib, forCellReuseIdentifier: "RatingStarsRatingCell")
        let nib2 = UINib(nibName: "WriteCommentRatingCell", bundle: self.nibBundle)
        ratingTableView.register(nib2, forCellReuseIdentifier: "WriteCommentRatingCell")
        let nib3 = UINib(nibName: "RadioButtonsRatingCell", bundle: self.nibBundle)
        ratingTableView.register(nib3, forCellReuseIdentifier: "RadioButtonsRatingCell")
        let nib4 = UINib(nibName: "SubmitRatingCell", bundle: self.nibBundle)
        ratingTableView.register(nib4, forCellReuseIdentifier: "SubmitRatingCell")
        let nib5 = UINib(nibName: "TextFiledRatingCell", bundle: self.nibBundle)
        ratingTableView.register(nib5, forCellReuseIdentifier: "TextFiledRatingCell")
    }
    
    @objc func didTap(_ G:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    @objc func submitRate(_ button:UIButton){
        if button.tag == 0 {
          
            for (index , quesion) in questions.enumerated() {
                switch (RatingCellType(rawValue:quesion.type ?? "1") ?? .rating) {
                case .rating:
                    if  quesion.rating == nil{
                        guard let cell = ratingTableView.cellForRow(at: IndexPath(row: index + 1, section: 0)) as? RatingStarsRatingCell else {
                            return
                        }
                        cell.starsStack.shake()
                        return
                    }
                case .options:
                    if  quesion.option == nil{
                        guard let cell = ratingTableView.cellForRow(at: IndexPath(row: index + 1, section: 0)) as? RadioButtonsRatingCell else {
                            return
                        }
                        cell.contentView.shake()
                        return
                    }
                case .comment ,.textField:
                    break
                }
            }
            let ratingModel = SubmitRatingModel(recepient_id: SharedPreference.shared.currentUserId,
                                                questions: questions.map({$0.submitModel()}),
                                          sender_id: Labiba._senderId)
            botConnector.submitRating(ratingModel: ratingModel) { (result) in
                switch result{
                case .success(let result):
                    if result {
                    self.showAlert(result: result, message: "thanksForYourRating".localForChosnLangCodeBB)
                    }else{
                     self.showAlert(result: result, message: "error-msg".localForChosnLangCodeBB)
                    }
                case .failure(let err):
                    self.showAlert(result: false, message: err.localizedDescription)
                   // showToast(message: "failure", inView: self.view)
                }
            }
        }else{
           exit(0)
        }

    }
    
    
  
    
    
}

extension RatingVC: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count > 0 ? questions.count + 2 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let questionsCount:Int = questions.count
        if indexPath.row == 0 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "sharRating".localForChosnLangCodeBB
            cell.textLabel?.textColor = Labiba.RatingForm.titleColor
            cell.textLabel?.font = applyBotFont( bold: true, size: 18)
            cell.backgroundColor = .clear
            cell.textLabel?.textAlignment = .center
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.row <= questionsCount {
            let question = questions[indexPath.row - 1]
            switch  RatingCellType(rawValue: (question.type) ?? "1"){
            case .comment:
                let cell = tableView.dequeueReusableCell(withIdentifier: "WriteCommentRatingCell", for: indexPath) as! WriteCommentRatingCell
                
                cell.titleLbl.text = question.question ?? ""
                cell.questionModel = question
                cell.selectionStyle = .none
                return cell
            case .rating:
                let cell = tableView.dequeueReusableCell(withIdentifier: "RatingStarsRatingCell", for: indexPath) as! RatingStarsRatingCell
                cell.titleLbl.text = question.question ?? ""
                cell.questionModel = question
                cell.selectionStyle = .none
                return cell
            case .options:
                let cell = tableView.dequeueReusableCell(withIdentifier: "RadioButtonsRatingCell", for: indexPath) as! RadioButtonsRatingCell
                
                cell.titleLabel.text = question.question ?? ""
                cell.questionModel = question
                for (index , option ) in question.options?.enumerated() ?? [].enumerated(){
                    cell.radioButtons[index].setTitle(option, for: .normal)
                }
                cell.selectionStyle = .none
                return cell
            case .textField:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TextFiledRatingCell", for: indexPath) as! TextFiledRatingCell
                cell.titleLbl.text = question.question ?? ""
                cell.questionModel = question
                cell.phoneTextField.keyboardType = .phonePad
                cell.selectionStyle = .none
                return cell
            case .none:
                return UITableViewCell()
                
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitRatingCell", for: indexPath) as! SubmitRatingCell
            cell.selectionStyle = .none
            cell.rateLaterButton.addTarget(self, action: #selector(submitRate(_:)), for: .touchUpInside)
            cell.submitButton.addTarget(self, action: #selector(submitRate(_:)), for: .touchUpInside)
            return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    
}
