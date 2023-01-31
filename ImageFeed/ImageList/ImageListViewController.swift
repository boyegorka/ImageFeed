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
        
        tableView.delegate = self
        tableView.dataSource = self
        
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    
    // MARK: - Actions (IBActions)
    
    
    // MARK: - Functions
    
    
//    func addGradient (image: UIImageView) {
//        let height: CGFloat = 30
//        let gradient = CAGradientLayer()
//
//        gradient.frame = CGRect(x: 0, y: image.bounds.height - height, width: image.bounds.width , height: height)
//
//        let topColor = UIColor.init(white: 0, alpha: 0)
//        let botomColor = UIColor.init(white: 0, alpha: 1)
//        gradient.colors = [topColor.cgColor, botomColor.cgColor]
//
//        gradient.locations = [0, 1]
//
//        image.layer.addSublayer(gradient)
//    }
    
    
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
        
        let imageInsets = UIEdgeInsets(top: 4, left: 14, bottom: 4, right: 14)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
}

extension ImageListViewController {
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        
        guard let image = UIImage(named: photosName[indexPath.row]) else { return }
        
        cell.CellImage.image = image
        cell.CellDateLabel.text = dateFormatter.string(from: Date())

        if indexPath.row % 2 == 0 {
            cell.CellLikeButton.setImage(UIImage(named: "LikeActive"), for: .normal)
        } else {
            cell.CellLikeButton.setImage(UIImage(named: "LikeNoActive"), for: .normal)
        }
        
        
//        Долго думал, почему у меня новый лайк с каждой прокруткой ставится, оказалось нужно условие else прописать, но я не совсем понимаю для чего оно?
//        Цифры по идее же с прокруткой не меняются, 16 остаётся 16, в какую сторону не крути
        
        
        
        
        
//        как можно исправить градиент? Я понимаю, что координаты в iOS идут с левого верхнего угла, но даже если я выставлю в y: "CellImage.bounds.height - height" оно не будет раотать
//        не смог найти, как его сделать, при чём его же нужно вынести из этого конфига, потому что при каждой прокрутке будет наслаиваться этот градиент, а с этим что-то делать надо
        
        
        
        //addGradient(image: cell.CellImage) <- эта функция прописана в этом классе
        
        
        //cell.addGradient() <- эта функция прописана в классе ячейки
        
    }
    
}
