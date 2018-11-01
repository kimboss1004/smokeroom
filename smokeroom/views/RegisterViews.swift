//
//  RegisterViews.swift
//  smokeroom
//
//  Created by Austin Kim on 6/30/18.
//  Copyright © 2018 Austin Kim. All rights reserved.
//

import UIKit




class IntroView: UIView {
    
    weak var delegate : RegisterViewController? = nil
    
    let logoImage: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "SmokeRoom"
        label.textColor = .white
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 30)
        return label
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("LOG IN", for: .normal)
        button.backgroundColor = UIColor(red: 46/255, green: 213/255, blue: 115/255, alpha: 1.0)
        // (red: 46/255, green: 213/255, blue: 115/255, alpha: 1.0)
        //(red: 252/255, green: 0/255, blue: 12/255, alpha: 1.0)
        button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 28)!
        button.addTarget(self, action: #selector(loginButtonViewAction(_:)), for: .touchUpInside)
        return button
    }()
    
    let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("SIGN UP", for: .normal)
        button.backgroundColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1.0)
        button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 28)!
        button.addTarget(self, action: #selector(registerButtonAction(_:)), for: .touchUpInside)
        return button
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(logoImage)
        addSubview(registerButton)
        addSubview(loginButton)
        backgroundColor = .white
        logoImage.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 120, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 200, heightConstant: 200)
        registerButton.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 110)
        loginButton.anchor(nil, left: leftAnchor, bottom: registerButton.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 110)

    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func loginButtonViewAction(_ sender:UIButton!){
        delegate?.loginButtonViewAction(sender)
    }
    
    @objc func registerButtonAction(_ sender:UIButton!){
        delegate?.registerButtonAction(sender)
    }
    
    
}





class NameView: UIView {
    
    weak var delegate : RegisterViewController? = nil
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "What's your name?"
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let firstNameLabel: UILabel = {
        let label = UILabel()
        label.text = "First Name"
        label.textColor = UIColor(red:0.31, green:0.65, blue:0.96, alpha:1.0)
        label.textAlignment = .center
        return label
    }()
    
