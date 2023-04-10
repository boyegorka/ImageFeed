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
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        )
        imagesListViewController.tabBarItem = UITabBarItem(
            title: nil, image: UIImage(named: "ImageStackActive"), selectedImage: nil
        )
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: nil, image: UIImage(named: "ProfileActive"), selectedImage: nil
        )
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
