//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Егор Свистушкин on 28.01.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet var сellDateLabel: UILabel!
    @IBOutlet var сellImage: UIImageView!
    @IBOutlet var сellLikeButton: UIButton!
    
    // MARK: - Properties (var & let)
    static let reuseIdentifier = "ImagesListCell"
    
    var gradient = CAGradientLayer()
    
    
    // MARK: - Actions (IBActions)

    
    
    // MARK: - Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let height: CGFloat = 30
        gradient.frame = CGRect(x: 0, y: frame.height - height - 4, width: frame.width , height: height)
    }

    func addGradient () {
        
        let gradient = CAGradientLayer()
        let topColor = UIColor.init(white: 0, alpha: 0)
        let botomColor = UIColor.init(white: 0, alpha: 1)
    
        gradient.colors = [topColor.cgColor, botomColor.cgColor]
        gradient.locations = [0, 1]
        
        self.gradient = gradient

        сellImage.layer.addSublayer(gradient)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        сellImage.image = nil
        сellDateLabel.text = nil
        сellLikeButton.setImage(UIImage(named: "LikeNoActive"), for: .normal)
        
    }

}
