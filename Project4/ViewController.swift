//
//  ViewController.swift
//  Project4
//
//  Created by Susannah Skyer Gupta on 4/23/19.
//  Copyright © 2019 Susannah Skyer Gupta. All rights reserved.
//

import UIKit
import WebKit

// extends from the first, a class, and conforms to one or more protocols

class ViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var progressView: UIProgressView!
//    var websites = ["miacademy.co", "apparentsoft.com", "always-icecream.com", "clever-dragons.com"]
    
    var websites = ["apparentsoft.com", "apple.com", "hackingwithswift.com", "seanallen.co"]
    
    override func loadView() {
        webView = WKWebView()
        
        // when any web navigation happens, please tell me (the current view controller)
        
        webView.navigationDelegate = self
        view = webView
        print("webView has loaded")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        // also try the .bar style below and see what you think
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false

        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        // Swift has a special URL data type
        
        let url = URL(string: "https://" + websites[0])!
        print("Initial URL set to \(url)")
        webView.load(URLRequest(url: url))
        print ("Initial URL loaded")
        webView.allowsBackForwardNavigationGestures = true
    }
    
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // anchor the action sheet here for iPad
        
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
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

