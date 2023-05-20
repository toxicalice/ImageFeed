//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Alice on 10.05.2023.
//

import Foundation
import UIKit

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
    
    private func updateAvatar() {                                   // 8
           guard
               let profileImageURL = ProfileImageService.shared.avatarURL,
               let url = URL(string: profileImageURL)
           else { return }
           // TODO [Sprint 11] Обновить аватар, используя Kingfisher
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
        uiImage.tintColor = .gray
        
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
            OAuth2TokenStorage().token = nil
            self.switchToController(vcID: "AuthNavigationController")
        }))
        self.present(alert, animated: true)
        
        
        
    }
    private func switchToController(vcID: String) {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let viewController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: vcID)
        window.rootViewController = viewController
    }
}
