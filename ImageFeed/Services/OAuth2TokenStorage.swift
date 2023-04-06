//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Егор Свистушкин on 10.03.2023.
//

import Foundation
import SwiftKeychainWrapper

class OAuth2TokenStorage {
    
    let keyToken = "AuthToken"
    
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: keyToken)
        }
        set {
            if let token = newValue {
                KeychainWrapper.standard.set(token, forKey: keyToken)
            } else {
                let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: keyToken)
            }
        }
    }
}
