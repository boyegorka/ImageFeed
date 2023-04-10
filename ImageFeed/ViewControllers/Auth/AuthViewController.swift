//
//  authViewController.swift
//  ImageFeed
//
//  Created by Егор Свистушкин on 26.02.2023.
//

import UIKit


protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {

    // MARK: - Properties (var & let)

    private let showWebViewSegueIdentifier = "ShowWebView"
    let service = OAuth2Service()
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - Functions

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(showWebViewSegueIdentifier)")}
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func auth(code: String) {
        service.fetchOAuthToken(code, completion: { result in
            switch result {
            case .success(let token):
                print(token)
            case .failure(let error):
                print(error)
            }
        })
    }
}

// MARK: - Extensions

extension AuthViewController: WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
