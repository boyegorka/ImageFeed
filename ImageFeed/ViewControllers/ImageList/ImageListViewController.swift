//
//  ImageListViewController.swift
//  ImageFeed
//
//  Created by Егор Свистушкин on 23.01.2023.
//

import UIKit
import Kingfisher

protocol ImageListViewControllerProtocol: AnyObject {
    var presenter: ImageListPresenterProtocol? { get set }
    func tableViewAddRows(indexPaths: [IndexPath])
    func updateTableView()
    func showErrorAlert()
}

class ImageListViewController: UIViewController, ImageListViewControllerProtocol {
    
    // MARK: - Outlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Properties (var & let)
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let tableViewAccessibilityIdentifier = "ImageListTableView"
    weak var delegate: ImagesListCellDelegate?
    var presenter: ImageListPresenterProtocol?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.accessibilityIdentifier = tableViewAccessibilityIdentifier
    }
    
    // MARK: - Functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let imageUrl = presenter?.photos[indexPath.row].largeImageUrl
            viewController.image = imageUrl
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func updateTableView() {
        tableView.reloadData()
    }
    
    func tableViewAddRows(indexPaths: [IndexPath]) {
        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
    
    func showErrorAlert() {
        let actionOK = UIAlertAction(title: "OK", style: .default) { _ in }
        let viewModel = AlertModel(title: "Что-то пошло не так", message: "Не удалось поставить лайк", actions: [actionOK])
        let presenter = AlertPresenter(delegate: self)
        presenter.show(result: viewModel)
    }
}

// MARK: - Extensions

extension ImageListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (presenter?.loading ?? false) ? 10 : presenter?.photos.count ?? 0
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
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard !(presenter?.loading ?? false) else { return 200 }
        
        let size = presenter?.photos[indexPath.row].size ?? CGSize.zero
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (presenter?.photos.count ?? 0) - 1 {
            presenter?.loadPhotos()
        }
    }
}

extension ImageListViewController {
    
    func getImageForIndexPath(_ indexPath: IndexPath) -> UIImage? {
        guard let cell = tableView.cellForRow(at: indexPath) as? ImagesListCell else { return nil }
        return cell.cellImage.image
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard !(presenter?.loading ?? false) else {
            cell.startAnimation()
            return
        }
        
        cell.stopAnimation()
        let photo = presenter?.photos[indexPath.row]
        cell.cellImage.kf.setImage(with: photo?.thumbImageUrl,
                                   placeholder: UIImage(named: "ImagePlaceholder"),
                                   options: [.cacheSerializer(FormatIndicatedCacheSerializer.png)]) { _ in
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        cell.cellImage.kf.indicatorType = .activity
        if let date = photo?.createdAt {
            cell.cellDateLabel.text = presenter?.dateFormatter.string(from: date)
        }
        cell.setIsLiked(isLiked: photo?.isLiked ?? false)
    }
}

extension ImageListViewController: ImagesListCellDelegate {
    
    func imagesListCellDidTapLike(_ cell: ImagesListCell) {
        guard
            let indexPath = tableView.indexPath(for: cell),
            let photo = presenter?.photos[indexPath.row]
        else { return }
        
        presenter?.setLike(photoId: photo.id, isLike: !photo.isLiked, completion: {[weak cell] isLiked in
            cell?.setIsLiked(isLiked: isLiked)
        })
    }
}
