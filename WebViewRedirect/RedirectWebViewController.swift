//
//  RedirectWebViewController.swift
//  WebViewRedirect
//
//  Created by IEVGENII IABLONSKYI on 11.03.20.
//  Copyright © 2020 IEVGENII IABLONSKYI. All rights reserved.
//

import UIKit
import WebKit

class RedirectWebViewController: UIViewController {
    
    var url: URL? = URL(string: "https://www.youtube.com")
    var redirectTargetURL = "https://m.youtube.com/#menu"
    var webView: WKWebView!
    
    lazy var loadingView: UIView = {
        let container = UIView()
        container.backgroundColor = .lightGray
        view.frame = self.view.frame
        
        let indicatorWidth: CGFloat = 24
        let indicatorHeight: CGFloat = 24
        
        let indicatorXPositin: CGFloat = (self.view.frame.width / 2) - (indicatorWidth / 2)
        let indicatorYPositin: CGFloat = (self.view.frame.height / 2) - (indicatorWidth / 2)
        
        var indicator = UIActivityIndicatorView(frame: CGRect(x: indicatorXPositin, y: indicatorYPositin, width: indicatorWidth, height: indicatorHeight))
        container.addSubview(indicator)
        
        indicator.color = .black
        indicator.startAnimating()
        
        return container
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        setTitle()
    }
    
    private func setupWebView() {
        webView = WKWebView(frame: .zero)
        webView.scrollView.bounces = false
        webView.navigationDelegate = self
        
        view.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        guard let _url = self.url else { return }
        let request = URLRequest(url: _url)
        
        webView.load(request)
        
        startLoading()
    }
    
    private func setTitle() {
        let indexOfSelfInNavigationStack = self.navigationController?.viewControllers.firstIndex(of: self) ?? 0
        self.title = String(indexOfSelfInNavigationStack)
    }
    
    private func startLoading() {
        self.webView.addSubview(loadingView)
    }
    
    private func stopLoadingAnimation() {
        loadingView.removeFromSuperview()
    }
    
}


extension RedirectWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stopLoadingAnimation()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        stopLoadingAnimation()
    }
    
    // Redirection
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(WKNavigationActionPolicy.allow) // Must be called or app will crash
        
        if navigationAction.request.url?.absoluteString == redirectTargetURL {
            
            guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: String(describing: RedirectWebViewController.self)) as? RedirectWebViewController else { return }
            
            controller.url = self.url // Set URL to load
            controller.redirectTargetURL = self.redirectTargetURL // Set desired URL
            
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
    }
}

