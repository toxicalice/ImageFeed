//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Алиса Долматова on 18.05.2023.
//

import Foundation
import UIKit

class SplashViewController:UIViewController {
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
    }
}
