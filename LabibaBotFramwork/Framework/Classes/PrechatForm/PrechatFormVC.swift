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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSetup()
        cellRegistration()
    }
    
    func uiSetup()  {
        tableView.delegate = self
        tableView.dataSource = self
        
        startChatBtn.layer.cornerRadius = startChatBtn.frame.height/2
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func cellRegistration()  {
        let nib = UINib(nibName: "PrechatFormFieldCell", bundle: self.nibBundle)
        tableView.register(nib, forCellReuseIdentifier: "PrechatFormFieldCell")
        
        let nib2 = UINib(nibName: "PrechatFormHeaderCell", bundle: self.nibBundle)
        tableView.register(nib2, forCellReuseIdentifier: "PrechatFormHeaderCell")
    }
    
    @IBAction func startChatAction(_ sender: UIButton) {
        var vcs = self.navigationController?.viewControllers ?? []
        if vcs.count  > 1{
            vcs.removeLast()
        }
        vcs.append(ConversationViewController.create())
        self.navigationController?.setViewControllers(vcs, animated: true)
    }
    
}

extension PrechatFormVC:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PrechatFormHeaderCell") as! PrechatFormHeaderCell
            cell.selectionStyle = .none
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrechatFormFieldCell") as! PrechatFormFieldCell
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    
    
    
}

