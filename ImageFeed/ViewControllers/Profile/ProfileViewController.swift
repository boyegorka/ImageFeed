//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Егор Свистушкин on 10.02.2023.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    // MARK: - Properties (var & let)
    
    private let service = ProfileService.shared
    
    private lazy var profileImage: UIImageView = {
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
    
    private lazy var profileName: UILabel = {
        let profileName = UILabel()
        view.addSubview(profileName)
        profileName.textColor = .ypWhite
        profileName.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        profileName.translatesAutoresizingMaskIntoConstraints = false
        profileName.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8).isActive = true
        profileName.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor).isActive = true
        return profileName
    }()
    
    private lazy var profileNickname: UILabel = {
        let profileNickname = UILabel()
        view.addSubview(profileNickname)
        profileNickname.textColor = .ypGray
        profileNickname.translatesAutoresizingMaskIntoConstraints = false
        profileNickname.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 8).isActive = true
        profileNickname.leadingAnchor.constraint(equalTo: profileName.leadingAnchor).isActive = true
        return profileNickname
    }()
    
    private lazy var profileStatus: UILabel = {
        let profileStatus = UILabel()
        view.addSubview(profileStatus)
        profileStatus.textColor = .ypWhite
        profileStatus.translatesAutoresizingMaskIntoConstraints = false
        profileStatus.topAnchor.constraint(equalTo: profileNickname.bottomAnchor , constant: 8).isActive = true
        profileStatus.leadingAnchor.constraint(equalTo: profileNickname.leadingAnchor ).isActive = true
        return profileStatus
    }()
    
    private lazy var profileLogOutButton: UIButton = {
        let profileLogOutButton = UIButton.systemButton(with: UIImage(systemName: "ipad.and.arrow.forward")!, target: self, action: #selector(Self.logOut))
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
        
        NotificationCenter.default
            .addObserver(forName: ProfileImageService.didChangeProfileImageNotification, object: nil, queue: .main) { [weak self] _ in
                guard let self = self else { return }
                stopAnimation()
                self.updateAvatar()
            }
        //setupData()
        setDefaultData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // В одном из спринтов мы вынесли загрузку профиля на Splash Screen, получается что профиль уже загружен, когда я перехожу на экран профиля, а код ниже для демонстрации работы анимации, в целом анимация тут лишняя. SetupData мы можем вызвать во ViewDidLoad
        startAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.setupData()
        })
    }
    
    // MARK: - Functions
    
    @objc
    private func logOut() {
        service.logOut()
    }
    
    func setupData() {
        stopAnimation()
        updateAvatar()
        profileName.text = service.savedProfile?.name
        profileNickname.text = service.savedProfile?.loginName
        profileStatus.text = service.savedProfile?.bio
        profileLogOutButton.isHidden = false
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.profileImageURL,
            let urlImage = URL(string: profileImageURL)
        else { return }
        
        let processor = RoundCornerImageProcessor(cornerRadius: 60)
        profileImage.kf.setImage(with: urlImage,
                                 placeholder: UIImage(systemName: "person.crop.circle.fill"),
                                 options: [.processor(processor),
                                           .cacheSerializer(FormatIndicatedCacheSerializer.png)])
    }
    
    func setDefaultData() {
        profileName.text = "Фамилия Имя Отчество"
        profileNickname.text = "Ваш nickname"
        profileStatus.text = "Ваш статус"
    }
    
    private func startAnimation() {
        profileImage.addLayerLoading(radius: profileImage.frame.width/2)
        profileName.addLayerLoading(radius: profileName.frame.height/2)
        profileNickname.addLayerLoading(radius: profileNickname.frame.height/2)
        profileStatus.addLayerLoading(radius: profileStatus.frame.height/2)
    }
    
    private func stopAnimation() {
        profileImage.removeLayerLoading()
        profileName.removeLayerLoading()
        profileNickname.removeLayerLoading()
        profileStatus.removeLayerLoading()
    }
}
