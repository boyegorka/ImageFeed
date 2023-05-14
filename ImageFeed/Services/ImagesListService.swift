//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Егор Свистушкин on 12.04.2023.
//

import UIKit

class ImagesListService {
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int = 0
    private let urlSession = URLSession.shared
    private let storage = OAuth2TokenStorage()
    private var task: URLSessionTask?
    static let didChangeImageListNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private var lastPhotosLenght: Int = 0
    
    func fetchPhotosNextPage() {
        
        assert(Thread.isMainThread)
        if task != nil {
            return
        }
        lastPhotosLenght = photos.count
        
        let nextPage = lastLoadedPage + 1
        
        var request = URLRequest.makeHTTPRequest(path: "/photos?page=\(nextPage)", httpMethod: "GET")
        
        if let token = storage.token {
            request.setToken(token)
        }
        
        let task = object(for: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.lastLoadedPage = nextPage
                    let photosResult = data.map({Photo(photoResult: $0)})
                    self.photos.append(contentsOf: photosResult)
                    NotificationCenter.default
                        .post(name: ImagesListService.didChangeImageListNotification, object: self)
                }
            case .failure(let error):
                print("image error \(error)")
            }
            self.task = nil
        }
        self.task = task
    }
    
    func changeLike(photoId: String, isLike: Bool, completion: @escaping (Result<Bool, Error>) -> Void) {
        var httpMethod: String
        
        if isLike {
            httpMethod = "POST"
        } else {
            httpMethod = "DELETE"
        }
        
        var request = URLRequest.makeHTTPRequest(path: "/photos/\(photoId)/like", httpMethod: httpMethod)
        
        if let token = storage.token {
            request.setToken(token)
        }
        
        let task = objectForLike(for: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                let photoResult = Photo(photoResult: data.photo)
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    DispatchQueue.main.async {
                        self.photos[index] = photoResult
                        completion(.success(true))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
    }
    
    private func object(for request: URLRequest, completion: @escaping (Result<[PhotoResult], Error>) -> Void) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<[PhotoResult], Error> in
                return Result { try decoder.decode([PhotoResult].self, from: data) }
            }
            completion(response)
        }
    }
    
    private func objectForLike(for request: URLRequest, completion: @escaping (Result<PhotoLikedResult, Error>) -> Void) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<PhotoLikedResult, Error> in
                Result { try decoder.decode(PhotoLikedResult.self, from: data) }
            }
            completion(response)
        }
    }
}
