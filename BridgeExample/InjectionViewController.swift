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
    
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        guard let scriptPath = Bundle.main.path(forResource: "script", ofType: "js"),
              let scriptSource = try? String(contentsOfFile: scriptPath) else { return }

        let userScript = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)

        let config = WKWebViewConfiguration()

        let userContentController = WKUserContentController()
        userContentController.addUserScript(userScript)
        
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

    @IBAction func evaluateJS(_ sender: Any) {
        evaluateJavaScript(param1: "One", param2: "Two")
    }
    
    func evaluateJavaScript(param1: String, param2: String) {
        
        let data: [String: String] = [
            "param1": "\(param1)",
            "param2": "\(param2)"
        ]

        guard let json = try? JSONEncoder().encode(data),
              let jsonString = String(data: json, encoding: .utf8) else {
            return
        }
        
        let javascript = "showParams('\(jsonString)')"        
        webView?.evaluateJavaScript(javascript, completionHandler: nil)
        
    }
    
    // need to deinit and remove webview stuff
    deinit {
        if let webView = webView{
            let ucc = webView.configuration.userContentController
            ucc.removeAllUserScripts()
        }
    }
}
