//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Егор Свистушкин on 09.04.2023.
//

import Foundation

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    
    var completion: (() -> Void)
}
