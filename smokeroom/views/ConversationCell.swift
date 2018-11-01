//
//  ConversationCell.swift
//  smokeroom
//
//  Created by Austin Kim on 5/30/18.
//  Copyright © 2018 Austin Kim. All rights reserved.
//

import UIKit

class ConversationCell: UICollectionViewCell {
    
    var detailStackView: UIStackView
    
    override init(frame: CGRect) {
        detailStackView = UIStackView()
        super.init(frame: frame)
        setupViews()
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let profile: UIButton = {
        let button = UIButton()
        button.setImage( #imageLiteral(resourceName: "whale"), for: .normal)
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
        label.numberOfLines = 0
        return label
    }()
    
    let dateLabel: UILabel = {
       let label = UILabel()
        label.text = "5/19/18"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1.0)
        label.numberOfLines = 0
        return label
    }()
    
    let textLabel: UIButton = {
        let textView = UIButton()
        textView.titleLabel?.numberOfLines = 0
        textView.setTitle("Lorem ipsum dolor sit amet, Lorem ipsum dolor sit amet.", for: .normal)
        textView.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        textView.contentHorizontalAlignment = .left
        textView.setTitleColor(UIColor(red: 31.0/255.0, green: 111.0/255.0, blue: 239.0/255.0, alpha: 1.0), for: .normal)
        textView.backgroundColor = .white
        textView.contentVerticalAlignment = UIControlContentVerticalAlignment.top
        return textView
    }()
    
    let buzz: UILabel = {
        let label = UILabel()
        label.text = "Buzz: 0"
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .left
        return label
    }()
    
    func setupViews(){
        addSubview(profile)
        addSubview(nameLabel)
        addSubview(dateLabel)
        addSubview(textLabel)
        addSubview(usernameLabel)
        dateLabel.anchor(topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 35)
        profile.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 15, bottomConstant: 0, rightConstant: 0, widthConstant: 65, heightConstant: 65)
        nameLabel.anchor(topAnchor, left: profile.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 35)
        usernameLabel.anchor(topAnchor, left: nameLabel.rightAnchor, bottom: nil, right: dateLabel.leftAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 35)
        setupBottomDetails()
        textLabel.anchor(nameLabel.bottomAnchor, left: profile.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
    }
    
    fileprivate func setupBottomDetails(){
        let buzzContainer = UIView()
        detailStackView = UIStackView(arrangedSubviews: [buzzContainer])
        detailStackView.axis = .horizontal
        detailStackView.distribution = .fillEqually
        
        addSubview(detailStackView)
        addSubview(buzz)
        
        detailStackView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 7, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        buzz.anchor(buzzContainer.topAnchor, left: buzzContainer.leftAnchor, bottom: nil, right: buzzContainer.rightAnchor, topConstant: 0, leftConstant: 90, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        
    }
    

}