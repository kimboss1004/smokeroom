//
//  SettingViewController.swift
//  smokeroom
//
//  Created by Austin Kim on 6/12/18.
//  Copyright © 2018 Austin Kim. All rights reserved.
//

import UIKit


class SettingViewController: UIViewController {
    
    let settingsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 25)
        label.text = "Settings"
        label.textAlignment = .center
        return label
    }()
    
    var nameTextField: UITextField = {
        let textView = UITextField()
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 5
        textView.font = UIFont(name: "Apple SD Gothic Neo", size: 20)
        textView.text = "Austin"
        return textView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 18)
        label.text = "Name"
        return label
    }()
    
    var lastNameTextField: UITextField = {
        let textView = UITextField()
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 5
        textView.font = UIFont(name: "Apple SD Gothic Neo", size: 20)
        textView.text = "Kim"
        return textView
    }()
    
    let lastNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 18)
        label.text = "Last Name"
        return label
    }()
    
    var usernameTextField: UITextField = {
        let textView = UITextField()
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 5
        textView.font = UIFont(name: "Apple SD Gothic Neo", size: 20)
        textView.text = "Kimboss1004"
        return textView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 18)
        label.text = "Username"
        return label
    }()
    
    var ghostnameTextField: UITextField = {
        let textView = UITextField()
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 5
        textView.font = UIFont(name: "Apple SD Gothic Neo", size: 20)
        textView.text = "ghostin1004"
        return textView
    }()
    
    let ghostnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 18)
        label.text = "Ghostname"
        return label
    }()
    
    var passwordTextField: UITextField = {
        let textView = UITextField()
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 5
        textView.font = UIFont(name: "Apple SD Gothic Neo", size: 20)
        textView.text = "********"
        return textView
    }()
    
    let passwordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 18)
        label.text = "Password"
        return label
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red:0.23, green:0.88, blue:0.23, alpha:1.0)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)!
        button.setTitle("Save Changes", for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "left"), for: .normal)
        button.addTarget(self, action: #selector(dismissButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    let postButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red:0.23, green:0.88, blue:0.23, alpha:1.0)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)!
        button.setTitle("Post it!", for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0.90, green:0.94, blue:0.99, alpha:1.0)
        view.addSubview(dismissButton)
        view.addSubview(settingsLabel)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(lastNameLabel)
        view.addSubview(lastNameTextField)
        view.addSubview(usernameLabel)
        view.addSubview(usernameTextField)
        view.addSubview(ghostnameLabel)
        view.addSubview(ghostnameTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(saveButton)
        

        dismissButton.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 25, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        settingsLabel.anchor(dismissButton.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        nameLabel.anchor(settingsLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 50, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 70, heightConstant: 50)
        nameTextField.anchor(nameLabel.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 130, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        lastNameLabel.anchor(nameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 50)
        lastNameTextField.anchor(nameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 130, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        usernameLabel.anchor(lastNameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 50)
        usernameTextField.anchor(lastNameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 130, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        ghostnameLabel.anchor(usernameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 50)
        ghostnameTextField.anchor(usernameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 130, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        passwordLabel.anchor(ghostnameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 50)
        passwordTextField.anchor(ghostnameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 130, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        saveButton.anchor(passwordLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 35, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)
    }
    
    
    @objc func dismissButtonAction(_ sender:UIButton!){
        dismiss(animated: true, completion: nil)
    }
    
}
