//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Егор Свистушкин on 10.03.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    private let keyToken = "AuthToken"
    private let keychainWrapper = KeychainWrapper.standard
    
    var token: String? {
        get {
            keychainWrapper.string(forKey: keyToken)
        }
        set {
            if let token = newValue {
                keychainWrapper.set(token, forKey: keyToken)
            } else {
                let removeSuccessful: Bool = keychainWrapper.removeObject(forKey: keyToken)
            }
        }
    }
}
