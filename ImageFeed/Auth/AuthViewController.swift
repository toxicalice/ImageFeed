//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by toxicalIce on 14.05.2023.
//

import Foundation
import UIKit

class AuthViewController:UIViewController, WebViewViewControllerDelegate {
    let showWebViewID = "ShowWebView"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let webViewViewController = segue.destination as? WebViewViewController {
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String){
        OAuth2Service().fetchAuthToken(code:code, completion: { result in
            switch result {
            case .success(let response):
                OAuth2TokenStorage().token = response.accessToken
                self.switchToController(vcID: "TabBarViewController")
            case .failure(let _):
                break
            }
        } )
    }
    
    private func switchToController(vcID: String) {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let viewController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: vcID)
        window.rootViewController = viewController
    }
}
