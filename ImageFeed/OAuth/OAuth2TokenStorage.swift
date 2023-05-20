//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Алиса Долматова on 18.05.2023.
//

import Foundation


class OAuth2TokenStorage {
    
    private let userDefaults = UserDefaults.standard
    private let tokenKey = "OAuth2TokenStorage.token"
    
    var token: String? {
        get {
            userDefaults.string(forKey: tokenKey)
        }
        
        set {
            userDefaults.set(newValue, forKey: tokenKey)
        }
        
    }
}
