//
//  FriendRequestCell.swift
//  smokeroom
//
//  Created by Austin Kim on 12/24/18.
//  Copyright © 2018 Austin Kim. All rights reserved.
//

import UIKit

class FriendRequestCell: UICollectionViewCell {
    
    var userid: String!
    
    let profile: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "profile_image")
        view.layer.cornerRadius = 27
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    
    let usernameButton: UIButton = {
        let button = UIButton()
        button.setTitle("@placeholder", for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.black, for: .normal)
        button.contentVerticalAlignment = UIControlContentVerticalAlignment.bottom
        return button
    }()
    
    let nameButton: UIButton = {
        let button = UIButton()
        button.setTitle("Place holder", for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 15)!
        button.contentVerticalAlignment = UIControlContentVerticalAlignment.top
        return button
    }()
    
    let rightArrow: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "right"), for: .normal)
        return button
    }()
    
    let acceptFriendRequestButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 109/255, green: 237/255, blue: 126/255, alpha: 1.0)
        button.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 17)!
        button.setTitle("Accept Friend", for: .normal)
        button.layer.cornerRadius = 6
        return button
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        addSubview(profile)
        addSubview(nameButton)
        addSubview(usernameButton)
        addSubview(acceptFriendRequestButton)
        profile.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 80, heightConstant: 80)
        usernameButton.anchor(topAnchor, left: profile.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        nameButton.anchor(nil, left: usernameButton.leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        acceptFriendRequestButton.anchor(topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 10, rightConstant: 10, widthConstant: 140, heightConstant: 0)
        
        backgroundColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
}

