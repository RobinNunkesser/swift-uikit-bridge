//
//  InjectionViewController.swift
//  BridgeExample
//
//  Created by Prof. Dr. Nunkesser, Robin on 09.03.23.
//

import UIKit
import WebKit

class InjectionViewController: UIViewController {
    
    @IBOutlet weak var webViewContainer: UIView!

    var webView : WKWebView?
    let MessageHandlerName = "namespaceWithinTheInjectedJSCode"
    
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        guard let scriptPath = Bundle.main.path(forResource: "script", ofType: "js"),
              let scriptSource = try? String(contentsOfFile: scriptPath) else { return }

        let userScript = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)

        let config = WKWebViewConfiguration()

        let userContentController = WKUserContentController()
        userContentController.addUserScript(userScript)
        
        userContentController.addScriptMessageHandler(self, contentWorld: .page, name: MessageHandlerName)

        config.userContentController = userContentController
        
        webView = WKWebView(frame: .zero, configuration: config)
                
        if let webView = webView{
            webView.translatesAutoresizingMaskIntoConstraints = false
            webViewContainer.addSubview(webView)
            
            NSLayoutConstraint.activate([
                webView.widthAnchor.constraint(equalTo: webViewContainer.widthAnchor),
                webView.heightAnchor.constraint(equalTo: webViewContainer.heightAnchor)
            ])

            if let htmlPath = Bundle.main.url(forResource: "injectionPage", withExtension: "html"){
                webView.loadFileURL( htmlPath, allowingReadAccessTo: htmlPath);
            }
        }
    }

    // need to deinit and remove webview stuff
    deinit {
        if let webView = webView{
            let ucc = webView.configuration.userContentController
            ucc.removeAllUserScripts()
            ucc.removeScriptMessageHandler(forName:MessageHandlerName)
        }
    }
}

extension InjectionViewController: WKScriptMessageHandlerWithReply {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage, replyHandler: @escaping (Any?, String?) -> Void) {
        if message.name == MessageHandlerName, let messageBody = message.body as? String {
            print(messageBody)
            replyHandler( 2.2, nil ) // first var is success return val, second is err string if error
        }
    }
}
