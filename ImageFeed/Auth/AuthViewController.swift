//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by toxicalIce on 14.05.2023.
//

import Foundation
import UIKit
import ProgressHUD

protocol AuthViewControllerDelegate {
   func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}


class AuthViewController:UIViewController, WebViewViewControllerDelegate {
    let showWebViewID = "ShowWebView"
    var delegate: AuthViewControllerDelegate?

    private let profileService = ProfileService.shared
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let webViewViewController = segue.destination as? WebViewViewController {
            webViewViewController.delegate = self
            let presenter = WebViewPresenter(authHelper: AuthHelper())
            presenter.view = webViewViewController
            webViewViewController.presenter = presenter
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String){
        webViewViewControllerDidCancel(vc)
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    private func switchToController(vcID: String) {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let viewController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: vcID)
        window.rootViewController = viewController
    }
}
