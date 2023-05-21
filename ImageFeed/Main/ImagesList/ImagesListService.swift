//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Алиса Долматова on 21.05.2023.
//

import Foundation


class ImagesListService {
    static let shared = ImagesListService()
    var photos: [Photo] = []
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    var pageNumber: Int = 0
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    
   func fetchPhotosNextPage() {
       
       if let _ = task { return }
       pageNumber += 1
       
       let url = URL(string: "https://api.unsplash.com/photos")!
       
       var request = URLRequest(url: url)
       request.httpMethod = "GET"
       
       guard let accessToken: String = OAuth2TokenStorage().token else {return}
       
       request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
       
      task = urlSession.objectTask(for: request) { (result: Swift.Result<[PhotoResult], Error>) in
            switch (result) {
            case .success(let responseBody):
                DispatchQueue.main.async {
                    self.photos.append(contentsOf: responseBody.map({ $0.toPhoto() }))
                    NotificationCenter.default
                        .post(
                            name: ImagesListService.DidChangeNotification,
                            object: self,
                            userInfo: ["Array": self.photos])
                }
            case .failure(_):
                break
            }
        }
        task?.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void){
        let httpMethod: String
        
        if isLike {
            httpMethod = "POST"
        } else {
            httpMethod = "DELETE"
        }
        
        let url = URL(string: "https://api.unsplash.com/photos/\(photoId)/like")!
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        
        guard let accessToken: String = OAuth2TokenStorage().token else {return}
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        task = urlSession.objectTask(for: request) { (result: Swift.Result<VoidStruct, Error>) in
            switch (result) {
            case .success(_):
                DispatchQueue.main.async {
                    completion(.success(Void()))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task?.resume()
    }
}
       
  
