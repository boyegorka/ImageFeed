//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Егор Свистушкин on 06.04.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let imageList = getImageListViewController() {
            self.viewControllers = [imageList, getProfileViewController()]
        }
    }
    
    func getImageListViewController() -> ImageListViewController? {
        let imagesListViewController = storyboard?.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        ) as? ImageListViewController
        
        let presenter = ImageListPresenter()
        
        presenter.view = imagesListViewController
        
        imagesListViewController?.presenter = presenter
        
        imagesListViewController?.tabBarItem = UITabBarItem(
            title: nil, image: UIImage(named: "ImageStackActive"), selectedImage: nil
        )
        return imagesListViewController
    }
    
    func getProfileViewController() -> ProfileViewController {
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: nil, image: UIImage(named: "ProfileActive"), selectedImage: nil
        )
        return profileViewController
    }
}
