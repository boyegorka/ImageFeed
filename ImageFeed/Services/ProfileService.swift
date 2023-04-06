//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Егор Свистушкин on 25.03.2023.
//

import UIKit

final class ProfileService {
    
    static let shared = ProfileService()
    private let urlSession = URLSession.shared
    private let storage = OAuth2TokenStorage()
    private var task: URLSessionTask?
    private (set) var savedProfile: Profile?
    
    func logOut() {
        storage.token = nil
        UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.rootViewController = SplashViewController()
    }
    
    func fetchProfile(completion: @escaping (Result<Bool, Error>) -> Void) {
        
        // Добавил устранение гонки, должно работать, если данные есть, то мы всё отменяем, если нет, то продолжаем запросы 4.04.23, 13:28
        assert(Thread.isMainThread)
        if task != nil {
            if savedProfile == nil {
                task?.cancel()
            } else {
                return
            }
        } else {
            if savedProfile != nil {
                return
            }
        }
        
        var request = URLRequest.makeHTTPRequest(path: "/me", httpMethod: "GET")
        
        if let token = storage.token {
            request.setToken(token)
        }
        
        let task = object(for: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                self.savedProfile = Profile.init(profileResult: body)
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    
    private func object(for request: URLRequest, completion: @escaping (Result<ProfileResult, Error>) -> Void) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<ProfileResult, Error> in
                Result { try decoder.decode(ProfileResult.self, from: data) }
            }
            completion(response)
        }
    }
}

extension ProfileService {
    
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
}
