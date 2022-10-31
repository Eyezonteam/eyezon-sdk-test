//
//  ViewController.swift
//  EyezonSDK-Test
//
//  Created by Danik Lubohinec on 17.08.2021.
//

import UIKit
import EyezonSDK

var apnToken = "Device token is empty"
var bundleID = "BundleID is empty"

class ViewController: UIViewController {
    
    private enum Constants {
        static let EYEZON_WIDGET_URL = "https://storage.googleapis.com/eyezonfortest/test-widget/webview.html?eyezon&businessId=6218dd27db9a30520ac435a8&language=ru&buttonId=6218e02a82d1c1eb6cc7db48&target=SKU-1&title=Samsung%20Television&apnToken=\(apnToken)&application=\(bundleID)&eyezonRegion=sandbox"
        
        static let EYEZON_BUSINESS_ID = "6218dd27db9a30520ac435a8"
        static let EYEZON_BUTTON_ID = "6218e02a82d1c1eb6cc7db48"
    }
    
    private var predefinedData: EyezonSDKData {
        EyezonSDKData(
            businessId: Constants.EYEZON_BUSINESS_ID,
            buttonId: Constants.EYEZON_BUTTON_ID,
            widgetUrl: Constants.EYEZON_WIDGET_URL
        )
    }
    
    private var interfaceData: EyezonSDKInterfaceBuilder {
        EyezonSDKInterfaceBuilder(isNavigationController: false,
                                  navBarBackgroundColor: .white,
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
    
    private let selectedServer: ServerArea = .sandbox
    
    @IBAction func startButton(_ sender: Any) {
        openEyezon()
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        logout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @objc
    private func openEyezon() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        apnToken = delegate?.pushToken ?? "Device token is empty"
        
        bundleID = Bundle.main.bundleIdentifier ?? "BundleID is empty"
        
        Eyezon.instance.initSdk(area: selectedServer) { [weak self, predefinedData, interfaceData] in
            guard let strongSelf = self else { return }
            let eyezonWebViewController = Eyezon.instance.openButton(data: predefinedData, interfaceBuilder: interfaceData, broadcastReceiver: strongSelf)
            strongSelf.present(eyezonWebViewController, animated: true, completion: nil)
            
            // strongSelf.navigationController?.pushViewController(eyezonWebViewController, animated: true)
        }
    }
    
    @objc
    private func logout() {
        Eyezon.instance.logout { logout, error in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            print("Success logout")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension ViewController: EyezonBroadcastReceiver {
    func onConsoleEvent(eventName: String, event: [String: Any]) {
        print(#function, " \(eventName)")
    }
}
