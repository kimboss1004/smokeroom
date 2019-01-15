//
//  Cells.swift
//  smokeroom
//
//  Created by Austin Kim on 6/24/18.
//  Copyright © 2018 Austin Kim. All rights reserved.
//

import UIKit

class HeaderCell: UICollectionViewCell {
    
    let profile: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "profile_image")
        view.layer.cornerRadius = 32
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
        textView.font = UIFont.systemFont(ofSize: 20.0)
        textView.textColor = UIColor(red: 31.0/255.0, green: 111.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        textView.backgroundColor = .clear
        return textView
    }()
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let buzz: UILabel = {
        let label = UILabel()
        label.text = "Buzz: 0"
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
    
    let line: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(displayP3Red: 0.92, green: 0.91, blue: 0.91, alpha: 1.0)
        label.text = ""
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .left
        return label
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
        addSubview(imageView)
        addSubview(textLabel)
        addSubview(commentsIcon)
        addSubview(buzz)
        addSubview(line)
        dateLabel.anchor(topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 60, heightConstant: 35)
        profile.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 15, bottomConstant: 0, rightConstant: 0, widthConstant: 65, heightConstant: 65)
        nameLabel.anchor(topAnchor, left: profile.rightAnchor, bottom: nil, right: nil, topConstant: 5, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        commentsIcon.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: frame.size.width/2 - 20, bottomConstant: 10, rightConstant: 0, widthConstant: 40, heightConstant: 40)
        buzz.anchor(nil, left: commentsIcon.rightAnchor, bottom: commentsIcon.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 40)
        imageView.anchor(nil, left: leftAnchor, bottom: buzz.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        textLabel.anchor(nameLabel.bottomAnchor, left: profile.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        usernameLabel.anchor(nameLabel.topAnchor, left: nameLabel.rightAnchor, bottom: nil, right: dateLabel.leftAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        line.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 5)
    }
}
