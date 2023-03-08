//
//  ViewController.swift
//  BridgeExample
//
//  Created by Prof. Dr. Nunkesser, Robin on 08.03.23.
//

import UIKit
import WebKit

let doStuffMessageHandler = "doStuffMessageHandler"

class ViewController: UIViewController {

    @IBOutlet weak var webViewContainer: UIView!
    var webView: WKWebView
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.add(self, name: doStuffMessageHandler)
        webView = WKWebView(frame: .zero,configuration: configuration)

        webView.translatesAutoresizingMaskIntoConstraints = false
        webViewContainer.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.widthAnchor.constraint(equalTo: webViewContainer.widthAnchor),
            webView.heightAnchor.constraint(equalTo: webViewContainer.heightAnchor)
        ])
        
        if let url = Bundle.main.url(forResource: "index", withExtension: "html") {
            webView.load(URLRequest(url: url))
        }
    }


}

extension ViewController : WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == doStuffMessageHandler {
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

