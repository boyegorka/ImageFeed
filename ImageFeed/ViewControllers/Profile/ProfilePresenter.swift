//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Егор Свистушкин on 22.05.2023.
//

import UIKit
import Kingfisher

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerDelegate? { get }
    func setupData()
    func updateAvatar()
    func viewDidLoad()
    func logOut()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileViewControllerDelegate?
    private let service = ProfileService.shared
    
    func viewDidLoad() {
        NotificationCenter.default
            .addObserver(forName: ProfileImageService.didChangeProfileImageNotification, object: nil, queue: .main) { [weak self] _ in
                guard let self = self else { return }
                view?.stopAnimation()
                self.updateAvatar()
            }
        //setupData()
        setDefaultData()
    }
    
    func logOut() {
        service.logOut()
    }
    
    func setupData() {
        view?.stopAnimation()
        updateAvatar()
        view?.profileName.text = service.savedProfile?.name
        view?.profileNickname.text = service.savedProfile?.loginName
        view?.profileStatus.text = service.savedProfile?.bio
        view?.profileLogOutButton.isHidden = false
    }
    
    func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.profileImageURL,
            let urlImage = URL(string: profileImageURL)
        else { return }
        
        let processor = RoundCornerImageProcessor(cornerRadius: 60)
        view?.profileImage.kf.setImage(with: urlImage,
                                       placeholder: UIImage(systemName: "person.crop.circle.fill"),
                                       options: [.processor(processor),
                                                 .cacheSerializer(FormatIndicatedCacheSerializer.png)])
    }
    
    func setDefaultData() {
        view?.profileName.text = "Фамилия Имя Отчество"
        view?.profileNickname.text = "Ваш nickname"
        view?.profileStatus.text = "Ваш статус"
    }
}
