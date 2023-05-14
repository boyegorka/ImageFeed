//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Егор Свистушкин on 10.02.2023.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    
    // MARK: - Properties (var & let)
    
    var image: URL! {
        didSet {
            guard isViewLoaded else { return }
            setImage(imageUrl: image)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        setImage(imageUrl: image)
    }
    
    // MARK: - Actions (IBActions)
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        let share = UIActivityViewController(activityItems: [image as Any], applicationActivities: nil)
        present(share, animated: true, completion: nil)
    }
    
    // MARK: - Functions
    
    private func setImage(imageUrl: URL) {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: imageUrl) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure(_):
                showErrorAlert()
            }
        }
    }
    
    private func showErrorAlert() {
        let actionNo = UIAlertAction(title: "Не надо", style: .cancel) { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        
        let actionReload = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            guard let image = self?.image else { return }
            self?.setImage(imageUrl: image)
        }
        
        let viewModel = AlertModel(title: "Что-то пошло не так", message: "Попробовать ещё раз?", actions: [actionNo, actionReload])
        let presenter = AlertPresenter(delegate: self)
        presenter.show(result: viewModel)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

// MARK: - Extensions

extension SingleImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
