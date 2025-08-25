//
//  LoginPopupVC.swift
//  LabibaBotFramwork
//
//  Created by Ahmad Sbeih on 19/05/2025.
//  Copyright © 2025 Abdul Rahman. All rights reserved.
//

import UIKit

class TranscriptVC: UIViewController {
    
    //MARK: -IBOutlets
    @IBOutlet weak var cancelButton: CustomButton!
    @IBOutlet weak var sendButton: CustomButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    //MARK: -LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
        setButtonThemeColor(LabibaThemes.optionMenuThemeColor)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
            case .success( _):
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
    
    func setupKeyboard(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardFrame.height / 2 // adjust as needed
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
}
