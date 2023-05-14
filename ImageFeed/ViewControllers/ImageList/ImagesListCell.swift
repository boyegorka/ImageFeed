//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Егор Свистушкин on 28.01.2023.
//

import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imagesListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet var cellDateLabel: UILabel!
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var cellLikeButton: UIButton!
    
    // MARK: - Properties (var & let)
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    lazy private var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        let topColor = UIColor.init(white: 0, alpha: 0)
        let botomColor = UIColor.init(white: 0, alpha: 1)
        
        gradient.colors = [topColor.cgColor, botomColor.cgColor]
        gradient.locations = [0, 1]
        
        cellImage.layer.addSublayer(gradient)
        return gradient
    }()
    
    // MARK: - Actions (IBActions)
    
    @IBAction private func likeButtonClicked() {
        delegate?.imagesListCellDidTapLike(self)
    }
    
    // MARK: - Functions
    
    func setIsLiked(isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "LikeActive") : UIImage(named: "LikeNoActive")
        cellLikeButton.setImage(likeImage, for: .normal)
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        let height: CGFloat = 30
        gradient.frame = CGRect(x: 0, y: frame.height - height - 4, width: frame.width , height: height)
        cellImage.updateLayerLoadingFrame()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
        cellImage.image = nil
        cellDateLabel.text = nil
        cellLikeButton.setImage(UIImage(named: "LikeNoActive"), for: .normal)
    }
    
    func startAnimation() {
        cellDateLabel.isHidden = true
        cellLikeButton.isHidden = true
        cellImage.addLayerLoading(radius: cellImage.layer.cornerRadius)
    }
    
    func stopAnimation() {
        cellDateLabel.isHidden = false
        cellLikeButton.isHidden = false
        cellImage.removeLayerLoading()
    }
}
