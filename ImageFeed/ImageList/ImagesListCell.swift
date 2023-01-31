//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Егор Свистушкин on 28.01.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet var CellDateLabel: UILabel!
    @IBOutlet var CellImage: UIImageView!
    @IBOutlet var CellLikeButton: UIButton!
    
    // MARK: - Properties (var & let)
    static let reuseIdentifier = "ImagesListCell"
    
    
    // MARK: - Actions (IBActions)

    
    
    // MARK: - Functions

//    func addGradient () {
//        let height: CGFloat = 30
//        let gradient = CAGradientLayer()
//
//        gradient.frame = CGRect(x: 0, y: CellImage.bounds.height - height, width: CellImage.bounds.width , height: height)
//
//        let topColor = UIColor.init(white: 0, alpha: 0)
//        let botomColor = UIColor.init(white: 0, alpha: 1)
//        gradient.colors = [topColor.cgColor, botomColor.cgColor]
//
//        gradient.locations = [0, 1]
//
//        CellImage.layer.addSublayer(gradient)
//    }

}
