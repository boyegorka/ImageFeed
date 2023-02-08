//
//  ImageListViewController.swift
//  ImageFeed
//
//  Created by Егор Свистушкин on 23.01.2023.
//

import UIKit

class ImageListViewController: UIViewController {


    // MARK: - Outlets
    @IBOutlet private var tableView: UITableView!

    // MARK: - Properties (var & let)
    private let photosName: [String] = Array(0...20).map{ "\($0)" }
    
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
    }
    
    
    // MARK: - Actions (IBActions)
    
    
    // MARK: - Functions
    
    
}

    // MARK: - Extensions
extension ImageListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
}

extension ImageListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let image = UIImage(named: photosName[indexPath.row]) else { return 0 }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
}

extension ImageListViewController {
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.prepareForReuse()
        
        guard let image = UIImage(named: photosName[indexPath.row]) else { return }
        
        cell.сellImage.image = image
        cell.сellDateLabel.text = dateFormatter.string(from: Date())

        if indexPath.row % 2 == 0 {
            cell.сellLikeButton.setImage(UIImage(named: "LikeActive"), for: .normal)
        }
        
    }
    
}