//
//  PrechatFormVC.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman Qasem on 16/09/2021.
//  Copyright © 2021 Abdul Rahman. All rights reserved.
//

import UIKit

class PrechatFormVC: UIViewController {

    class func present(fromVC vc:UIViewController){
        let prechatVC = Labiba.prechatFormStoryboard.instantiateViewController(withIdentifier: "PrechatFormVC") as! PrechatFormVC
        prechatVC.modalPresentationStyle = .fullScreen
        prechatVC.modalTransitionStyle = .crossDissolve
        vc.present(prechatVC, animated: true, completion: nil)
    }
    
    @IBOutlet weak var startChatBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var prechatFormArray:[PrechatFormModel.Item]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        IQKeyboardManager.shared.enable =  trueL
//        IQKeyboardManager.shared.enableAutoToolbar = trueL
        uiSetup()
        cellRegistration()
        getDate()
    }
   
    override func viewDidDisappear(_ animated: Bool) {
        print("viewWillDisappear")
//        IQKeyboardManager.shared.enable =  falseL
//        IQKeyboardManager.shared.enableAutoToolbar = falseL
    }
    
    func uiSetup()  {
        tableView.delegate = self
        tableView.dataSource = self
        
        startChatBtn.layer.cornerRadius = startChatBtn.frame.height/2
        self.view.backgroundColor = Labiba.PrechatForm.backgroundColor
        startChatBtn.backgroundColor = Labiba.PrechatForm.button.backgroundColor

        startChatBtn.setTitleColor(Labiba.PrechatForm.button.titleColor, for: .normal)
        startChatBtn.setTitle("chatNow".localForChosnLangCodeBB, for: .normal)
        startChatBtn.titleLabel?.font = applyBotFont(size: 16)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func cellRegistration()  {
        let nib = UINib(nibName: "PrechatFormFieldCell", bundle: self.nibBundle)
        tableView.register(nib, forCellReuseIdentifier: "PrechatFormFieldCell")
        
        let nib2 = UINib(nibName: "PrechatFormHeaderCell", bundle: self.nibBundle)
        tableView.register(nib2, forCellReuseIdentifier: "PrechatFormHeaderCell")
    }
    
    func getDate() {
        DataSource.shared.getPrechatForm {[weak self] result in
            switch result {
            case .success(let model):
                if model.count > 0 {
                    self?.prechatFormArray = model[0].Data ?? []
                    self?.tableView.reloadData()
                }else {
                    showErrorMessage(ErrorModel.generalError().message, cancelHandler:  { [weak self] in
                        self?.dismissAction()
                    })
                }
            case .failure(let err):
                showErrorMessage(err.localizedDescription, cancelHandler:  { [weak self] in
                    self?.dismissAction()
                })
            }
        }
//        LabibaRestfulBotConnector.shared.getPrechatForm {[weak self] result in
//            switch result {
//            case .success(let model):
//                self?.prechatFormArray = model
//                self?.tableView.reloadData()
//            case .failure(let err):
//                showErrorMessage(err.localizedDescription) { [weak self] in
//                    self?.dismissAction()
//                }
//            }
//        }
    }
    
    func fieldValidation() -> Bool {
        for item in prechatFormArray ?? [] {
            if !item.isOptional {
                if (item.fieldValue?.isEmpty ?? true) {
                   showErrorMessage("fillFields".localForChosnLangCodeBB)
                    return false
                }
                switch item.getType() {
                case .email:
                    if !(item.fieldValue ?? "").isValidEmail(){
                        showErrorMessage("validEmail".localForChosnLangCodeBB)
                        return false
                    }
                case .phone:
                    if (item.fieldValue ?? "").count < 5{
                        showErrorMessage("validPhone".localForChosnLangCodeBB)
                        return false
                    }
                case .number:
                    break
                case .text:
                    break
                }
            }
        }
        return true
    }
    
    @IBAction func startChatAction(_ sender: UIButton) {
        if fieldValidation() {
            var parameters:[String:String] = [:]
            for item in prechatFormArray ?? [] {
                parameters[item.parameterName ?? ""] = (item.fieldValue ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            }
            Labiba.setUserParams(customParameters: parameters)
//            var vcs = self.navigationController?.viewControllers ?? []
//            if vcs.count  > 1{
//                vcs.removeLast()
//            }
//            vcs.append(ConversationViewController.create())
//            self.navigationController?.setViewControllers(vcs, animated: true)
            Labiba.navigationController?.pushViewController(ConversationViewController.create(), animated: true)
        }
    }
    
    @objc func dismissAction(){
        Labiba.dismiss()
    }
    
}

extension PrechatFormVC:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + (prechatFormArray?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PrechatFormHeaderCell") as! PrechatFormHeaderCell
            cell.closeBtn.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }
        let formIndex = indexPath.row - 1
        let form = prechatFormArray?[formIndex]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrechatFormFieldCell") as! PrechatFormFieldCell
        KeyboardFieldsHandler.shared.insertField(field: cell.textField)
        cell.textField.addKeyboardToolBar(leftButtons:  [], rightButtons:  [.cancel], toolBarDelegate: self)
        cell.prechatModel = form
        cell.updateCell()
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    
    
    
}


extension PrechatFormVC: KeyboardToolbarDelegate {
    func keyboardToolbar(button: UIBarButtonItem, type: KeyboardToolbarButton, isInputAccessoryViewOfTextField textField: UITextField) {
        textField.endEditing(true)
    }
    
    func keyboardToolbar(button: UIBarButtonItem, type: KeyboardToolbarButton, isInputAccessoryViewOfTextView textView: UITextView) {
    }
}
