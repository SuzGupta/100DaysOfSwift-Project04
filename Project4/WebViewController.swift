//
//  WebViewController.swift
//  Project4
//
//  Created by Susannah Skyer Gupta on 4/29/19.
//  Copyright © 2019 Susannah Skyer Gupta. All rights reserved.
//

import UIKit
import WebKit


class WebViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet var webView: WKWebView!
    
    var selectedSite: String?
    var progressView: UIProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()
                
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack))
        
        let forwardButton = UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [backButton, progressButton, forwardButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        webView.navigationDelegate = self

        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
//        let url = URL(string: "https://" + websites[0])!
        
        if let siteToLoad = selectedSite {
            let url = URL(string: "https://" + siteToLoad)!
            webView.load(URLRequest(url: url))
        }
        
        webView.allowsBackForwardNavigationGestures = true

    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for website in websites {
                if (host.contains(website)) {
                    decisionHandler(.allow)
                    print("navigating to \(website) allowed")
                    return
                }
            }
        }
        decisionHandler(.cancel)
        let ac = UIAlertController(title: "Nope!", message: "nope nope nope", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(ac, animated: true)
        print("navigating to \(url!) canceled")
    }

}
