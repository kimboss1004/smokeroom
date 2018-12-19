//
//  FriendsCell.swift
//  smokeroom
//
//  Created by Austin Kim on 6/20/18.
//  Copyright © 2018 Austin Kim. All rights reserved.
//


import UIKit

class FriendsCell: UICollectionViewCell {
    
    let profile: UIButton = {
        let button = UIButton()
        button.setImage( #imageLiteral(resourceName: "profile_image"), for: .normal)
        return button
    }()
    
    let usernameButton: UIButton = {
        let button = UIButton()
        button.setTitle("@kimbossthunder", for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.black, for: .normal)
        button.contentVerticalAlignment = UIControlContentVerticalAlignment.bottom
        return button
    }()
    
    let nameButton: UIButton = {
        let button = UIButton()
        button.setTitle("Austin Kim", for: .normal)
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        addSubview(profile)
        addSubview(nameButton)
        addSubview(usernameButton)
        addSubview((rightArrow))
        profile.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 80, heightConstant: 80)
        usernameButton.anchor(topAnchor, left: profile.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        nameButton.anchor(nil, left: usernameButton.leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        rightArrow.anchor(topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        backgroundColor = .white
        
    }
    
    
    
}
