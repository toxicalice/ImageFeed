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
        guard let accessToken: String = OAuth2TokenStorage().token else {
            completion(.failure(NSError()))
            return
        }
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        
        let task = urlSession.objectTask(for: request) { (result: Swift.Result<ProfileResult, Error>) in
             switch (result) {
             case .success(let responseBody):
                 self.profile = responseBody.toProfile()
                 completion(.success(responseBody.toProfile()))
             case .failure(let error):
                 completion(.failure(error))
             }
         }
         task.resume()
    }
}
