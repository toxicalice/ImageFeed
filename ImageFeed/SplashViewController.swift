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
//    private let oauth2TokenStorage = OAuth2TokenStorage()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        if let token = OAuth2TokenStorage().token {
//            ...
//        } else {
//            performSegue(withIdentifier: ShowAuthenticationScreenSegueIdentifier, sender: nil)
//        }
    }
}
