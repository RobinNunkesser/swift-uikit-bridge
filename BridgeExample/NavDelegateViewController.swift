//
//  NavDelegateViewController.swift
//  BridgeExample
//
//  Created by Prof. Dr. Nunkesser, Robin on 13.03.23.
//

import UIKit
import WebKit

class NavDelegateViewController : UIViewController {
    @IBOutlet weak var webViewContainer: UIView!
    
    lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
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
        
        if let url = URL(string: "https://www.apple.de") {
            webView.load(URLRequest(url: url))
        }
        
        webView.navigationDelegate = self
    }
}

extension NavDelegateViewController : WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor
           navigationAction: WKNavigationAction,
           decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {

        // navigation types: linkActivated, formSubmitted,
        //                   backForward, reload, formResubmitted, other

        if navigationAction.navigationType == .linkActivated {
            let request = navigationAction.request
            if request.url!.absoluteString.contains("buy") {
                //this tells the webview to cancel the request
                decisionHandler(.cancel)
                return
            }
        }

        //this tells the webview to allow the request
        decisionHandler(.allow)

    }
}
