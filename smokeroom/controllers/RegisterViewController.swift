//
//  RegisterViewController.swift
//  smokeroom
//
//  Created by Austin Kim on 6/30/18.
//  Copyright © 2018 Austin Kim. All rights reserved.
//

import UIKit
import Firebase
import InstantSearch

class RegisterViewController: UIViewController {
    
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    var index: Index! //for algolia search
    var firstname: String!
    var lastname: String!
    var username: String!
    var ghostname: String!
    var email: String!
    var password: String!
    var loginEmail: String!
    var loginPassword: String!
    
    lazy var introView: IntroView = {
        let view = IntroView()
        view.delegate = self
        return view
    }()
    
    lazy var loginView: LoginView = {
       let view = LoginView()
        view.delegate = self
        view.tag = 5
        return view
    }()
    
    lazy var nameView: NameView = {
        let view = NameView()
        view.delegate = self
        view.tag = 1
        return view
    }()
    
    lazy var usernameView: UsernameView = {
        let view = UsernameView()
        view.delegate = self
        view.tag = 2
        return view
    }()
    
    lazy var ghostnameView: GhostNameView = {
        let view = GhostNameView()
        view.delegate = self
        view.tag = 3
        return view
    }()
    
    lazy var emailPasswordView: EmailPasswordView = {
        let view = EmailPasswordView()
        view.delegate = self
        view.tag = 4
        return view
    }()
    
    @objc func loginButtonAction(_ sender:UIButton!){
        print(loginEmail)
        print(loginPassword)
        Auth.auth().signIn(withEmail: loginEmail, password: loginPassword) { (user, error) in
            if let error = error {
                Helper.shared.showOKAlert(title: "Login Error", message: error.localizedDescription, viewController: self)
            }
            else if Auth.auth().currentUser != nil {
                self.removeFromParentViewController()
                Helper.shared.switchStoryboard(vc: HomeViewController())
                Helper.shared.showOKAlert(title: "Login Succesful", message: "Welcome", viewController: self)
                return
            }
        }
    }
    
    @objc func loginBackButtonAction(_ sender:UIButton!){
        if let v = view.viewWithTag(5) {
            v.removeFromSuperview()
        }
    }
    
    @objc func registerButtonAction(_ sender:UIButton!){
        view.addSubview(nameView)
        nameView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    @objc func loginButtonViewAction(_ sender:UIButton!){
        view.addSubview(loginView)
        loginView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    @objc func nameContinueButtonAction(_ sender:UIButton!){
        view.addSubview(usernameView)
        usernameView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    @objc func nameBackButtonAction(_ sender:UIButton!){
        if let v = view.viewWithTag(1) {
            v.removeFromSuperview()
        }
    }
    
    @objc func usernameContinueButtonAction(_ sender:UIButton!){
        let query = db.collection("users").whereField("username", isEqualTo: username)
        query.getDocuments(completion: { (snapshots, error) in
            if (snapshots?.isEmpty)! {
                self.view.addSubview(self.ghostnameView)
                self.ghostnameView.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
            }
            else{
                Helper.shared.showOKAlert(title: "That Username already exists", message: "Please choose another", viewController: self)
            }
        })
    }
    
    @objc func usernameBackButtonAction(_ sender:UIButton!){
        if let v = view.viewWithTag(2) {
            v.removeFromSuperview()
        }
    }
    
    @objc func ghostContinueButtonAction(_ sender:UIButton!){
        let query = db.collection("users").whereField("ghostname", isEqualTo: ghostname)
        query.getDocuments { (querySnapshots, error) in
            if (querySnapshots?.isEmpty)! {
                self.view.addSubview(self.emailPasswordView)
                self.emailPasswordView.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
            }
            else {
                Helper.shared.showOKAlert(title: "That Ghostname already exists", message: "Please choose another", viewController: self)
            }
        }

    }
    
    @objc func ghostBackButtonAction(_ sender:UIButton!){
        if let v = view.viewWithTag(3) {
            v.removeFromSuperview()
        }
    }
    
    @objc func emailPasswordBackButtonAction(_ sender:UIButton!){
        if let v = view.viewWithTag(4) {
            v.removeFromSuperview()
        }
    }
    
    @objc func emailPasswordContinueButtonAction(_ sender:UIButton!){
        // create user in Firestore default Users
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if(error == nil){
                // create user in our personal User databse
                let user = User(name: self.firstname + self.lastname, username: self.username, ghostname: self.ghostname, email: self.email)
                self.db.collection("users").document(Auth.auth().currentUser!.uid).setData(user.toAnyObject() as! [String : Any])
                // set the current User so we can access easy
                Helper.currentUser = User(name: self.firstname + self.lastname, username: self.username, ghostname: self.ghostname, email: self.email)
                // index var is for algolia
                self.index.addObject(["name": self.firstname + self.lastname, "username": self.username, "email": self.email], withID: (Auth.auth().currentUser?.uid)!)
                Helper.shared.showOKAlert(title: "Welcome!", message: "You have succesfully registered.", viewController: self)
                for subview in self.view.subviews as [UIView]{
                    subview.removeFromSuperview()
                }
                self.removeFromParentViewController()
                Helper.shared.switchStoryboard(vc: HomeViewController())
                return
            }
            Helper.shared.showOKAlert(title: "Error", message: (error?.localizedDescription)!, viewController: self)
            return
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        index = Client(appID: "NZJAE708OM", apiKey: "61672ad893ddeeb69532d2cd146c7913").index(withName: "users")
        view.addSubview(introView)
        introView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }

}
