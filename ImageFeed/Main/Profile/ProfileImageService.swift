//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Алиса Долматова on 19.05.2023.
//

import Foundation
import UIKit

struct UserResult: Codable{
    let profileImage: ProfileImage
    
    struct ProfileImage: Codable {
        let small: String
        
        enum CodingKeys: String, CodingKey{
            case small = "small"
        }
    }
    enum CodingKeys: String, CodingKey{
        case profileImage = "profile_image"
    }
}


final class ProfileImageService {
    
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    private (set) var avatarURL: String?
    private let urlSession = URLSession.shared
    
   
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        
        
        let url = URL(string: "https://api.unsplash.com/users/\(username)")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        guard let accessToken: String = OAuth2TokenStorage().token else {return}
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

       let task = urlSession.objectTask(for: request) { (result: Swift.Result<UserResult, Error>) in
            switch (result) {
            case .success(let responseBody):
                self.avatarURL = responseBody.profileImage.small
                completion(.success(responseBody.profileImage.small))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.DidChangeNotification,
                        object: self,
                        userInfo: ["URL": responseBody.profileImage.small])
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
