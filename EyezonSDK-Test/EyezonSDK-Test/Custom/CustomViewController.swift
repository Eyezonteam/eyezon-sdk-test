//
//  CustomViewController.swift
//  EyezonSDK-Test
//
//  Created by Danik Lubohinec on 26.11.2021.
//

import UIKit
import EyezonSDK

class CustomViewController: UIViewController {
    
    private var interfaceData: EyezonSDKInterfaceBuilder {
        EyezonSDKInterfaceBuilder(isNavigationController: navBarSwitch.isOn,
                                  navBarBackgroundColor: .clear,
                                  navBarTitleText: "Eyezon",
                                  navBarTitleColor: UIColor.black,
                                  navBarBackButtonText: "Back",
                                  navBarBackButtonColor: UIColor(red: 1.00, green: 0.18, blue: 0.33, alpha: 1.00),
                                  navBarBackButtonLeftPosition: false
        )
    }
    
    private var servers: [ServerArea] {
        [.russia, .europe, .usa, .sandbox]
    }
    var selectedServer: ServerArea = .sandbox
    
    var widgetUrl = ""
    
    @IBOutlet weak var sandboxButton: UIButton!
    @IBOutlet weak var russiaButton: UIButton!
    @IBOutlet weak var europeButton: UIButton!
    @IBOutlet weak var usaButton: UIButton!
    
    @IBOutlet weak var navBarSwitch: UISwitch!
    
    @IBAction func sandboxButtonAction(_ sender: Any) {
        selectedServer = .sandbox
        redrawServerButtons()
    }
    
    @IBAction func russiaButtonAction(_ sender: Any) {
        selectedServer = .russia
        redrawServerButtons()
    }
    
    @IBAction func europeButtonAction(_ sender: Any) {
        selectedServer = .europe
        redrawServerButtons()
    }
    
    @IBAction func usaButtonAction(_ sender: Any) {
        selectedServer = .usa
        redrawServerButtons()
    }
    
    @IBOutlet weak var widgetUrlTextField: UITextField!
    @IBOutlet weak var buttonIdTextField: UITextField!
    @IBOutlet weak var businessIdTextField: UITextField!
    
    @IBAction func showURLButtonAction(_ sender: Any) {
        dismissKeyboard()
        showEyezon()
    }
    
    @IBAction func startButtonAction(_ sender: Any) {
        dismissKeyboard()
        openEyezon()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        widgetUrlTextField.delegate = self
        buttonIdTextField.delegate = self
        businessIdTextField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc
    private func openEyezon() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        apnToken = delegate?.pushToken ?? "Device token is empty"
        
        bundleID = Bundle.main.bundleIdentifier ?? "BundleID is empty"
        
        guard let widgetUrlTextFiledData = widgetUrlTextField.text else { return }
        guard let buttonIdTextFieldData = buttonIdTextField.text else { return }
        guard let businessIdTextFieldData = businessIdTextField.text else { return }
        
        widgetUrl = "\(widgetUrlTextFiledData)&apnToken=\(apnToken)&application=\(bundleID)"
        
        let customData = EyezonSDKData(
            businessId: businessIdTextFieldData,
            buttonId: buttonIdTextFieldData,
            widgetUrl: widgetUrl
        )
        
        Eyezon.instance.initSdk(area: selectedServer) { [weak self, customData, interfaceData] in
            guard let strongSelf = self else { return }
            let eyezonWebViewController = Eyezon.instance.openButton(data: customData, interfaceBuilder: interfaceData, broadcastReceiver: strongSelf)
            
            if strongSelf.navBarSwitch.isOn {
                strongSelf.navigationController?.pushViewController(eyezonWebViewController, animated: true)
            } else {
                strongSelf.present(eyezonWebViewController, animated: true, completion: nil)
            }
        }
    }
    
    @objc
    private func showEyezon() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        apnToken = delegate?.pushToken ?? "Device token is empty"
        
        bundleID = Bundle.main.bundleIdentifier ?? "BundleID is empty"
        
        guard let widgetUrlTextFiledData = widgetUrlTextField.text else { return }
        guard let buttonIdTextFieldData = buttonIdTextField.text else { return }
        guard let businessIdTextFieldData = businessIdTextField.text else { return }
        
        widgetUrl = "\(widgetUrlTextFiledData)&apnToken=\(apnToken)&application=\(bundleID)"
        
        let actionSheet = UIAlertController(title: "Your current URL", message: "Widget URL: \(widgetUrl)\nButtin ID: \(buttonIdTextFieldData)\nBusiness ID: \(businessIdTextFieldData)", preferredStyle: .alert)
        
        actionSheet.view.tintColor = .white
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
        }
        cancelAction.setValue(UIColor(named: "AccentColor"), forKey: "titleTextColor")
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.backgroundColor = .black
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension CustomViewController: EyezonBroadcastReceiver {
    func onConsoleEvent(eventName: String, event: [String: Any]) {
        print(#function, " \(eventName)")
    }
}
