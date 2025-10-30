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
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cancelButton: CustomButton!
    @IBOutlet weak var sendButton: CustomButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: -LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
        setButtonThemeColor(LabibaThemes.optionMenuThemeColor)
setupViews()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: -IBActions
    @IBAction func sendButtonTapped(_ sender: Any) {
        validateData() ? sendTranscript(name: nameTextField.text!, email: emailTextField.text!, sendTranscriptCompletion: {}) : nil
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    //MARK: -Methods
    func setupViews(){
        titleLabel.text = "Send a transcript of this conversation".localForChosnLangCodeBB

        nameLabel.text = "Name".localForChosnLangCodeBB
        emailLabel.text = "Email".localForChosnLangCodeBB
        sendButton.setTitle("Send".localForChosnLangCodeBB, for: .normal)
        cancelButton.setTitle("Cancel".localForChosnLangCodeBB, for: .normal)
        
        nameLabel.textAlignment = Labiba.botLang == .ar ? .right : .left
        emailLabel.textAlignment = Labiba.botLang == .ar ? .right : .left
    }
    func validateData() -> Bool{
        return [emailTextField,nameTextField].validateFields()
    }
    
    func sendTranscript(name:String,email:String, sendTranscriptCompletion:@escaping ()->Void){
        if let _ = sendButton{
            sendButton.isUserInteractionEnabled = false
        }
        DataSource.shared.sendTranscript(name: name, email: email) { [weak self] result in
            sendTranscriptCompletion()
            if let _ = self?.sendButton{
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
