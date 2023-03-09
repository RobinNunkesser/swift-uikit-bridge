//
//  ViewController.swift
//  BridgeExample
//
//  Created by Prof. Dr. Nunkesser, Robin on 08.03.23.
//

import UIKit
import WebKit

class SimpleBridgeViewController: UIViewController {

    @IBOutlet weak var webViewContainer: UIView!
    
    let MessageHandlerName = "simpleMessageHandler"
    
    lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        userContentController.add(self, name: MessageHandlerName)
        configuration.userContentController = userContentController
        return WKWebView(frame: .zero,configuration: configuration)
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webViewContainer.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.widthAnchor.constraint(equalTo: webViewContainer.widthAnchor),
            webView.heightAnchor.constraint(equalTo: webViewContainer.heightAnchor)
        ])
        
        if let url = Bundle.main.url(forResource: "simplePage", withExtension: "html") {
            webView.load(URLRequest(url: url))
        }
    }


}

extension SimpleBridgeViewController : WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == MessageHandlerName {
            guard let dict = message.body as? [String: AnyObject],
                  let param1 = dict["param1"] as? String,
                  let param2 = dict["param2"] as? Int
            else {
                return
            }
            debugPrint(param1)
            debugPrint(param2)
        }
    }
}

