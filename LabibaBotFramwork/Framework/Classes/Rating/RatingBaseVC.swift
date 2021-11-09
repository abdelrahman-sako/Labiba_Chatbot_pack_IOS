//
//  RatingBaseVC.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman Qasem on 12/13/20.
//  Copyright © 2020 Abdul Rahman. All rights reserved.
//

import UIKit
protocol SubViewControllerDelegate {
    func subViewDidDisappear()
    func SubViewDidAppear()
}

class RatingBaseVC: UIViewController {

    class func present(fromVC:UIViewController, delegate:SubViewControllerDelegate){}
    
    @IBOutlet weak var ratingTableView: UITableView!
    
    var questions:[RatingQuestionModel] = []
    var botConnector:BotConnector = LabibaRestfulBotConnector.shared
    var delegate:SubViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        IQKeyboardManager.shared.enable =  trueL
//        IQKeyboardManager.shared.enableAutoToolbar = trueL
    }
    
        override func viewDidDisappear(_ animated: Bool) {
            print("viewWillDisappear")
//            IQKeyboardManager.shared.enable =  falseL
//            IQKeyboardManager.shared.enableAutoToolbar = falseL
           delegate?.subViewDidDisappear()
        }
    
    override func viewWillDisappear(_ animated: Bool) {
        //IQKeyboardManager.shared.enable =  false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getQuestions()
        UIApplication.shared.setStatusBarColor(color: .clear)
    }
    
    func getQuestions()  {
        botConnector.getRatingQuestions { [weak self](result) in
            switch result {
            case .success(let model):
                if model.count > 0 {
                    self?.questions = model[0].questions ?? []
                    self?.ratingTableView.reloadData()
                }else{
                    self?.showAlert(result: true, message: "Empty questions array")
                }
            case .failure(let err):
                self?.showAlert(result: true, message: err.localizedDescription)
            }
        }
    }
    
    func showAlert(result:Bool , message:String) {
        let alert = UIAlertController(title: "",
                                      message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK".localForChosnLangCodeBB, style: .default, handler: { _ in
            if result{
                kill(getpid(), SIGKILL)
               //exit(0)
            }
        })
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: {})
    }
    

    
}

extension RatingBaseVC:  KeyboardToolbarDelegate {
    func keyboardToolbar(button: UIBarButtonItem, type: KeyboardToolbarButton, isInputAccessoryViewOfTextField textField: UITextField) {
        textField.endEditing(true)
    }
    
    func keyboardToolbar(button: UIBarButtonItem, type: KeyboardToolbarButton, isInputAccessoryViewOfTextView textView: UITextView) {
        textView.endEditing(true)
    }
    
    
}
