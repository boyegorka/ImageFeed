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
        let action = UIAlertAction(title: result.buttonText, style: .default) {_ in
            result.completion()
        }
        alert.view.accessibilityIdentifier = "Alert"
        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
    }
    
}
