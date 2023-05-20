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
        if task != nil {
            if lastCode != code {
                task?.cancel()
            } else {
                return
            }
        } else {
            if lastCode == code {
                return
            }
        }
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
        
     
        let task = urlSession.dataTask(with: request) { data, response, requestError in
            
            if let response = response as? HTTPURLResponse {
                if  200 ..< 300 ~= response.statusCode {
                    if let data = data {
                        do {
                            let bodyResponse = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                            DispatchQueue.main.async {
                                completion(Result.success(bodyResponse.accessToken))
                                self.task = nil
                            }
                        }
                        catch {
                            DispatchQueue.main.async {
                                completion(Result.failure(error))
                                self.task = nil
                                self.lastCode = nil
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(Result.failure(NetworkError.httpStatusCode(response.statusCode)))
                        self.task = nil
                        self.lastCode = nil
                    }
                }
            }
            
            guard let requestError = requestError else {return}
            DispatchQueue.main.async {
                completion(Result.failure(NetworkError.urlRequestError(requestError)))
                self.task = nil
                self.lastCode = nil
            }
            
        }
        self.task = task
        task.resume()
        
    }
}
