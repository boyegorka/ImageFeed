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
        createProfileLogOutbutton()
    }
    
    func createProfileImage() {
        let profileImage = UIImageView(image: UIImage(named: "Photo"))
        view.addSubview(profileImage)
        profileImage.tintColor = .gray
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.heightAnchor.constraint(equalToConstant: 70).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        self.profileImage = profileImage
    }
    
    func createProfileName() {
        let profileName = UILabel()
        profileName.text = "Екатерина Новикова"
        view.addSubview(profileName)
        profileName.textColor = UIColor(named: "ypWhite")
        profileName.translatesAutoresizingMaskIntoConstraints = false
        profileName.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        profileName.topAnchor.constraint(equalTo: profileImage?.bottomAnchor ?? view.topAnchor, constant: 8).isActive = true
        profileName.leadingAnchor.constraint(equalTo: profileImage?.leadingAnchor ?? view.leadingAnchor).isActive = true
        self.profileName = profileName
    }
    
    func createProfileNickname() {
        let profileNickname = UILabel()
        profileNickname.text = "@ekaterina_nov"
        view.addSubview(profileNickname)
        profileNickname.textColor = UIColor(named: "ypGray")
        profileNickname.translatesAutoresizingMaskIntoConstraints = false
        profileNickname.topAnchor.constraint(equalTo: profileName?.bottomAnchor ?? view.topAnchor, constant: 8).isActive = true
        profileNickname.leadingAnchor.constraint(equalTo: profileName?.leadingAnchor ?? view.leadingAnchor).isActive = true
        self.profileNickname = profileNickname
    }
    
    func createProfileStatus() {
        let profileStatus = UILabel()
        profileStatus.text = "Hello, world!"
        view.addSubview(profileStatus)
        profileStatus.textColor = UIColor(named: "ypWhite")
        profileStatus.translatesAutoresizingMaskIntoConstraints = false
        profileStatus.topAnchor.constraint(equalTo: profileNickname?.bottomAnchor ?? view.topAnchor, constant: 8).isActive = true
        profileStatus.leadingAnchor.constraint(equalTo: profileNickname?.leadingAnchor ?? view.leadingAnchor).isActive = true
        self.profileStatus = profileStatus
    }
    
    func createProfileLogOutbutton() {
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
