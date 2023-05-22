//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by Егор Свистушкин on 21.05.2023.
//

import UIKit

protocol ImageListPresenterProtocol {
    var view: ImageListViewControllerProtocol? { get set }
    var dateFormatter: DateFormatter { get }
    func loadPhotos()
    var photos: [Photo] { get }
    var loading: Bool { get }
    func viewDidLoad()
    func setLike(photoId: String, isLike: Bool, completion: @escaping (Bool) -> Void)
}

final class ImageListPresenter: ImageListPresenterProtocol {
    
    weak var view: ImageListViewControllerProtocol?
    let service = ImagesListService()
    var photos: [Photo] = []
    var loading: Bool = true
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    func loadPhotos() {
        service.fetchPhotosNextPage()
    }
    
    func viewDidLoad() {
        NotificationCenter.default
            .addObserver(forName: ImagesListService.didChangeImageListNotification, object: nil, queue: .main) { [weak self] _ in
                guard let self = self else { return }
                if loading {
                    loading = false
                    self.updateTableView(animated: false)
                }
                self.updateTableView(animated: true)
            }
        loadPhotos()
    }
    
    func updateTableView(animated: Bool) {
        guard animated else {
            view?.updateTableView()
            return
        }
        let oldCount = photos.count
        let newCount = service.photos.count
        photos = service.photos
        if oldCount != newCount {
            let indexPaths = (oldCount..<newCount).map { row in
                IndexPath(row: row, section: 0)
            }
            view?.tableViewAddRows(indexPaths: indexPaths)
        }
    }
    
    func setLike(photoId: String, isLike: Bool, completion: @escaping (Bool) -> Void) {
        UIBlockingProgressHUD.show()
        service.changeLike(photoId: photoId, isLike: isLike) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }
            switch result {
            case .success(let photo):
                self.photos = self.service.photos
                completion(photo.isLiked)
            case .failure:
                self.view?.showErrorAlert()
            }
        }
    }
}
