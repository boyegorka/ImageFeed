//
//  ProfileModel.swift
//  ImageFeed
//
//  Created by Егор Свистушкин on 09.04.2023.
//

import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String
    
    init(profileResult: ProfileResult) {
        self.username = profileResult.username
        var name = ""
        if let firstName = profileResult.firstName {
            name = firstName
        }
        if let lastName = profileResult.lastName {
            name = (name.isEmpty) ? lastName : name + " " + lastName
        }
        self.name = name
        self.loginName = "@\(profileResult.username)"
        self.bio = profileResult.bio ?? ""
    }
}
