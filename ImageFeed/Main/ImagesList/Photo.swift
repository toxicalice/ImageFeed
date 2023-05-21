//
//  Photo.swift
//  ImageFeed
//
//  Created by Алиса Долматова on 21.05.2023.
//

import Foundation


struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

