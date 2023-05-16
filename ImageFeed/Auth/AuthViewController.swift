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
        
    }
}
