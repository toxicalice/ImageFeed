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
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIBlockingProgressHUD.show()
        if let token = oauth2TokenStorage.token {
            profileService.fetchProfile() { result in
                switch(result) {
                case .success(let profile):
                    self.profileImageService.fetchProfileImageURL(username: profile.username) { result in
                        switch (result) {
                        case .success(_):
                            break
                        case .failure(_):
                            break
                        }
                    }
                    UIBlockingProgressHUD.dismiss()
                    self.switchToController(vcID: "TabBarViewController")
                case .failure(let error):
                    UIBlockingProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Что-то пошло не так(", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
            
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
        UIBlockingProgressHUD.show()
        OAuth2Service().fetchAuthToken(code:code, completion: { result in
            self.profileService.fetchProfile() { result in
                switch(result) {
                case .success(_):
                    UIBlockingProgressHUD.dismiss()
                    self.switchToController(vcID: "TabBarViewController")
                    
                case .failure(let error):
                    UIBlockingProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Что-то пошло не так(", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        } )
    }
    
}


