//
//  ProfileImageModel.swift
//  ImageFeed
//
//  Created by Егор Свистушкин on 09.04.2023.
//

import Foundation

struct UserResult: Decodable {
    let profileImage: SizedProfileImages
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct SizedProfileImages: Decodable {
    let small: String
    let medium: String
    let large: String
    
    enum CodingKeys: String, CodingKey {
        case small = "small"
        case medium = "medium"
        case large = "large"
    }
}

