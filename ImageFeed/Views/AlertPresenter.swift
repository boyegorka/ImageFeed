//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Егор Свистушкин on 09.04.2023.
//

import UIKit

final class AlertPresenter {
    
    weak var viewController: UIViewController?
    
    init(delegate: UIViewController? = nil) {
        self.viewController = delegate
    }
    
    func show(result: AlertModel) {
        let alert = UIAlertController(title: result.title, message: result.message, preferredStyle: .alert)
        
        for action in result.actions {
            alert.addAction(action)
        }
        
        viewController?.present(alert, animated: true, completion: nil)
    }
}
