//
//  Photo.swift
//  ImageFeed
//
//  Created by Егор Свистушкин on 12.04.2023.
//

import Foundation

//let dateFormatting = ISO8601DateFormatter()

struct PhotoResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String
    let welcomeDescription: String?
    let isLiked: Bool
    let image: SizedImages
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case width
        case height
        case createdAt = "created_at"
        case welcomeDescription = "description"
        case isLiked = "liked_by_user"
        case image = "urls"
    }
}

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageUrl: URL
    let largeImageUrl: URL
    var isLiked: Bool
    
    init(photoResult: PhotoResult) {
        self.id = photoResult.id
        self.size = CGSize(width: photoResult.width, height: photoResult.height)
        self.createdAt = photoResult.createdAt.dateFromISO8601()
        self.welcomeDescription = photoResult.welcomeDescription
        self.thumbImageUrl = photoResult.image.regular
        self.largeImageUrl = photoResult.image.raw
        self.isLiked = photoResult.isLiked
    }
}

struct PhotoLikedResult: Decodable {
    let photo: PhotoResult
}

struct SizedImages: Decodable {
    let raw: URL
    let full: URL
    let regular: URL
    let small: URL
    let thumb: URL
    
    enum CodingKeys: String, CodingKey {
        case raw = "raw"
        case full = "full"
        case regular = "regular"
        case small = "small"
        case thumb = "thumb"
    }
}

