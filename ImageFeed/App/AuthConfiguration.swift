//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by Егор Свистушкин on 25.02.2023.
//

import Foundation

private let unsplashAccessKey = "179aD83uBl146ILox9MD6xC7r0d1nOl1q-9TxpAqj-4"
private let unsplashSecretKey = "Vs10vdn_Na0rUgbWCEYDcBwG1R5oywPudEmp_mTz_qs"
private let unsplashRedirectURI = "urn:ietf:wg:oauth:2.0:oob"
private let unsplashAccessScope = "public+read_user+write_likes"

private let unsplashDefaultBaseURL = URL(string: "https://api.unsplash.com/")!
private let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authorizeURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL, authorizeURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authorizeURLString = authorizeURLString
    }
    
    static var standart: AuthConfiguration {
        return AuthConfiguration(accessKey: unsplashAccessKey,
                                 secretKey: unsplashSecretKey,
                                 redirectURI: unsplashRedirectURI,
                                 accessScope: unsplashAccessScope,
                                 defaultBaseURL: unsplashDefaultBaseURL,
                                 authorizeURLString: unsplashAuthorizeURLString)
    }
}
