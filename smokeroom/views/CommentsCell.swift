//
//  CommentsCell.swift
//  smokeroom
//
//  Created by Austin Kim on 6/24/18.
//  Copyright © 2018 Austin Kim. All rights reserved.
//

import UIKit

class CommentsCell: UICollectionViewCell {
    
    let profile: UIButton = {
        let button = UIButton()
        button.setImage( #imageLiteral(resourceName: "avatar"), for: .normal)
        return button
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Austin Kim"
        label.backgroundColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "@kimboss"
        label.backgroundColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1.0)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "5/19/18"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1.0)
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()
    
    let textLabel: UITextView = {
        let textView = UITextView()
        textView.text = "How many comments does the top of the this post deserve now that the penthouse monkeys arent here. Now we got penthouse tigers. "
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 17.0)
        textView.textColor = .black
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        addSubview(profile)
        addSubview(nameLabel)
        addSubview(usernameLabel)
        addSubview(dateLabel)
        addSubview(textLabel)
        dateLabel.anchor(topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 80, heightConstant: 35)
        profile.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 3, leftConstant: 15, bottomConstant: 0, rightConstant: 0, widthConstant: 65, heightConstant: 65)
        nameLabel.anchor(topAnchor, left: profile.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 35)
        usernameLabel.anchor(topAnchor, left: nameLabel.rightAnchor, bottom: nil, right: dateLabel.leftAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 35)
        textLabel.anchor(nameLabel.bottomAnchor, left: profile.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
    }

    
    
}
