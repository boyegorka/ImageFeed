//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Егор Свистушкин on 10.02.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    // MARK: - Properties (var & let)

    var image: UIImage!
    
    // MARK: - Outlets
    @IBOutlet var imageView: UIImageView!
    
    // MARK: - Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
