//
//  FriendsCell.swift
//  smokeroom
//
//  Created by Austin Kim on 6/20/18.
//  Copyright © 2018 Austin Kim. All rights reserved.
//


import UIKit

class FriendsCell: UICollectionViewCell {
    
    
    let nameButton: UIButton = {
        let button = UIButton()
        button.setTitle("Austin Kim", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let usernameButton: UIButton = {
        let button = UIButton()
        button.setTitle("@kimbossthunder", for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.black, for: .normal)
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
        addSubview(nameButton)
        addSubview(usernameButton)
        addSubview((rightArrow))
        nameButton.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 150, heightConstant: 0)
        usernameButton.anchor(topAnchor, left: nameButton.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        rightArrow.anchor(topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        backgroundColor = .white
        
    }
    
    
    
}
