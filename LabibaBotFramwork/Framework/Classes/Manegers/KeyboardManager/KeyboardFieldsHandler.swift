//
//  KeyboardFieldsHandler.swift
//  OnBoarding
//
//  Created by Abdulrahman Qasem on 11/11/20.
//  Copyright © 2020 MacBook Pro. All rights reserved.
//

import Foundation
import UIKit
class KeyboardFieldsHandler{
    
    
    private var fields:Set<UIView> = []
    static let  shared = KeyboardFieldsHandler()
    private init(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func registerFields<T:UIView&UITextInput>(fields:Set<T>)  {
        self.fields = fields
    }
    func insertField<T:UIView&UITextInput>(field:T)  {
        self.fields.insert(field)
    }
    func reset()  {
        self.fields.removeAll()
    }
    
    @objc private func keyboardWillChangeFrame(notification: NSNotification)
    {
        var currentField:UIView?
        fields.forEach { (textfield) in
            if textfield.isFirstResponder {
                currentField = textfield
            }
        }
        guard let userInfo = notification.userInfo , let selectedField = currentField else { return }
        
        
        let currentFieldGlobalFrame =  selectedField.globalFrame
        let currentFieldGlobalFrameY = (currentFieldGlobalFrame?.origin.y ?? 0.0) + (currentFieldGlobalFrame?.height ?? 0)
        
        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let endFrameY = endFrame?.origin.y ?? 0
       
        var duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        if endFrameY <= (currentFieldGlobalFrameY) {
            UIApplication.shared.topMostViewController?.view.frame.origin.y = -(currentFieldGlobalFrameY - endFrameY + 10)
        }else {
            UIApplication.shared.topMostViewController?.view.frame.origin.y = 0
        }
        if duration == 0.0 {
            duration = 0.25
        }
        UIView.animate(
            withDuration: 0.25,
            delay: TimeInterval(0),
            options: animationCurve,
            animations: { UIApplication.shared.topMostViewController?.view.layoutIfNeeded() },
            completion: nil)
    }
}


extension UIView {
    var globalFrame: CGRect? {
        let rootView = UIApplication.shared.keyWindow?.rootViewController?.view
        return self.superview?.convert(self.frame, to: rootView)
    }
}
