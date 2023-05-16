//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by toxicalIce on 14.05.2023.
//

import Foundation
import WebKit

class WebViewViewController: UIViewController {
    @IBOutlet private var webView: WKWebView!
    @IBAction private func didTapBackButton(_ sender: Any?) { }
    @IBOutlet private var progressView: UIProgressView! 
    
    var delegate: WebViewViewControllerDelegate?
    
    override func viewDidLoad() {
           super.viewDidLoad()
        var urlComponents = URLComponents(string: defaultBaseURL.absoluteString)!
        urlComponents.queryItems = [
           URLQueryItem(name: "client_id", value: accessKey),
           URLQueryItem(name: "redirect_uri", value: redirectURI),
           URLQueryItem(name: "response_type", value: "code"),
           URLQueryItem(name: "scope", value: accessScope)
         ]
         let url = urlComponents.url!
        
        webView.navigationDelegate = self
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    
    
}

extension WebViewViewController: WKNavigationDelegate {
    
    
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
         if let code = code(from: navigationAction) {
                //TODO: process code
                decisionHandler(.cancel)
          } else {
                decisionHandler(.allow)
              
            }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,                         //1
            let urlComponents = URLComponents(string: url.absoluteString),  //2
            urlComponents.path == "/oauth/authorize/native",                //3
            let items = urlComponents.queryItems,                           //4
            let codeItem = items.first(where: { $0.name == "code" })        //5
        {
            return codeItem.value                                           //6
        } else {
            return nil
        }
    }
}

protocol WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
    
}


