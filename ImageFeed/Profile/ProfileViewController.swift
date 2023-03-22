//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Егор Свистушкин on 10.02.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Properties (var & let)

    private lazy var profileImage: UIImageView = {
        
        let profileImage = UIImageView()
        view.addSubview(profileImage)
        profileImage.tintColor = .gray
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
        return profileImage
    }()
    
    private lazy var profileName: UILabel = {
        let profileName = UILabel()
        view.addSubview(profileName)
        profileName.textColor = UIColor(named: "ypWhite")
        profileName.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        profileName.translatesAutoresizingMaskIntoConstraints = false
        profileName.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8).isActive = true
        profileName.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor).isActive = true
        return profileName
    }()
    
    private lazy var profileNickname: UILabel = {
        let profileNickname = UILabel()
        view.addSubview(profileNickname)
        profileNickname.textColor = UIColor(named: "ypGray")
        profileNickname.translatesAutoresizingMaskIntoConstraints = false
        profileNickname.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 8).isActive = true
        profileNickname.leadingAnchor.constraint(equalTo: profileName.leadingAnchor).isActive = true
        return profileNickname
    }()
    
    
    private lazy var profileStatus: UILabel = {
        let profileStatus = UILabel()
        view.addSubview(profileStatus)
        profileStatus.textColor = UIColor(named: "ypWhite")
        profileStatus.translatesAutoresizingMaskIntoConstraints = false
        profileStatus.topAnchor.constraint(equalTo: profileNickname.bottomAnchor , constant: 8).isActive = true
        profileStatus.leadingAnchor.constraint(equalTo: profileNickname.leadingAnchor ).isActive = true
        return profileStatus
    }()
    
    private lazy var profileLogOutButton: UIButton = {
        let profileLogOutButton = UIButton.systemButton(with: UIImage(systemName: "ipad.and.arrow.forward")!, target: self, action: #selector(Self.logOut))
        view.addSubview(profileLogOutButton)
        profileLogOutButton.tintColor = UIColor(named: "ypRed")
        profileLogOutButton.translatesAutoresizingMaskIntoConstraints = false
        profileLogOutButton.topAnchor.constraint(equalTo: profileImage.centerYAnchor ).isActive = true
        profileLogOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        return profileLogOutButton
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }
    
    // MARK: - Functions
    
    @objc
    private func logOut() {
        profileName.text = nil
        profileNickname.text = nil
        profileStatus.text = nil
        profileImage.image = UIImage(systemName: "person.crop.circle.fill")
        profileLogOutButton.isHidden = true
    }
    
    
    private func setupData() {
        profileImage.image = UIImage(named: "Photo")
        profileName.text = "Екатерина Новикова"
        profileNickname.text = "@ekaterina_nov"
        profileStatus.text = "Hello, world!"
        profileLogOutButton.isHidden = false
    }
}
