//
//  URLSessionExtensions.swift
//  ImageFeed
//
//  Created by Алиса Долматова on 20.05.2023.
//

import Foundation

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        
        let task = dataTask(with: request, completionHandler: { data, response, requestError in
            
            if let response = response as? HTTPURLResponse {
                if  200 ..< 300 ~= response.statusCode {
                    if let data = data {
                        do {
                            let bodyResponse = try JSONDecoder().decode(T.self, from: data)
                            DispatchQueue.main.async {
                                completion(Result.success(bodyResponse))
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
        })
        return task
    }
}






