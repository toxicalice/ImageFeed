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
    @IBAction private func didTapBackButton(_ sender: Any?) { } //TODO: кнопка назад не работает
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
        updateProgress()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
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
             OAuth2Service().fetchAuthToken(code: code) { result in
                 DispatchQueue.main.async {
                     switch result {
                     case .success(let body):
                         let alert = UIAlertController(title: "succes", message: "access token \(body.accessToken)", preferredStyle: .actionSheet)
                         self.present(alert, animated: true)
                     case .failure(let error):
                         let alert = UIAlertController(title: "failed", message: "error: \(error.localizedDescription)", preferredStyle: .actionSheet)
                         self.present(alert, animated: true)
                     }
                 }
             }
                decisionHandler(.cancel)
          } else {
                decisionHandler(.allow)
              
            }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}

protocol WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
    
}


