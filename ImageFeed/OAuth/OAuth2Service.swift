//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Алиса Долматова on 16.05.2023.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

final class OAuth2Service {
    
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    func fetchAuthToken (code: String, completion: @escaping (Swift.Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "unsplash.com"
        urlComponents.path = "/oauth/token"
        urlComponents.queryItems = [URLQueryItem(name: "client_id", value: accessKey),
                                    URLQueryItem(name: "client_secret", value: secretKey),
                                    URLQueryItem(name: "redirect_uri", value: redirectURI),
                                    URLQueryItem(name: "code", value: code),
                                    URLQueryItem(name: "grant_type", value: "authorization_code") ]
        let url = urlComponents.url!
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = urlSession.objectTask(for: request) { (result: Swift.Result<OAuthTokenResponseBody, Error>) in
            switch (result) {
            case .success(let responseBody):
                OAuth2TokenStorage().token = responseBody.accessToken
                completion(.success(responseBody.accessToken))
            case .failure(let error):
                self.lastCode = nil
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
}
