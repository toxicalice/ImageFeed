//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Алиса Долматова on 19.05.2023.
//

import Foundation

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
        
        
        let task = urlSession.dataTask(with: request) { data, response, requestError in
            
            if let response = response as? HTTPURLResponse {
                if  200 ..< 300 ~= response.statusCode {
                    if let data = data {
                        do {
                            let bodyResponse = try JSONDecoder().decode(UserResult.self, from: data)
                            DispatchQueue.main.async {
                                self.avatarURL = bodyResponse.profileImage.small
                                completion(Result.success(bodyResponse.profileImage.small))
                                NotificationCenter.default                                     // 1
                                    .post(                                                     // 2
                                        name: ProfileImageService.DidChangeNotification,       // 3
                                        object: self,                                          // 4
                                        userInfo: ["URL": bodyResponse.profileImage.small])
                            }
                        }
                        catch {
                            DispatchQueue.main.async {
                                completion(Result.failure(error))
                                
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(Result.failure(NetworkError.httpStatusCode(response.statusCode)))
                    }
                }
            }
            
            guard let requestError = requestError else {return}
            DispatchQueue.main.async {
                completion(Result.failure(NetworkError.urlRequestError(requestError)))
            }
            
        }
        task.resume()
    }
}
