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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    
    let profileImage = UIImage(systemName: "person.crop.circle.fill")
        
    let uiImage = UIImageView()
        
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
        
        
    let labelName = UILabel()
        
        view.addSubview(labelName)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        labelName.text = "Екатерина Новикова"
        labelName.textColor = UIColor(named: "YP White")
        labelName.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        
        NSLayoutConstraint.activate([
            labelName.topAnchor.constraint(equalTo: uiImage.bottomAnchor, constant: 8),
            labelName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        
        
    let labelNickName = UILabel()
            
        view.addSubview(labelNickName)
        labelNickName.translatesAutoresizingMaskIntoConstraints = false
        labelNickName.text = "@ekaterina_nov"
        labelNickName.textColor = .gray
        
        NSLayoutConstraint.activate([
            labelNickName.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 8),
            labelNickName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
            
    let labelText = UILabel()
                
        view.addSubview(labelText)
        labelText.translatesAutoresizingMaskIntoConstraints = false
        labelText.text = "Hello world"
        labelText.textColor = UIColor(named: "YP White")
        
        NSLayoutConstraint.activate([
            labelText.topAnchor.constraint(equalTo: labelNickName.bottomAnchor, constant: 8),
            labelText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
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
        
    }
    
}
