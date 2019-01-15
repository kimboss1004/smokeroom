//
//  ConversationCell.swift
//  smokeroom
//
//  Created by Austin Kim on 5/30/18.
//  Copyright © 2018 Austin Kim. All rights reserved.
//

import UIKit

class ConversationCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let profile: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "profile_image")
        view.layer.cornerRadius = 27
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        view.contentMode = .scaleAspectFill
        return view
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
        label.textAlignment = .right
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
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let imageButton: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        return button
    }()
    
    let buzz: UILabel = {
        let label = UILabel()
        label.text = "label"
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = UIColor(red: 31.0/255.0, green: 111.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        label.baselineAdjustment = .alignCenters
        return label
    }()
    
    let commentsIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "comments.png")
        return view
    }()
    
    let line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.9176, green: 0.9176, blue: 0.9176, alpha: 1.0)
        return view
    }()
    
    @objc func imageClickedAction(_ sender:UIImageView!) {
        print("Fuck")
    }
    
    func setupViews(){
        addSubview(profile)
        addSubview(nameLabel)
        addSubview(dateLabel)
        addSubview(textLabel)
        addSubview(imageView)
        addSubview(imageButton)
        addSubview(usernameLabel)
        addSubview(buzz)
        addSubview(commentsIcon)
        addSubview(line)
        dateLabel.anchor(topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 70, heightConstant: 35)
        profile.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 55, heightConstant: 55)
        nameLabel.anchor(topAnchor, left: profile.rightAnchor, bottom: nil, right: nil, topConstant: 5, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        usernameLabel.anchor(topAnchor, left: nameLabel.rightAnchor, bottom: nil, right: dateLabel.leftAnchor, topConstant: 5, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        textLabel.anchor(nameLabel.bottomAnchor, left: profile.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        imageView.anchor(nil, left: leftAnchor, bottom: buzz.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        imageButton.anchor(imageView.topAnchor, left: imageView.leftAnchor, bottom: imageView.bottomAnchor, right: imageView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        commentsIcon.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: frame.size.width/2 - 20, bottomConstant: 10, rightConstant: 0, widthConstant: 40, heightConstant: 40)
        buzz.anchor(nil, left: commentsIcon.rightAnchor, bottom: commentsIcon.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 40)
        line.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
    }
    

}
