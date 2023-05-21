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
    var uiImage:UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = oauth2TokenStorage.token {
            loadProfile()
        } else {
            navigateToAuth()
        }
    }
    
    override func viewDidLoad() {
        setupViews()
    }
    
    
    private func switchToController(vcID: String) {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let viewController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: vcID)
        window.rootViewController = viewController
    }
    
    private func navigateToAuth() {
        guard let vc = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else { return }
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        OAuth2Service().fetchAuthToken(code:code, completion: { result in
            switch (result) {
            case .success(_):
                self.loadProfile()
            case .failure(let error):
                self.showError(error: error)
            }
        })
        
        
    }
    
    func loadProfile(){
        UIBlockingProgressHUD.show()
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
                self.showError(error: error)
            }
        }
    }
    
    func showError(error: Error){
        UIBlockingProgressHUD.dismiss()
        let alert = UIAlertController(title: "Что-то пошло не так(", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    
    private func setupViews() {
        
        let logoImage = UIImage(named: "logoYP")
        
        uiImage = UIImageView()
        
        view.addSubview(uiImage)
        uiImage.translatesAutoresizingMaskIntoConstraints = false
        uiImage.image = logoImage
        
        NSLayoutConstraint.activate([
            uiImage.widthAnchor.constraint(equalToConstant: 75),
            uiImage.heightAnchor.constraint(equalToConstant: 76),
            uiImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 0),
            uiImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0)
        ])
        
        self.view.backgroundColor = UIColor(named: "YP Black")
    }
}

