//
//  UIView+Extension.swift
//  ImageFeed
//
//  Created by Егор Свистушкин on 13.05.2023.
//

import UIKit

extension UIView {
    
    static let nameLoadingLayer = "addLoadingAnimation"
    
    var layerLoading: CAGradientLayer? {
        layer.sublayers?.first(where: { $0.name == UIView.nameLoadingLayer }) as? CAGradientLayer
    }
    
    func addLayerLoading(radius: CGFloat) {
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: .zero, size: CGSize(width: frame.width, height: frame.height))
        gradient.locations = [0, 0.1, 0.3]
        gradient.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = radius
        gradient.masksToBounds = true
        layer.addSublayer(gradient)
        gradient.name = UIView.nameLoadingLayer

        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]
        gradient.add(gradientChangeAnimation, forKey: "locationsChange")
    }
    
    func removeLayerLoading() {
        layerLoading?.removeFromSuperlayer()
    }
    
    func updateLayerLoadingFrame() {
        layerLoading?.frame = CGRect(origin: .zero, size: CGSize(width: frame.width, height: frame.height))
    }
}
