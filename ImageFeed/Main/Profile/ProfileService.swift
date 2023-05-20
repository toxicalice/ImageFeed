//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Алиса Долматова on 19.05.2023.
//

import Foundation

final class ProfileService {
    
    static let shared = ProfileService()
    private let urlSession = URLSession.shared
    private(set) var profile: Profile?
    
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        let url = URL(string: "https://api.unsplash.com/me")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        guard let accessToken: String = OAuth2TokenStorage().token else {return}
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        
        let task = urlSession.dataTask(with: request) { data, response, requestError in
            
            if let response = response as? HTTPURLResponse {
                if  200 ..< 300 ~= response.statusCode {
                    if let data = data {
                        do {
                            let bodyResponse = try JSONDecoder().decode(ProfileResult.self, from: data)
                            DispatchQueue.main.async {
                                self.profile = bodyResponse.toProfile()
                                completion(Result.success(bodyResponse.toProfile()))
                                
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
