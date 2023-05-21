//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Алиса Долматова on 21.05.2023.
//

import Foundation

struct PhotoResult: Codable {
    
    let id: String
    let urls: UrlsResult?
    let width: Int?
    let height: Int?
    let createdAt: String?
    let description: String?
    let likedByUser: Bool?

    struct UrlsResult: Codable{
        
        let thumb: String
        let full: String
        
        enum CodingKeys: String, CodingKey{
           
            case thumb = "thumb"
            case full = "full"
        }
    }
    
    enum CodingKeys: String, CodingKey{
        case id = "id"
        case urls = "urls"
        case width = "width"
        case height = "height"
        case createdAt = "created_at"
        case description = "description"
        case likedByUser = "liked_by_user"
        
    }
    
    func toPhoto () -> Photo {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        let date = dateFormatter.date(from: createdAt ?? "2016-07-10T11:00:01-05:00")
        
        return Photo (id: id, size: CGSize(width: Double(width ?? 0), height: Double(height ?? 0)), createdAt: date, welcomeDescription: description, thumbImageURL: urls?.thumb ?? "", largeImageURL: urls?.full ?? "", isLiked: likedByUser ?? false)
        
    }
    
    
}