    let lastNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Last Name"
        label.textColor = UIColor(red:0.31, green:0.65, blue:0.96, alpha:1.0)
        label.textAlignment = .center
        return label
    }()
    
    let firstTextField: UITextField = {
        let tf = UITextField()
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        return tf
    }()
    
    let lastTextField: UITextField = {
        let tf = UITextField()
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        return tf
    }()
    
    let firstUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.82, green:0.82, blue:0.82, alpha:1.0)
        return view
    }()
    
    let lastUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.82, green:0.82, blue:0.82, alpha:1.0)
        return view
    }()
    
    let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.backgroundColor = UIColor(red:0.11, green:0.73, blue:1.00, alpha:1.0)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(nameContinueButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "left"), for: .normal)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(nameBackButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(firstNameLabel)
        addSubview(lastNameLabel)
        addSubview(firstTextField)
        addSubview(lastTextField)
        addSubview(firstUnderline)
        addSubview(lastUnderline)
        addSubview(continueButton)
        addSubview(backButton)
        backgroundColor = .white
        
        
        backButton.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 25, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        titleLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 150, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        firstNameLabel.anchor(titleLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 0, widthConstant: 150, heightConstant: 30)
        firstTextField.anchor(firstNameLabel.bottomAnchor, left: firstNameLabel.leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
        firstUnderline.anchor(firstTextField.bottomAnchor, left: firstTextField.leftAnchor, bottom: nil, right: firstTextField.rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 1)
        lastNameLabel.anchor(firstUnderline.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 30, bottomConstant: 0, rightConstant: 0, widthConstant: 150, heightConstant: 30)
        lastTextField.anchor(lastNameLabel.bottomAnchor, left: lastNameLabel.leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
        lastUnderline.anchor(lastTextField.bottomAnchor, left: lastTextField.leftAnchor, bottom: nil, right: lastTextField.rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 1)
        continueButton.anchor(lastUnderline.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 50, leftConstant: 50, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func nameBackButtonAction(_ sender:UIButton!){
        delegate?.nameBackButtonAction(sender)
        
    }
    
    @objc func nameContinueButtonAction(_ sender:UIButton!){
        if(firstTextField.text == "" || lastTextField.text == "") {
            Helper.shared.showOKAlert(title: "Invalid", message: "Please enter first & last name", viewController: delegate!)
        }
        else{
            delegate?.firstname = firstTextField.text
            delegate?.lastname = lastTextField.text
            delegate?.nameContinueButtonAction(sender)
        }
    }
    
    
}


// -------------------------------------------------------------------------

class UsernameView: UIView {
 
    weak var delegate : RegisterViewController? = nil
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.textColor = UIColor(red:0.31, green:0.65, blue:0.96, alpha:1.0)
        label.textAlignment = .center
        return label
    }()
    
    let firstTextField: UITextField = {
        let tf = UITextField()
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        return tf
    }()
    
    let firstUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.82, green:0.82, blue:0.82, alpha:1.0)
        return view
    }()
    
    let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.backgroundColor = UIColor(red:0.11, green:0.73, blue:1.00, alpha:1.0)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(usernameContinueButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "left"), for: .normal)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(usernameBackButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(usernameLabel)
        addSubview(firstTextField)
        addSubview(firstUnderline)
        addSubview(continueButton)
        addSubview(backButton)
        backgroundColor = .white
        
        
        backButton.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 25, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        titleLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 150, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        usernameLabel.anchor(titleLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 0, widthConstant: 150, heightConstant: 30)
        firstTextField.anchor(usernameLabel.bottomAnchor, left: usernameLabel.leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
        firstUnderline.anchor(firstTextField.bottomAnchor, left: firstTextField.leftAnchor, bottom: nil, right: firstTextField.rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 1)
        continueButton.anchor(firstUnderline.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 50, leftConstant: 50, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func usernameBackButtonAction(_ sender:UIButton!){
        delegate?.usernameBackButtonAction(sender)
        
    }
    
    @objc func usernameContinueButtonAction(_ sender:UIButton!){
        if(firstTextField.text == ""){
            Helper.shared.showOKAlert(title: "Invalid", message: "Please enter username", viewController: delegate!)
        }
        else{
            delegate?.username = firstTextField.text
            delegate?.usernameContinueButtonAction(sender)
        }
    }
    
    
    
    
}


// ---------------------------------------------------------------------


class GhostNameView: UIView {
    
    weak var delegate : RegisterViewController? = nil
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose your secret identity name"
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let ghostnameLabel: UILabel = {
        let label = UILabel()
        label.text = "Ghostname"
        label.textColor = UIColor(red:0.31, green:0.65, blue:0.96, alpha:1.0)
        label.textAlignment = .center
        return label
    }()
    
    let firstTextField: UITextField = {
        let tf = UITextField()
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        return tf
    }()
    
    let firstUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.82, green:0.82, blue:0.82, alpha:1.0)
        return view
    }()
    
    let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.backgroundColor = UIColor(red:0.11, green:0.73, blue:1.00, alpha:1.0)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(ghostContinueButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "left"), for: .normal)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(ghostBackButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(ghostnameLabel)
        addSubview(firstTextField)
        addSubview(firstUnderline)
        addSubview(continueButton)
        addSubview(backButton)
        backgroundColor = .white
        
        backButton.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 25, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        titleLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 150, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        ghostnameLabel.anchor(titleLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 0, widthConstant: 150, heightConstant: 30)
        firstTextField.anchor(ghostnameLabel.bottomAnchor, left: ghostnameLabel.leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
        firstUnderline.anchor(firstTextField.bottomAnchor, left: firstTextField.leftAnchor, bottom: nil, right: firstTextField.rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 1)
        continueButton.anchor(firstUnderline.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 50, leftConstant: 50, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func ghostBackButtonAction(_ sender:UIButton!){
        delegate?.ghostBackButtonAction(sender)
        
    }
    
    @objc func ghostContinueButtonAction(_ sender:UIButton!){
        if(firstTextField.text == ""){
            Helper.shared.showOKAlert(title: "Invalid", message: "Please enter ghostname", viewController: delegate!)
        }
        else{
            delegate?.ghostname = firstTextField.text
            delegate?.ghostContinueButtonAction(sender)
        }
    }
    
}


// ---------------------------------------------------------------


class EmailPasswordView: UIView {
    
    weak var delegate : RegisterViewController? = nil
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.textColor = UIColor(red:0.31, green:0.65, blue:0.96, alpha:1.0)
        label.textAlignment = .center
        return label
    }()
    
    let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.textColor = UIColor(red:0.31, green:0.65, blue:0.96, alpha:1.0)
        label.textAlignment = .center
        return label
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        return tf
    }()
    
    let emailUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.82, green:0.82, blue:0.82, alpha:1.0)
        return view
    }()
    
    let passwordUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.82, green:0.82, blue:0.82, alpha:1.0)
        return view
    }()
    
    let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.backgroundColor = UIColor(red:0.11, green:0.73, blue:1.00, alpha:1.0)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(emailPasswordContinueButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "left"), for: .normal)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(emailPasswordBackButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(emailLabel)
        addSubview(passwordLabel)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(emailUnderline)
        addSubview(passwordUnderline)
        addSubview(continueButton)
        addSubview(backButton)
        backgroundColor = .white
        
        
        backButton.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 25, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        titleLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 150, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        emailLabel.anchor(titleLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 25, bottomConstant: 0, rightConstant: 0, widthConstant: 150, heightConstant: 30)
        emailTextField.anchor(emailLabel.bottomAnchor, left: emailLabel.leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
        emailUnderline.anchor(emailTextField.bottomAnchor, left: emailTextField.leftAnchor, bottom: nil, right: emailTextField.rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 1)
        passwordLabel.anchor(emailUnderline.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 40, bottomConstant: 0, rightConstant: 0, widthConstant: 150, heightConstant: 30)
        passwordTextField.anchor(passwordLabel.bottomAnchor, left: passwordLabel.leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
        passwordUnderline.anchor(passwordTextField.bottomAnchor, left: passwordTextField.leftAnchor, bottom: nil, right: passwordTextField.rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 1)
        continueButton.anchor(passwordUnderline.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 50, leftConstant: 50, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func emailPasswordBackButtonAction(_ sender:UIButton!){
            delegate?.emailPasswordBackButtonAction(sender)
    }
    
    @objc func emailPasswordContinueButtonAction(_ sender:UIButton!){
        if(emailTextField.text == "" || passwordTextField.text == ""){
            Helper.shared.showOKAlert(title: "Invalid", message: "Please enter email and password", viewController: delegate!)
        }
        else{
            delegate?.email = emailTextField.text
            delegate?.password = passwordTextField.text
            delegate?.emailPasswordContinueButtonAction(sender)
        }
    }
    
}


// ---------------------------------------------------------------

class LoginView: UIView {
    
    weak var delegate : RegisterViewController? = nil
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Please Login"
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let firstNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.textColor = UIColor(red:0.31, green:0.65, blue:0.96, alpha:1.0)
        label.textAlignment = .center
        return label
    }()
    
    let lastNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.textColor = UIColor(red:0.31, green:0.65, blue:0.96, alpha:1.0)
        label.textAlignment = .center
        return label
    }()
    
    let firstTextField: UITextField = {
        let tf = UITextField()
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        return tf
    }()
    
    let lastTextField: UITextField = {
        let tf = UITextField()
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        return tf
    }()
    
    let firstUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.82, green:0.82, blue:0.82, alpha:1.0)
        return view
    }()
    
    let lastUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.82, green:0.82, blue:0.82, alpha:1.0)
        return view
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.backgroundColor = UIColor(red:0.11, green:0.73, blue:1.00, alpha:1.0)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(loginButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "left"), for: .normal)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(loginBackButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(firstNameLabel)
        addSubview(lastNameLabel)
        addSubview(firstTextField)
        addSubview(lastTextField)
        addSubview(firstUnderline)
        addSubview(lastUnderline)
        addSubview(loginButton)
        addSubview(backButton)
        backgroundColor = .white
        
        
        backButton.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 25, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        titleLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 150, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        firstNameLabel.anchor(titleLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 15, bottomConstant: 0, rightConstant: 0, widthConstant: 150, heightConstant: 30)
        firstTextField.anchor(firstNameLabel.bottomAnchor, left: firstNameLabel.leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
        firstUnderline.anchor(firstTextField.bottomAnchor, left: firstTextField.leftAnchor, bottom: nil, right: firstTextField.rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 1)
        lastNameLabel.anchor(firstUnderline.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 30, bottomConstant: 0, rightConstant: 0, widthConstant: 150, heightConstant: 30)
        lastTextField.anchor(lastNameLabel.bottomAnchor, left: lastNameLabel.leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
        lastUnderline.anchor(lastTextField.bottomAnchor, left: lastTextField.leftAnchor, bottom: nil, right: lastTextField.rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 1)
        loginButton.anchor(lastUnderline.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 50, leftConstant: 50, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func loginBackButtonAction(_ sender:UIButton!){
        delegate?.loginBackButtonAction(sender)
        
    }
    
    @objc func loginButtonAction(_ sender:UIButton!){
        if(firstTextField.text == "" || lastTextField.text == ""){
            Helper.shared.showOKAlert(title: "Invalid", message: "Please enter email and password", viewController: delegate!)
        }
        else{
            delegate?.loginEmail = firstTextField.text
            delegate?.loginPassword = lastTextField.text
            delegate?.loginButtonAction(sender)
        }
    }
    
    
}












class EmailView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
