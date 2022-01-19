//
//  UserInput.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman on 27/12/2021.
//  Copyright © 2021 Abdul Rahman. All rights reserved.
//

import Foundation
import UIKit
class UserInput:UIView {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var textField: UITextField!
    var MaximumCount = 2000
    
    @objc func ChangeKeyboardType(_ sender: Notification)
    {
        let txt = sender.object as? String ?? ""
        textView.isHidden = false
        textView.isUserInteractionEnabled = true
        textView.textContentType = nil
        sendButton.isEnabled = true
        MaximumCount = 2000
        if txt == "N"
        {
            textView.keyboardType = .numberPad
            MaximumCount = 15
            return
        }
        else if txt == "N_CHAR"
        {
            textView.keyboardType = .default
            return
        }
        else if txt == "N_CHAR_AR"
        {
            textView.keyboardType = .default
            return
        }
        else if txt == "CHAR_AR"
        {
            textView.keyboardType = .default
            return
        }
        else if txt == "CHAR"
        {
            textView.keyboardType = .default
            return
//        } else if txt == "CALENDAR" {
//           DatePickerViewController.present(withDelegate: self, mode: .date)
//            return
        }
        else if txt == "user_phone_number"
        {
            textView.keyboardType = .phonePad
            MaximumCount = 15
            return
        }
        else if txt == "user_email"
        {
            textView.keyboardType = .emailAddress
            return
        }
        else if txt == "OTP"
        {
            textView.isHidden = true
            textField.isHidden = false
            textField.keyboardType = .numberPad
            if #available(iOS 12.0, *) {
                textField.textContentType = .oneTimeCode
            }
            return
        }
        else if txt == "NUMBER"
        {
            textView.keyboardType = .numberPad
            return
        }
        else if txt == "Disable"
        {
            textView.isUserInteractionEnabled = false
            sendButton.isEnabled = false
            return
        }
        else
        {
            textView.keyboardType = .default
            return
        }
    }

}
