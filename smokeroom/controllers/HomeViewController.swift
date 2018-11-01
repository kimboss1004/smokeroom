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
    
    // NAVIGATION -------------------------------
    
    
    // Child View Controllers --------------------
    lazy var accountVC: AccountViewController = {
        let vc = AccountViewController()
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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(titleImageView)
        view.addSubview(titleLabel)
        view.addSubview(roomsButton)
        titleImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 50, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 100)
        titleLabel.anchor(titleImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        roomsButton.anchor(titleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 100)
    }
    
    
    @objc func roomsButtonAction(_ sender: UIButton!){
        self.present(roomsVC, animated: true, completion:  nil)
    }
    
    /*
     func addAsChildVC(childVC: UIViewController) {
     addChildViewController(childVC)
     containerView.addSubview(childVC.view)
     childVC.view.frame = containerView.frame
     childVC.didMove(toParentViewController: self)
     } */
    
    
    
    
}