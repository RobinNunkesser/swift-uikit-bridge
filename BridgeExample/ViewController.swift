//
//  ViewController.swift
//  BridgeExample
//
//  Created by Prof. Dr. Nunkesser, Robin on 08.03.23.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var webViewContainer: UIView!
    let webView: WKWebView
    
    required init?(coder: NSCoder) {
        let configuration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: configuration)

        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webViewContainer.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.widthAnchor.constraint(equalTo: webViewContainer.widthAnchor),
            webView.heightAnchor.constraint(equalTo: webViewContainer.heightAnchor)
        ])
        
        webView.load(URLRequest(url: URL(string:"https://www.apple.com")!))
    }


}

