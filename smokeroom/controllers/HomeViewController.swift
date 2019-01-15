//
//  HomeViewController.swift
//  smokeroom
//
//  Created by Austin Kim on 5/30/18.
//  Copyright © 2018 Austin Kim. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    

    // Child View Controllers --------------------
    lazy var accountVC: AccountViewController = {
        let vc = AccountViewController()
        vc.accountid = Auth.auth().currentUser?.uid
        return vc
    }()
    
    lazy var notificationsVC: NotificationsViewController = {
        let vc = NotificationsViewController()
        return vc
    }()
    
    lazy var roomsVC: RoomsViewController = {
        let vc = RoomsViewController()
        return vc
    }()
    
    lazy var settingVC: SettingViewController = {
        let view = SettingViewController()
        return view
    }()
    
    lazy var friendsVC: FriendsViewController = {
       let view = FriendsViewController()
        return view
    }()
    
    let titleImageView: UIImageView = {
        let imageView =  UIImageView(image: #imageLiteral(resourceName: "logo"))
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Smokeroom"
        label.font = UIFont.systemFont(ofSize: 30.0)
        label.textAlignment = .center
        return label
    }()
    
    let roomsButton: UIButton = {
       let button = UIButton()
        button.setTitle("News Feed", for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)!
        button.backgroundColor = .green
        button.addTarget(self, action: #selector(roomsButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    let settingsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Settings", for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)!
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(settingsButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    let friendsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Friends", for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)!
        button.backgroundColor = .purple
        button.addTarget(self, action: #selector(friendsButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    let accountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Account", for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)!
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(accountButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    let notificationsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Notifications", for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)!
        button.backgroundColor = .yellow
        button.addTarget(self, action: #selector(notificationsButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(titleImageView)
        view.addSubview(titleLabel)
        view.addSubview(roomsButton)
        view.addSubview(settingsButton)
        view.addSubview(friendsButton)
        view.addSubview(accountButton)
        view.addSubview(notificationsButton)
        titleImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 50, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: view.frame.height/9)
        titleLabel.anchor(titleImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: view.frame.height/9)
        roomsButton.anchor(titleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: view.frame.height/9)
        settingsButton.anchor(roomsButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: view.frame.height/9)
        friendsButton.anchor(settingsButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: view.frame.height/9)
        accountButton.anchor(friendsButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: view.frame.height/9)
        notificationsButton.anchor(accountButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: view.frame.height/9)
    }
    
    
    @objc func roomsButtonAction(_ sender: UIButton!){
        self.present(roomsVC, animated: true, completion:  nil)
    }
    
    @objc func settingsButtonAction(_ sender: UIButton!){
        self.present(settingVC, animated: true, completion:  nil)
    }
    
    @objc func friendsButtonAction(_ sender: UIButton!){
        friendsVC.userid = Auth.auth().currentUser?.uid
        self.present(friendsVC, animated: true, completion:  nil)
    }
    
    @objc func accountButtonAction(_ sender: UIButton!){
        self.present(accountVC, animated: true, completion:  nil)
    }
    
    @objc func notificationsButtonAction(_ sender: UIButton!){
        self.present(notificationsVC, animated: true, completion:  nil)
    }
    
    /*
     func addAsChildVC(childVC: UIViewController) {
     addChildViewController(childVC)
     containerView.addSubview(childVC.view)
     childVC.view.frame = containerView.frame
     childVC.didMove(toParentViewController: self)
     } */
    
    
    
    
}
