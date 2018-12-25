//
//  AccountHeader.swift
//  smokeroom
//
//  Created by Austin Kim on 12/18/18.
//  Copyright © 2018 Austin Kim. All rights reserved.
//

import UIKit

class AccountHeader: UICollectionViewCell {
    
    let namelabel: UILabel = {
        let label = UILabel()
        label.text = "Jungle Animal"
        label.textAlignment = .center
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 20.0)
        return label
    }()
    
    let usernamelabel: UILabel = {
        let label = UILabel()
        label.text = "@kimboss"
        label.textAlignment = .center
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 14.0)
        label.textColor = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1.0)
        return label
    }()
    
    let profile: UIImageView = {
        let imageview = UIImageView(image: #imageLiteral(resourceName: "profile_image"))
        imageview.layer.cornerRadius = 50
        imageview.clipsToBounds = true
        return imageview
    }()
    
    let friendRequestButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0/255, green: 154/255, blue: 237/255, alpha: 1.0)
        button.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 17)!
        button.setTitle("Friend Request", for: .normal)
        button.layer.cornerRadius = 6
        return button
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        addSubview(profile)
        addSubview(namelabel)
        addSubview(usernamelabel)
        addSubview(friendRequestButton)

        profile.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 20, leftConstant: (frame.size.width/2)-50, bottomConstant: 0, rightConstant: (frame.size.width/2)-50, widthConstant: 100, heightConstant: 100)
        namelabel.anchor(profile.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 35)
        usernamelabel.anchor(namelabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        friendRequestButton.anchor(usernamelabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 5, leftConstant: (frame.size.width/2)-70, bottomConstant: 0, rightConstant: (frame.size.width/2)-70, widthConstant: 100, heightConstant: 30)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
}
