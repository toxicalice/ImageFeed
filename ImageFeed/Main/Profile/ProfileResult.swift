//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Алиса Долматова on 19.05.2023.
//

import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
    
    enum CodingKeys: String, CodingKey{
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
    
    func toProfile () -> Profile {
        return Profile(username: username,
                       name:firstName + " " + lastName,
                       loginName: "@" + username,
                       bio: bio ?? "bio")
    }
}
