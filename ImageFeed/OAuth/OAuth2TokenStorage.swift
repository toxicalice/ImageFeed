//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Алиса Долматова on 18.05.2023.
//

import Foundation
import SwiftKeychainWrapper


class OAuth2TokenStorage {
    
    private let userDefaults = UserDefaults.standard
    private let tokenKey = "OAuth2TokenStorage.token"
    
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: tokenKey)
        }
        
        set {
            if newValue == nil {
                KeychainWrapper.standard.removeObject(forKey: tokenKey)
            } else {
                KeychainWrapper.standard.set(newValue!, forKey: tokenKey)
            }
        }
        
    }
}
