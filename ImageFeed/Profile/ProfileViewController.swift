//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Егор Свистушкин on 10.02.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private var profileName: UILabel?
    private var profileImage: UIImageView?
    private var profileNickname: UILabel?
    private var profileStatus: UILabel?
    private var profileLogOutButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createProfileImage()
        createProfileName()
        createProfileNickname()
        createProfileStatus()
        createProfileLogOutButton()
    }
    
    private func createProfileImage() {
        let profileImage = UIImageView(image: UIImage(named: "Photo"))
        view.addSubview(profileImage)
        profileImage.tintColor = .gray
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
        self.profileImage = profileImage
    }
    
    private func createProfileName() {
        let profileName = UILabel()
        view.addSubview(profileName)
        profileName.text = "Екатерина Новикова"
        profileName.textColor = UIColor(named: "ypWhite")
        profileName.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        profileName.translatesAutoresizingMaskIntoConstraints = false
        profileName.topAnchor.constraint(equalTo: profileImage?.bottomAnchor ?? view.topAnchor, constant: 8).isActive = true
        profileName.leadingAnchor.constraint(equalTo: profileImage?.leadingAnchor ?? view.leadingAnchor).isActive = true
        self.profileName = profileName
    }
    
    private func createProfileNickname() {
        let profileNickname = UILabel()
        view.addSubview(profileNickname)
        profileNickname.text = "@ekaterina_nov"
        profileNickname.textColor = UIColor(named: "ypGray")
        profileNickname.translatesAutoresizingMaskIntoConstraints = false
        profileNickname.topAnchor.constraint(equalTo: profileName?.bottomAnchor ?? view.topAnchor, constant: 8).isActive = true
        profileNickname.leadingAnchor.constraint(equalTo: profileName?.leadingAnchor ?? view.leadingAnchor).isActive = true
        self.profileNickname = profileNickname
    }
    
    private func createProfileStatus() {
        let profileStatus = UILabel()
        view.addSubview(profileStatus)
        profileStatus.text = "Hello, world!"
        profileStatus.textColor = UIColor(named: "ypWhite")
        profileStatus.translatesAutoresizingMaskIntoConstraints = false
        profileStatus.topAnchor.constraint(equalTo: profileNickname?.bottomAnchor ?? view.topAnchor, constant: 8).isActive = true
        profileStatus.leadingAnchor.constraint(equalTo: profileNickname?.leadingAnchor ?? view.leadingAnchor).isActive = true
        self.profileStatus = profileStatus
    }
    
    private func createProfileLogOutButton() {
        let profileLogOutButton = UIButton.systemButton(with: UIImage(systemName: "ipad.and.arrow.forward")!, target: self, action: #selector(Self.logOut))
        view.addSubview(profileLogOutButton)
        profileLogOutButton.tintColor = UIColor(named: "ypRed")
        profileLogOutButton.translatesAutoresizingMaskIntoConstraints = false
        profileLogOutButton.topAnchor.constraint(equalTo: profileImage?.centerYAnchor ?? view.centerYAnchor).isActive = true
        profileLogOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        self.profileLogOutButton = profileLogOutButton
    }
    
    @objc
    private func logOut() {
        profileName?.removeFromSuperview()
        profileNickname?.removeFromSuperview()
        profileStatus?.removeFromSuperview()
        profileImage?.image = UIImage(systemName: "person.crop.circle.fill")
        profileName = nil
        profileNickname = nil
        profileStatus = nil

    }
    
}
