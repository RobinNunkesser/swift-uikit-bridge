//
//  BridgeViewController.swift
//  BridgeExample
//
//  Created by Prof. Dr. Nunkesser, Robin on 09.03.23.
//

import UIKit
import WebKit

class BridgeViewController: UIViewController {

    @IBOutlet weak var webViewContainer: UIView!
    
    let MessageHandlerName = "replyMessageHandler"
    
    lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        userContentController.addScriptMessageHandler(self, contentWorld: .page, name: MessageHandlerName)
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
        
        if let url = Bundle.main.url(forResource: "page", withExtension: "html") {
            webView.load(URLRequest(url: url))
        }
    }
    
    deinit {
                let ucc = webView.configuration.userContentController
                ucc.removeAllUserScripts()
                ucc.removeScriptMessageHandler(forName:MessageHandlerName)
        }

}

extension BridgeViewController : WKScriptMessageHandlerWithReply {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage, replyHandler: @escaping (Any?, String?) -> Void) {
            if message.name == MessageHandlerName, let messageBody = message.body as? String {
                print(messageBody)
                replyHandler( 2.2, nil ) // first var is success return val, second is err string if error
            }
        }
}
