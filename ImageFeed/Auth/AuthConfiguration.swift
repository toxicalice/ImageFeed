//
//  Constants.swift
//  ImageFeed
//
//  Created by toxicalIce on 14.05.2023.
//

import Foundation

let AccessKey = "w0sTHOKiYfqtt1MzboHsumRvIjepD8oih06TcZW3-1w"
let SecretKey = "oDIClMFxXJssD7vXbzMHMqTaiAh4CUuQZMNDD55a0GI"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"

let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
let DefaultOAuthBaseURL = "https://unsplash.com/oauth/authorize"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: AccessKey,
                                 secretKey: SecretKey,
                                 redirectURI: RedirectURI,
                                 accessScope: AccessScope,
                                 authURLString: DefaultOAuthBaseURL,
                                 defaultBaseURL: DefaultBaseURL)
    }
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
}
