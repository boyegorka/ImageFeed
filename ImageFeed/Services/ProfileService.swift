//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Егор Свистушкин on 25.03.2023.
//

import UIKit
import WebKit

final class ProfileService {
    
    static let shared = ProfileService()
    private let urlSession = URLSession.shared
    private let storage = OAuth2TokenStorage()
    private var task: URLSessionTask?
    private (set) var savedProfile: Profile?
    
    func logOut() {
        savedProfile = nil
        storage.token = nil
        UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.rootViewController = SplashViewController()
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
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
        } else if savedProfile != nil {
            return
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
        self.task = task
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
