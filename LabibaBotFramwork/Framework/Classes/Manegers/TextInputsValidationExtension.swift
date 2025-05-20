
//
//  TextInputsValidationExtension.swift
//  LabibaBotFramwork
//
//  Created by Ahmad Sbeih on 24/05/2023.
//

import Foundation
import UIKit

extension Array{
    func validateFields()-> Bool{
        var isVaildTextField = true
        var isVaildTextView = true
        for field in self{
            if field is UITextField{
                let textField = field as! UITextField
                if !textField.validateTextField(){
                    isVaildTextField = false
                }
            }else if field is UITextView{
                let textView = field as! UITextView
                if !textView.validateTextView(){
                    isVaildTextView = false
                }
            }else{
                return false
            }
        }
        return isVaildTextField && isVaildTextView
    }
    
    func updateValidatedFields(){
        for field in self{
            if field is UITextField{
                let textField = field as! UITextField
                if !textField.text.isBlank{
                    textField.validateTextField()
                }
            }else if field is UITextView{
                let textView = field as! UITextView
                if !textView.text.isBlank{
                    textView.validateTextView()
                }
            }
        }
    }
}



extension Sequence {
    func removingDuplicates<T: Hashable>(withSame keyPath: KeyPath<Element, T>) -> [Element] {
        var seen = Set<T>()
        return filter { element in
            guard seen.insert(element[keyPath: keyPath]).inserted else { return false }
            return true
        }
    }
}

extension UITextField {
    
    
    func createMessageLabel(_ messageLabel: String = "This field is required"){
        let label = UILabel()
        label.text = messageLabel
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 10)
        self.addSubview(label)
        label.tag = -1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        label.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 2).isActive = true
        self.layoutIfNeeded()
    }
    
    
    @discardableResult func validateTextField(_ messageLabel: String = "This field is required") -> Bool{
        self.subviews.forEach { subview in
            if subview.tag == -1{
                subview.removeFromSuperview()
            }
        }
        if self.text.isBlank == true{
            createMessageLabel(messageLabel)
            return false
        }
        if self.keyboardType == .emailAddress {
            if !self.text.isValidEmail{
                createMessageLabel("Email address is invalid")
                return false
            }
        }
        if self.keyboardType == .phonePad{
            if !self.text.isValidPhone{
                if !self.text.isBlank{
                    createMessageLabel("Phone Number is invalid")
                }
                return false
            }
        }
        if self.keyboardType == .URL{
            if !self.text.verifyUrl(){
                if !self.text.isBlank{
                    createMessageLabel("Url is invalid")
                }
                return false
            }
        }
        return true
    }
    
}

extension Optional where Wrapped == String {
    
    var isEmptyOrNil: Bool {
        return self?.isEmpty ?? true
    }
    
    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
    
    var isValidName: Bool {
        return NSPredicate(format: "SELF MATCHES %@", "^[\\p{L}\\p{M} ]+$").evaluate(with: self)
    }
    
    func verifyUrl () -> Bool {
        if let self = self {
            if let url = NSURL(string: self) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    var isPasswordValid : Bool  {
        
        return NSPredicate(format: "SELF MATCHES %@","^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$").evaluate(with: self?.trimmingCharacters(in: CharacterSet.whitespaces))
        
    }
    
    var isValidPhone: Bool {
        let phoneNumberRegex = "^[1-9]{1}[0-9].{3,}$"
        return NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex).evaluate(with: self)
    }
    
    var isBlank: Bool {
        if let unwrapped = self {
            return unwrapped.isWhiteSpace
        }
        return true
        
    }
}


extension UITextView{
    func createMessageLabel(_ messageLabel: String = "This field is required"){
        let label = UILabel()
        label.text = messageLabel
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 10)
        self.addSubview(label)
        label.tag = -1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        label.topAnchor.constraint(equalTo: self.bottomAnchor, constant: self.frame.height + 5).isActive = true
        self.layoutIfNeeded()
        self.clipsToBounds = false
    }
    
    func validateTextView(messageLabel: String = "This field is required") -> Bool{
        for subview in self.subviews{
            if subview is UILabel && subview.tag == -1{
                subview.removeFromSuperview()
            }
        }
        if self.text.isBlank == true{
            createMessageLabel(messageLabel)
            return false
        }
        return true
    }
}


extension String {
    var isWhiteSpace: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
