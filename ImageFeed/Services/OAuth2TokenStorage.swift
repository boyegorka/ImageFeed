//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Егор Свистушкин on 10.03.2023.
//

import Foundation

class OAuth2TokenStorage {
 
    var token: String? {
        get {
            UserDefaults.standard.string(forKey: "token")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "token")
            UserDefaults.standard.synchronize()
        }
    }
    
}
