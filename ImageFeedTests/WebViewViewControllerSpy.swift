//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Егор Свистушкин on 20.05.2023.
//

import Foundation
import ImageFeed

class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    
    var presenter: ImageFeed.WebViewPresenterProtocol?
    var loadRequestCalled: Bool = false
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ newValue: Bool) {
        
    }
}
