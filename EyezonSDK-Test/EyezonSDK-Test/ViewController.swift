//
//  ViewController.swift
//  EyezonSDK-Test
//
//  Created by Danik Lubohinec on 17.08.2021.
//

import UIKit
import EyezonSDK

var apnToken = ""
var bundleID = ""

class ViewController: UIViewController {
    
    private enum Constants {
        static let EYEZON_WIDGET_URL = "https://storage.googleapis.com/eyezonfortest/test-widget/webview.html?eyezon&businessId=5d63fe246c2590002eecef83&language=ru&buttonId=5ec26f248107de3797f0807c&target=SKU-1&title=Samsung%20Television&apnToken=\(apnToken)&application=\(bundleID)&eyezonRegion=sandbox"
        
        static let EYEZON_BUSINESS_ID = "5d63fe246c2590002eecef83"
        static let EYEZON_BUTTON_ID = "5ec26f248107de3797f0807c"
    }
    
    private var predefinedData: EyezonSDKData {
        EyezonSDKData(
            businessId: Constants.EYEZON_BUSINESS_ID,
            buttonId: Constants.EYEZON_BUTTON_ID,
            widgetUrl: Constants.EYEZON_WIDGET_URL
        )
    }
    private var servers: [ServerArea] {
        [.russia, .europe, .usa, .sandbox]
    }
    private let selectedServer: ServerArea = .sandbox
    
    @IBAction func startButton(_ sender: Any) {
        openEyezon()
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
        
        Eyezon.instance.initSdk(area: selectedServer) { [weak self, predefinedData] in
            let eyezonWebViewController = Eyezon.instance.openButton(data: predefinedData, broadcastReceiver: self)
            print(Constants.EYEZON_WIDGET_URL)
            self?.navigationController?.pushViewController(eyezonWebViewController, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension ViewController: EyezonBroadcastReceiver {
    func onConsoleEvent(eventName: String, event: [String: Any]) {
        print(#function, " \(eventName)")
    }
}
