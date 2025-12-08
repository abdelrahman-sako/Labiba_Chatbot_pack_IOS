//
//  KeyboardToolbar.swift
//  OnBoarding
//
//  Created by Abdulrahman Qasem on 11/11/20.
//  Copyright © 2020 MacBook Pro. All rights reserved.
//
import UIKit
protocol KeyboardToolbarDelegate: class {
    func keyboardToolbar(button: UIBarButtonItem, type: KeyboardToolbarButton, isInputAccessoryViewOfTextField textField: UITextField)
    func keyboardToolbar(button: UIBarButtonItem, type: KeyboardToolbarButton, isInputAccessoryViewOfTextView textView: UITextView)
}
enum KeyboardToolbarButton: Int {

    case done = 0
    case cancel
    case back, backDisabled
    case forward, forwardDisabled

    func createButton(target: Any?, action: Selector?) -> UIBarButtonItem {
        var button: UIBarButtonItem!
        switch self {
        case .back:
            //button = .init(title: "back", style: .plain, target: target, action: action)
            button = .init(image: Image(named: "up-arrow"), style: .plain, target: target, action: action)
        case .backDisabled:
            //  button = .init(title: "back", style: .plain, target: target, action: action)
            button = .init(image: Image(named: "up-arrow"), style: .plain, target: target, action: action)
            button.isEnabled = false
        case .forward:
            //  button = .init(title: "forward", style: .plain, target: target, action: action)
            button = .init(image: Image(named: "down-arrow"), style: .plain, target: target, action: action)
        case .forwardDisabled:
            // button = .init(title: "forward", style: .plain, target: target, action: action)
            button = .init(image: Image(named: "down-arrow"), style: .plain, target: target, action: action)
            button.isEnabled = false
        case .done: button = .init(title: "doneAction".localForChosnLangCodeBB, style: .plain, target: target, action: action)
        case .cancel: button = .init(title: "cancelAction".localForChosnLangCodeBB, style: .plain, target: target, action: action)
        }
        button.tag = rawValue
        return button
    }

    static func detectType(barButton: UIBarButtonItem) -> KeyboardToolbarButton? {
        return KeyboardToolbarButton(rawValue: barButton.tag)
    }
}

class KeyboardToolbar: UIToolbar {
    enum InputType {
        case textField
        case textView
    }
    private weak var toolBarDelegate: KeyboardToolbarDelegate?
    private weak var textField: UITextField!
    private weak var textView: UITextView!
    private  var textInputType: InputType  = .textField

    init(for textField: UITextField, toolBarDelegate: KeyboardToolbarDelegate) {
        super.init(frame: .init(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 44)))
        barStyle = .default
        isTranslucent = true
        textInputType = .textField
        self.textField = textField
        self.toolBarDelegate = toolBarDelegate
        textField.inputAccessoryView = self
    }
    
    init(for textView: UITextView, toolBarDelegate: KeyboardToolbarDelegate) {
        super.init(frame: .init(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 44)))
        barStyle = .default
        isTranslucent = true
        textInputType = .textView
        self.textView = textView
        self.toolBarDelegate = toolBarDelegate
        textView.inputAccessoryView = self
    }

    func setup(leftButtons: [KeyboardToolbarButton], rightButtons: [KeyboardToolbarButton]) {
        let leftBarButtons = leftButtons.map {
            $0.createButton(target: self, action: #selector(buttonTapped))
        }
        let rightBarButtons = rightButtons.map {
            $0.createButton(target: self, action: #selector(buttonTapped(sender:)))
        }
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        setItems(leftBarButtons + [spaceButton] + rightBarButtons, animated: false)
    }

    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    @objc func buttonTapped(sender: UIBarButtonItem) {
        guard let type = KeyboardToolbarButton.detectType(barButton: sender) else { return }
        switch textInputType {
        case .textField:
            toolBarDelegate?.keyboardToolbar(button: sender, type: type, isInputAccessoryViewOfTextField: textField)
        case .textView:
            toolBarDelegate?.keyboardToolbar(button: sender, type: type, isInputAccessoryViewOfTextView: textView)
        }
        
    }
}

extension UITextField {
    func addKeyboardToolBar(leftButtons: [KeyboardToolbarButton],
                            rightButtons: [KeyboardToolbarButton],
                            toolBarDelegate: KeyboardToolbarDelegate) {
        let toolbar = KeyboardToolbar(for: self, toolBarDelegate: toolBarDelegate)
        toolbar.setup(leftButtons: leftButtons, rightButtons: rightButtons)
    }
}
extension UITextView {
    func addKeyboardToolBar(leftButtons: [KeyboardToolbarButton],
                            rightButtons: [KeyboardToolbarButton],
                            toolBarDelegate: KeyboardToolbarDelegate) {
        let toolbar = KeyboardToolbar(for: self, toolBarDelegate: toolBarDelegate)
        toolbar.setup(leftButtons: leftButtons, rightButtons: rightButtons)
    }
}

