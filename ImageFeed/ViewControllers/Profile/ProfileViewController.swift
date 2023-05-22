//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Егор Свистушкин on 10.02.2023.
//

import UIKit
import Kingfisher

public protocol ProfileViewControllerDelegate: AnyObject {
    var presenter: ProfilePresenterProtocol? { get }
    var profileImage: UIImageView { get }
    var profileName: UILabel { get }
    var profileNickname: UILabel { get }
    var profileStatus: UILabel { get }
    var profileLogOutButton: UIButton { get }
    func stopAnimation()
}

final class ProfileViewController: UIViewController, ProfileViewControllerDelegate {
    
    // MARK: - Properties (var & let)
    
    var presenter: ProfilePresenterProtocol?
    
    lazy var profileImage: UIImageView = {
        let profileImage = UIImageView()
        view.addSubview(profileImage)
        profileImage.tintColor = .gray
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImage.heightAnchor.constraint(equalToConstant: 80),
            profileImage.widthAnchor.constraint(equalToConstant: 80),
            profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
        return profileImage
    }()
    
    lazy var profileName: UILabel = {
        let profileName = UILabel()
        view.addSubview(profileName)
        profileName.textColor = .ypWhite
        profileName.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        profileName.translatesAutoresizingMaskIntoConstraints = false
        profileName.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8).isActive = true
        profileName.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor).isActive = true
        return profileName
    }()
    
    lazy var profileNickname: UILabel = {
        let profileNickname = UILabel()
        view.addSubview(profileNickname)
        profileNickname.textColor = .ypGray
        profileNickname.translatesAutoresizingMaskIntoConstraints = false
        profileNickname.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 8).isActive = true
        profileNickname.leadingAnchor.constraint(equalTo: profileName.leadingAnchor).isActive = true
        return profileNickname
    }()
    
    lazy var profileStatus: UILabel = {
        let profileStatus = UILabel()
        view.addSubview(profileStatus)
        profileStatus.textColor = .ypWhite
        profileStatus.translatesAutoresizingMaskIntoConstraints = false
        profileStatus.topAnchor.constraint(equalTo: profileNickname.bottomAnchor , constant: 8).isActive = true
        profileStatus.leadingAnchor.constraint(equalTo: profileNickname.leadingAnchor ).isActive = true
        return profileStatus
    }()
    
    lazy var profileLogOutButton: UIButton = {
        let profileLogOutButton = UIButton.systemButton(with: UIImage(systemName: "ipad.and.arrow.forward")!, target: self, action: #selector(Self.buttonLogOutTouched))
        //  #selector(Self.logOut)   <----  предыдущее действие кнопки
        view.addSubview(profileLogOutButton)
        profileLogOutButton.tintColor = .ypRed
        profileLogOutButton.translatesAutoresizingMaskIntoConstraints = false
        profileLogOutButton.topAnchor.constraint(equalTo: profileImage.centerYAnchor ).isActive = true
        profileLogOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        return profileLogOutButton
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        
        presenter?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // В одном из спринтов мы вынесли загрузку профиля на Splash Screen, получается что профиль уже загружен, когда я перехожу на экран профиля, а код ниже для демонстрации работы анимации, в целом анимация тут лишняя. SetupData мы можем вызвать во ViewDidLoad
        startAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.presenter?.setupData()
        })
    }
    
    // MARK: - Functions
    
    @objc
    func buttonLogOutTouched() {
        presenter?.logOut()
    }
    
    private func startAnimation() {
        profileImage.addLayerLoading(radius: profileImage.frame.width/2)
        profileName.addLayerLoading(radius: profileName.frame.height/2)
        profileNickname.addLayerLoading(radius: profileNickname.frame.height/2)
        profileStatus.addLayerLoading(radius: profileStatus.frame.height/2)
    }
    
    func stopAnimation() {
        profileImage.removeLayerLoading()
        profileName.removeLayerLoading()
        profileNickname.removeLayerLoading()
        profileStatus.removeLayerLoading()
    }
}
