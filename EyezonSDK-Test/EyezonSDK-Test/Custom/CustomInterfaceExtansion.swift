//
//  CustomInterfaceExtansion.swift
//  EyezonSDK-Test
//
//  Created by Danik Lubohinec on 26.11.2021.
//

import Foundation
import UIKit

extension CustomViewController: UITextFieldDelegate {
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == widgetUrlTextField {
            textField.resignFirstResponder()
            buttonIdTextField.becomeFirstResponder()
        } else if textField == buttonIdTextField {
            textField.resignFirstResponder()
            businessIdTextField.becomeFirstResponder()
        } else if textField == businessIdTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func redrawServerButtons() {
        switch selectedServer {
        case .sandbox:
            sandboxButton.backgroundColor = UIColor(named: "AccentColor")
            russiaButton.backgroundColor = .lightGray
            europeButton.backgroundColor = .lightGray
            usaButton.backgroundColor = .lightGray
        case .russia:
            sandboxButton.backgroundColor = .lightGray
            russiaButton.backgroundColor = UIColor(named: "AccentColor")
            europeButton.backgroundColor = .lightGray
            usaButton.backgroundColor = .lightGray
        case .europe:
            sandboxButton.backgroundColor = .lightGray
            russiaButton.backgroundColor = .lightGray
            europeButton.backgroundColor = UIColor(named: "AccentColor")
            usaButton.backgroundColor = .lightGray
        case .usa:
            sandboxButton.backgroundColor = .lightGray
            russiaButton.backgroundColor = .lightGray
            europeButton.backgroundColor = .lightGray
            usaButton.backgroundColor = UIColor(named: "AccentColor")
        default:
            sandboxButton.backgroundColor = .lightGray
            russiaButton.backgroundColor = .lightGray
            europeButton.backgroundColor = .lightGray
            usaButton.backgroundColor = .lightGray
        }
    }
}
