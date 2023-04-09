//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Егор Свистушкин on 19.03.2023.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    private let oauth2Service = OAuth2Service()
    private let storage = OAuth2TokenStorage()
    private var alertPresenter: AlertPresenter = AlertPresenter()
    //private let profileService = ProfileService.shared
    //private let profileController = ProfileViewController()
    private var firstStart = true
    //private let authViewController = AuthViewController()
    
    private lazy var splashScreenImage: UIImageView = {
        let splashScreenImage = UIImageView()
        view.addSubview(splashScreenImage)
        splashScreenImage.tintColor = .gray
        splashScreenImage.translatesAutoresizingMaskIntoConstraints = false
        splashScreenImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        splashScreenImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return splashScreenImage
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter.viewController = self
        setupScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkFirstStart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func presentAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let authViewController = storyboard.instantiateViewController(
            withIdentifier: "AuthViewController"
        ) as? AuthViewController else { return }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        self.present(authViewController, animated: true)
    }
    
    private func setupScreen() {
        splashScreenImage.image = UIImage(named: "Vector")
        view.backgroundColor = UIColor(named: "ypBlack")
    }
    
    private func checkFirstStart() {
        guard firstStart else { return }
        firstStart = false
        if storage.token != nil {
            fetchProfile()
        } else {
            presentAuthViewController()
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {

    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
            
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        UIBlockingProgressHUD.show()
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success:
                self.fetchProfile()
            case .failure:
                let viewModel = AlertModel(title: "Что-то пошло не так", message: "Не удалось войти в систему", buttonText: "OK") { [weak self] in
                    guard let self = self else { return }
                    self.presentAuthViewController()
                }
                alertPresenter.show(result: viewModel)
                
            }
        }
    }
    
    private func fetchProfile() {
        let profileService = ProfileService.shared
        profileService.fetchProfile(completion: { [weak self] result  in
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(_):
                ProfileImageService.shared.fetchProfileImageURL(username: profileService.savedProfile?.username ?? "") { _ in }
                self?.switchToTabBarController()
            case .failure(let error):
                print(error)
                self?.presentAuthViewController()
            }
        })
    }
}
