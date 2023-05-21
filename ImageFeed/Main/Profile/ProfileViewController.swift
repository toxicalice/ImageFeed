//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Alice on 10.05.2023.
//

import Foundation
import WebKit
import UIKit
import Kingfisher

class ProfileViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var uiImage:UIImageView!
    var labelName:UILabel!
    var labelNickName:UILabel!
    var labelText:UILabel!
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
        
        if let profile = profileService.profile {
            updateProfileDetails(profile: profile)
        }
    }
    
    private func updateAvatar() {                                   
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let imageUrl = URL(string: profileImageURL)
        else { return }
        
        
        uiImage.kf.setImage(with: imageUrl, placeholder: UIImage(named: "placeholder.jpeg"))
        
    }
    
    private func updateProfileDetails(profile: Profile){
        labelName.text = profile.name
        labelNickName.text = profile.loginName
        labelText.text = profile.bio
    }
    
    private func setupViews() {
        
        let profileImage = UIImage(systemName: "person.crop.circle.fill")
        
        uiImage = UIImageView()
        
        view.addSubview(uiImage)
        uiImage.translatesAutoresizingMaskIntoConstraints = false
        uiImage.image = profileImage
        uiImage.backgroundColor = .clear
        uiImage.tintColor = .gray
        uiImage.layer.cornerRadius = 35
        uiImage.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            uiImage.widthAnchor.constraint(equalToConstant: 70),
            uiImage.heightAnchor.constraint(equalToConstant: 70),
            uiImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            uiImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])
        
        
        labelName = UILabel()
        
        view.addSubview(labelName)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        labelName.text = "Екатерина Новикова"
        labelName.textColor = UIColor(named: "YP White")
        labelName.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        
        NSLayoutConstraint.activate([
            labelName.topAnchor.constraint(equalTo: uiImage.bottomAnchor, constant: 8),
            labelName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelName.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: 16)
        ])
        
        
        
        labelNickName = UILabel()
        
        view.addSubview(labelNickName)
        labelNickName.translatesAutoresizingMaskIntoConstraints = false
        labelNickName.text = "@ekaterina_nov"
        labelNickName.textColor = .gray
        
        NSLayoutConstraint.activate([
            labelNickName.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 8),
            labelNickName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelNickName.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: 16)
        ])
        
        
        labelText = UILabel()
        
        view.addSubview(labelText)
        labelText.translatesAutoresizingMaskIntoConstraints = false
        labelText.text = "Hello world"
        labelText.textColor = UIColor(named: "YP White")
        labelText.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            labelText.topAnchor.constraint(equalTo: labelNickName.bottomAnchor, constant: 8),
            labelText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelText.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: 16)
        ])
        
        let uiButton = UIButton.systemButton(with: UIImage(named:"exit")!, target: self, action: #selector(Self.didTapButton))
        
        view.addSubview(uiButton)
        uiButton.translatesAutoresizingMaskIntoConstraints = false
        uiButton.tintColor = UIColor(named: "YP Red")
        
        NSLayoutConstraint.activate([
            uiButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            uiButton.centerYAnchor.constraint(equalTo: uiImage.centerYAnchor),
            uiButton.widthAnchor.constraint(equalToConstant: 44),
            uiButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
    }
    
    @objc
    private func didTapButton() {
        
        let alert = UIAlertController(title: "Пока кай", message: "Уверены что хотите выйти?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel))
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { close in
            self.cleanStorages()
            self.switchToSplash()
        }))
        self.present(alert, animated: true)
    }
    
    private func cleanStorages() {
        OAuth2TokenStorage().token = nil
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
           records.forEach { record in
              WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
           }
        }
    }
    
    private func switchToSplash() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let viewController = SplashViewController()
        window.rootViewController = viewController
    }
}
