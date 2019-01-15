//
//  NotificationCell.swift
//  smokeroom
//
//  Created by Austin Kim on 1/6/19.
//  Copyright © 2019 Austin Kim. All rights reserved.
//

import Foundation
import UIKit

class NotificationCell: UICollectionViewCell {
    
    let profile: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "profile_image")
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let textButton: UIButton = {
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
    
    let dateButton: UIButton = {
        let button = UIButton()
        button.setTitle("datelabel", for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 15)!
        button.contentVerticalAlignment = UIControlContentVerticalAlignment.top
        button.titleLabel?.numberOfLines = 0
        return button
    }()
    
    let iconButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "friends"), for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 15)!
        button.contentVerticalAlignment = UIControlContentVerticalAlignment.top
        button.titleLabel?.numberOfLines = 0
        return button
    }()
    
    let line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.9176, green: 0.9176, blue: 0.9176, alpha: 1.0)
        return view
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        addSubview(line)
        addSubview(profile)
        addSubview(textButton)
        addSubview(dateButton)
        addSubview(iconButton)
        line.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
//        profile.anchor(line.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 15, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 60)
        iconButton.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 5, leftConstant: 10, bottomConstant: 5, rightConstant: 0, widthConstant: 25, heightConstant: 25)
        dateButton.anchor(nil, left: iconButton.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 35)
        textButton.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 12, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        backgroundColor = .white
    }
    
    
    
}
