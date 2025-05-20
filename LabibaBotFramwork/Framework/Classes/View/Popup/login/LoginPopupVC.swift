//
//  LoginPopupVC.swift
//  LabibaBotFramwork
//
//  Created by Ahmad Sbeih on 19/05/2025.
//  Copyright © 2025 Abdul Rahman. All rights reserved.
//

import UIKit

class LoginPopupVC: UIViewController {
    
    //MARK: -IBOutlets
    @IBOutlet weak var cancelButton: CustomButton!
    @IBOutlet weak var sendButton: CustomButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    //MARK: -LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonThemeColor(LabibaThemes.optionMenuThemeColor)
    }
    
    //MARK: -IBActions
    @IBAction func sendButtonTapped(_ sender: Any) {
        validateData() ? send() : nil
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    //MARK: -Methods
    func validateData() -> Bool{
        return [emailTextField,nameTextField].validateFields()
    }
    
    func send(){
        sendButton.isUserInteractionEnabled = false
        DataSource.shared.sendTranscript(name: nameTextField.text!, email: emailTextField.text!) { [weak self] result in
            self?.sendButton.isUserInteractionEnabled = true
            switch result{
            case .success(let data):
                self?.dismiss(animated: true)
            case .failure(let error):
                print(error)
                self?.dismiss(animated: true)
            }
        }
        
    }
    
    func setButtonThemeColor(_ color:UIColor = .purple){
        sendButton.backgroundColor = color
        cancelButton.titleLabel?.tintColor = color
        cancelButton.tintColor = color
        cancelButton.borderColor = color
    }
}
