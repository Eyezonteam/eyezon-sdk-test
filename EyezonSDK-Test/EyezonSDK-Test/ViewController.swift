//
//  ViewController.swift
//  EyezonSDK-Test
//
//  Created by Danik Lubohinec on 17.08.2021.
//

import UIKit
import EyezonSDK

class ViewController: UIViewController {
    
    private enum Constants {
        static let EYEZON_WIDGET_URL =
            "https://storage.googleapis.com/eyezonfortest/test-widget/webview.html?eyezon&putInCart=true&eyezonRegion=sandbox&language=ru&target=SKU-1&title=Samsung%20Television&name=Test&phone=%2B3801111111111&email=test@test.test&clientId=test123&region=Brest"
        
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
        Eyezon.instance.initSdk(area: selectedServer) { [weak self, predefinedData] in
            let eyezonWebViewController = Eyezon.instance.openButton(data: predefinedData, broadcastReceiver: self)
            self?.navigationController?.pushViewController(eyezonWebViewController, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension ViewController: EyezonBroadcastReceiver {
    func onNewMessage(message: EyezonMessage) {
        print(#function)
    }
    
    func onDialogCreated(dialogId: String) {
        print(#function)
    }
    
    func onDialogDeleted(dialogId: String) {
        print(#function)
    }
    
    func onDialogReturned(dialogId: String) {
        print(#function)
    }
    
    func onConsoleEvent(eventName: String, event: [String: Any]) {
        print(#function, " \(eventName)")
    }
}
