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
    
    var prechatFormArray:[PrechatFormModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.enable =  true
        IQKeyboardManager.shared.enableAutoToolbar = true
        uiSetup()
        cellRegistration()
        getDate()
    }
   
    override func viewDidDisappear(_ animated: Bool) {
        print("viewWillDisappear")
        IQKeyboardManager.shared.enable =  false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    func uiSetup()  {
        tableView.delegate = self
        tableView.dataSource = self
        
        startChatBtn.layer.cornerRadius = startChatBtn.frame.height/2
        self.view.backgroundColor = Labiba.PrechatForm.backgroundColor
        startChatBtn.backgroundColor = Labiba.PrechatForm.button.backgroundColor

        startChatBtn.setTitleColor(Labiba.PrechatForm.button.titleColor, for: .normal)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func cellRegistration()  {
        let nib = UINib(nibName: "PrechatFormFieldCell", bundle: self.nibBundle)
        tableView.register(nib, forCellReuseIdentifier: "PrechatFormFieldCell")
        
        let nib2 = UINib(nibName: "PrechatFormHeaderCell", bundle: self.nibBundle)
        tableView.register(nib2, forCellReuseIdentifier: "PrechatFormHeaderCell")
    }
    
    func getDate() {
        LabibaRestfulBotConnector.shared.getPrechatForm {[weak self] result in
            switch result {
            case .success(let model):
                self?.prechatFormArray = model
                self?.tableView.reloadData()
            case .failure(let err):
                showErrorMessage(err.localizedDescription)
            }
        }
    }
    
    @IBAction func startChatAction(_ sender: UIButton) {
        var vcs = self.navigationController?.viewControllers ?? []
        if vcs.count  > 1{
            vcs.removeLast()
        }
        vcs.append(ConversationViewController.create())
        self.navigationController?.setViewControllers(vcs, animated: true)
    }
    @objc func dismissAction(){
        self.navigationController?.popViewController(animated: true)
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
        cell.prechatModel = form
        cell.updateCell()
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    
    
    
}

