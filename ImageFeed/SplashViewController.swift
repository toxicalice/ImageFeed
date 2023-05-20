//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Алиса Долматова on 18.05.2023.
//

import Foundation
import UIKit

class SplashViewController:UIViewController, AuthViewControllerDelegate {
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = oauth2TokenStorage.token {
            switchToController(vcID: "TabBarViewController")
        } else {
            switchToController(vcID: "AuthNavigationController")
        }
    }
    
    private func switchToController(vcID: String) {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let viewController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: vcID)
        window.rootViewController = viewController
        
        if vcID == "AuthNavigationController" {
            guard let navigationController = viewController as? UINavigationController else {return}
            guard let viewController = navigationController.viewControllers.first as? AuthViewController else {return}
            viewController.delegate = self
        }
    }
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        OAuth2Service().fetchAuthToken(code:code, completion: { result in
            switch result {
            case .success(let accessToken):
                OAuth2TokenStorage().token = accessToken
                self.switchToController(vcID: "TabBarViewController")
            case .failure(_):
                break
            }
        } )
    }
}
