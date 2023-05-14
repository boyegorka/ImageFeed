//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Егор Свистушкин on 01.04.2023.
//

import Foundation

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    private (set) var profileImageURL: String?
    private let urlSession = URLSession.shared
    private let storage = OAuth2TokenStorage()
    private var task: URLSessionTask?
    static let didChangeProfileImageNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    func fetchProfileImageURL(username: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        // Добавил устранение гонки, должно работать, если данные есть, то мы всё отменяем, если нет, то продолжаем запросы 4.04.23, 13:30
        assert(Thread.isMainThread)
        if task != nil {
            if profileImageURL == nil {
                task?.cancel()
            } else {
                return
            }
        } else {
            if profileImageURL != nil {
                return
            }
        }
        
        var request = URLRequest.makeHTTPRequest(path: "/users/\(username)", httpMethod: "GET")
        
        if let token = storage.token {
            request.setToken(token)
        }
        
        let task = object(for: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.profileImageURL = data.profileImage.large
                completion(.success(true))
                NotificationCenter.default
                    .post(name: ProfileImageService.didChangeProfileImageNotification, object: self)
            case .failure(let error):
                print("profile image error \(error)")
                completion(.failure(error))
            }
        }
        self.task = task
    }
    
    private func object(for request: URLRequest, completion: @escaping (Result<UserResult, Error>) -> Void) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<UserResult, Error> in
                Result { try decoder.decode(UserResult.self, from: data) }
            }
            completion(response)
        }
    }
}
