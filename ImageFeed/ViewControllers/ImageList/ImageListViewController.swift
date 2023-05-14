//
//  ImageListViewController.swift
//  ImageFeed
//
//  Created by Егор Свистушкин on 23.01.2023.
//

import UIKit
import Kingfisher

class ImageListViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Properties (var & let)
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    private let service = ImagesListService()
    private var photos: [Photo] = []
    weak var delegate: ImagesListCellDelegate?
    var loading: Bool = true
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        NotificationCenter.default
            .addObserver(forName: ImagesListService.didChangeImageListNotification, object: nil, queue: .main) { [weak self] _ in
                guard let self = self else { return }
                if loading {
                    loading = false
                    tableView.reloadData()
                }
                self.updateTableViewAnimated()
            }
        service.fetchPhotosNextPage()
    }
    
    // MARK: - Functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let imageUrl = photos[indexPath.row].largeImageUrl
            viewController.image = imageUrl
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = service.photos.count
        photos = service.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { row in
                    IndexPath(row: row, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    private func showErrorAlert() {
        let actionOK = UIAlertAction(title: "OK", style: .default) { _ in }
        let viewModel = AlertModel(title: "Что-то пошло не так", message: "Не удалось поставить лайк", actions: [actionOK])
        let presenter = AlertPresenter(delegate: self)
        presenter.show(result: viewModel)
    }
}

// MARK: - Extensions

extension ImageListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loading ? 10 : photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as? ImagesListCell else { return UITableViewCell() }
        
        cell.delegate = self
        
        configCell(for: cell, with: indexPath)
        
        return cell
    }
}

extension ImageListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard !loading else { return 200 }
        
        let size = photos[indexPath.row].size
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 {
            service.fetchPhotosNextPage()
        }
    }
}

extension ImageListViewController {
    
    func getImageForIndexPath(_ indexPath: IndexPath) -> UIImage? {
        guard let cell = tableView.cellForRow(at: indexPath) as? ImagesListCell else { return nil }
        return cell.cellImage.image
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard !loading else {
            cell.startAnimation()
            return
        }
        
        cell.stopAnimation()
        
        let photo = photos[indexPath.row]
        
        cell.cellImage.kf.setImage(with: photo.thumbImageUrl,
                                   placeholder: UIImage(named: "ImagePlaceholder"),
                                   options: [.cacheSerializer(FormatIndicatedCacheSerializer.png)]) { _ in
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        cell.cellImage.kf.indicatorType = .activity
        
        if let date = photo.createdAt {
            cell.cellDateLabel.text = dateFormatter.string(from: date)
        }
        
        cell.setIsLiked(isLiked: photo.isLiked)
    }
}

extension ImageListViewController: ImagesListCellDelegate {
    
    func imagesListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        service.changeLike(photoId: photo.id, isLike: !photo.isLiked) { result in
            switch result {
            case .success:
                self.photos = self.service.photos
                cell.setIsLiked(isLiked: self.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showErrorAlert()
            }
        }
    }
}
