//
//  RatingNewVC.swift
//  LabibaBotFramwork
//
//  Created by Mohammad Khalil on 10/04/2025.
//  Copyright © 2025 Abdul Rahman. All rights reserved.
//

import UIKit

class RatingNewVC: RatingBaseVC {

    override class func present(fromVC vc:UIViewController,delegate:SubViewControllerDelegate){
        let ratingVC = Labiba.ratingStoryboard.instantiateViewController(withIdentifier: "RatingNewVC") as! RatingBaseVC
        ratingVC.modalPresentationStyle = .fullScreen
        ratingVC.modalTransitionStyle = .crossDissolve
        ratingVC.delegate = delegate
        Labiba.navigationController?.pushViewController(ratingVC, animated: true)
    }
 
    @IBOutlet weak var RatingsTableView: ContentSizedTableView!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        uiConfiguration()
        cellRegistration()
    }
    
    
    func uiConfiguration()  {
        switch Labiba.RatingForm.background {
        case .solid(color: let color):
            self.view.backgroundColor = color
        case .gradient(gradientSpecs: let grad):
            self.view.applyGradient(colours: grad.colors, locations: nil)
        case .image(image: _):break
        }
    //    ratingTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            //    tapGesture.addTarget(self, action: #selector(didTap(_:)))
    }
    
    func cellRegistration()  {
        let nib = UINib(nibName: "RatingSatrsLightCell", bundle: self.nibBundle)
        ratingTableView.register(nib, forCellReuseIdentifier: "RatingSatrsLightCell")
        let nib2 = UINib(nibName: "WriteCommentRatingCell", bundle: self.nibBundle)
        ratingTableView.register(nib2, forCellReuseIdentifier: "WriteCommentRatingCell")
        let nib3 = UINib(nibName: "RadioButtonsRatingCell", bundle: self.nibBundle)
        ratingTableView.register(nib3, forCellReuseIdentifier: "RadioButtonsRatingCell")
        let nib4 = UINib(nibName: "SubmitRatingLightCell", bundle: self.nibBundle)
        ratingTableView.register(nib4, forCellReuseIdentifier: "SubmitRatingLightCell")
        let nib5 = UINib(nibName: "TextFiledRatingCell", bundle: self.nibBundle)
        ratingTableView.register(nib5, forCellReuseIdentifier: "TextFiledRatingCell")
        let nib6 = UINib(nibName: "NumberRatingCell", bundle: self.nibBundle)
        RatingsTableView.register(nib6, forCellReuseIdentifier: "NumberRatingCell")
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
                case .comment ,.textField, .number:
                    break
                
                }
            }
            let ratingModel = SubmitRatingModel(recepient_id: SharedPreference.shared.currentUserId,
                                                questions: questions.map({$0.submitModel()}),
                                          sender_id: Labiba._senderId)
            CircularGradientLoadingIndicator.show()

            DataSource.shared.submitRating(ratingModel: ratingModel) { result in
                CircularGradientLoadingIndicator.dismiss()

                switch result{
                case .success(let model):
                    if model.response ?? false {
                        self.showAlert(result: true, message: "thanksForYourRating".localForChosnLangCodeBB)
                    }else{
                        self.showAlert(result: false, message: "error-msg".localForChosnLangCodeBB)
                    }
                case .failure(let err):
                    self.showAlert(result: false, message: err.localizedDescription)
                }
            }
//            botConnector.submitRating(ratingModel: ratingModel) { (result) in
//                switch result{
//                case .success(let result):
//                    if result {
//                    self.showAlert(result: result, message: "thanksForYourRating".localForChosnLangCodeBB)
//                    }else{
//                     self.showAlert(result: result, message: "error-msg".localForChosnLangCodeBB)
//                    }
//                case .failure(let err):
//                    self.showAlert(result: false, message: err.localizedDescription)
//                }
//            }
            
            
        }else{
         //   kill(getpid(), SIGKILL)
           //exit(0)
//            Labiba.navigationController?.dismiss(animated: true, completion: {
//                Labiba.delegate?.labibaWillClose?()
//            })
            Labiba.dismiss()
        }

    }
    
    
    
    
}

extension RatingNewVC: UITableViewDelegate , UITableViewDataSource {
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
                KeyboardFieldsHandler.shared.insertField(field: cell.commentTextView)
                cell.commentTextView.addKeyboardToolBar(leftButtons:  [], rightButtons:  [.cancel], toolBarDelegate: self)
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
                KeyboardFieldsHandler.shared.insertField(field: cell.phoneTextField)
                cell.phoneTextField.addKeyboardToolBar(leftButtons:  [], rightButtons:  [.cancel], toolBarDelegate: self)
                cell.titleLbl.text = question.question ?? ""
                cell.questionModel = question
                cell.phoneTextField.keyboardType = .phonePad
                cell.selectionStyle = .none
                return cell
            case .none:
                return UITableViewCell()
                
            case .number:
                let cell = tableView.dequeueReusableCell(withIdentifier: "NumberRatingCell", for: indexPath) as! NumberRatingCell
                cell.onSelected = { index in
                    question.rating = index + 1
                }
                return cell
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
