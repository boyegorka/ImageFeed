//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Егор Свистушкин on 26.02.2023.
//

import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ newValue: Bool)
}

final class WebViewViewController: UIViewController, WebViewViewControllerProtocol {
    
    // MARK: - Outlets
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    
    // MARK: - Properties (var & let)
    
    weak var delegate: WebViewViewControllerDelegate?
    private var estimatedProgressObservation: NSKeyValueObservation?
    var presenter: WebViewPresenterProtocol?
    private let UnsplashWebViewAccessibilityIdentifier = "UnsplashWebView"
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        estimatedProgressObservation = webView.observe(\.estimatedProgress,options: [] ,changeHandler: { [weak self] _, _ in
            guard let self = self else { return }
            presenter?.didUpdateProgressValue(webView.estimatedProgress)
        })
        
        webView.accessibilityIdentifier = UnsplashWebViewAccessibilityIdentifier
        
        webView.navigationDelegate = self
        presenter?.viewDidLoad()
    }
    
    // MARK: - Actions (IBActions)
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    // MARK: - Functions
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ newValue: Bool) {
        progressView.isHidden = newValue
    }
}


    // MARK: - Extensions

extension WebViewViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from:navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    }
}
