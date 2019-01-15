//
//  SettingViewController.swift
//  smokeroom
//
//  Created by Austin Kim on 6/12/18.
//  Copyright © 2018 Austin Kim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import InstantSearch

class SettingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var user: User! = nil
    var index: Index!
    let db = Firestore.firestore()
    
    let nav_view: UIView = {
        let nav_view = UIView()
        nav_view.backgroundColor = UIColor(red: 0.0, green: 170.0/255, blue: 232.0/255, alpha: 1.0)
        let dismissButton: UIButton = {
            let button = UIButton()
            button.setTitle("Cancel", for: .normal)
            button.addTarget(self, action: #selector(dismissButtonAction(_:)), for: .touchUpInside)
            return button
        }()
        let logoutButton: UIButton = {
            let button = UIButton()
            button.setTitle("Logout", for: .normal)
            button.addTarget(self, action: #selector(logoutButtonAction(_:)), for: .touchUpInside)
            return button
        }()
        let settingsLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: "Apple SD Gothic Neo", size: 25)
            label.textColor = .white
            label.text = "Settings"
            label.textAlignment = .center
            return label
        }()
        nav_view.addSubview(dismissButton)
        nav_view.addSubview(settingsLabel)
        nav_view.addSubview(logoutButton)
        dismissButton.anchor(nav_view.topAnchor, left: nav_view.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 80, heightConstant: 60)
        logoutButton.anchor(nav_view.topAnchor, left: nil, bottom: nav_view.bottomAnchor, right: nav_view.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 80, heightConstant: 60)
        settingsLabel.anchor(dismissButton.topAnchor, left: nav_view.leftAnchor, bottom: nil, right: nav_view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 60)
        return nav_view
    }()

    lazy var profile: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "profile_image")
        view.frame = CGRect(x: 160, y: 100, width: 100, height: 100)
        view.layer.cornerRadius = 0.5 * view.bounds.size.width
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectProfileViewAction)))
        return view
    }()

    
    var nameTextField: UITextField = {
        let textView = UITextField()
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 5
        textView.font = UIFont(name: "Apple SD Gothic Neo", size: 18)
        textView.text = ""
        return textView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 18)
        label.textColor = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1.0)
        label.text = "Name"
        return label
    }()
    
    var emailTextField: UITextField = {
        let textView = UITextField()
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 5
        textView.font = UIFont(name: "Apple SD Gothic Neo", size: 18)
        textView.text = ""
        return textView
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 18)
        label.textColor = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1.0)
        label.text = "Email"
        return label
    }()
    
    var usernameTextField: UITextField = {
        let textView = UITextField()
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 5
        textView.font = UIFont(name: "Apple SD Gothic Neo", size: 18)
        textView.text = ""
        return textView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 18)
        label.textColor = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1.0)
        label.text = "Username"
        return label
    }()
    
    var ghostnameTextField: UITextField = {
        let textView = UITextField()
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 5
        textView.font = UIFont(name: "Apple SD Gothic Neo", size: 18)
        textView.text = ""
        return textView
    }()
    
    let ghostnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 18)
        label.textColor = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1.0)
        label.text = "Ghostname"
        return label
    }()
    
    var passwordTextField: UITextField = {
        let textView = UITextField()
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 5
        textView.font = UIFont(name: "Apple SD Gothic Neo", size: 18)
        textView.placeholder = "********"
        return textView
    }()
    
    let passwordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 18)
        label.textColor = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1.0)
        label.text = "Password"
        return label
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red:0.23, green:0.88, blue:0.23, alpha:1.0)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)!
        button.setTitle("Save Changes", for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(saveButtonAction(_:)), for: .touchUpInside)
        return button
    }()

    
    let line1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.9176, green: 0.9176, blue: 0.9176, alpha: 1.0)
        return view
    }()
    
    let line2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.9176, green: 0.9176, blue: 0.9176, alpha: 1.0)
        return view
    }()
    
    let line3: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.9176, green: 0.9176, blue: 0.9176, alpha: 1.0)
        return view
    }()
    
    let line4: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.9176, green: 0.9176, blue: 0.9176, alpha: 1.0)
        return view
    }()
    
    let line5: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.9176, green: 0.9176, blue: 0.9176, alpha: 1.0)
        return view
    }()
    
    // UIImage Picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"]{
            selectedImageFromPicker = editedImage as? UIImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] {
            selectedImageFromPicker = originalImage as? UIImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profile.image = selectedImage
        }

        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpeg")
        let uploadData = profile.image!.resize_and_compress_into_data()
        if uploadData != Data() {
            // upload picture data into firestore
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    return
                }
                // if upload successful, then download the image url and save into user_profile_url
                storageRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    self.db.collection("users").document((Auth.auth().currentUser?.uid)!).updateData(["profile_url": url!.absoluteString]) { (error) in
                        if error != nil { return }
                    }
                })
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func selectProfileViewAction(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    // ------ Actions -------------------------------
    
    @objc func dismissButtonAction(_ sender:UIButton!){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func logoutButtonAction(_ sender:UIButton!){
        do
        {
            try Auth.auth().signOut()
        }
        catch let error as NSError
        {
            print (error.localizedDescription)
        }
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        self.view.window!.rootViewController = RegisterViewController()
        Helper.shared.showOKAlert(title: "Logged Out", message: "you have been logged out", viewController: self.view.window!.rootViewController!)
    }
    
    @objc func saveButtonAction(_ sender:UIButton!){
        var errors = ""
        if user != nil {
            let uid = (Auth.auth().currentUser?.uid)!
            if user.email != self.emailTextField.text {
                // check wether the Firebase Auth has email unused
                Auth.auth().currentUser?.updateEmail(to: self.emailTextField.text!, completion: { (error) in
                    if (error == nil) {
                        // update our own personal user database
                        let query = self.db.collection("users").whereField("email", isEqualTo: self.emailTextField.text!)
                        query.getDocuments(completion: { (snapshots, error) in
                            if (snapshots?.isEmpty)! {
                                self.db.collection("users").document(uid).updateData(["email": self.emailTextField.text!.lowercased()]) { (error) in
                                    if error != nil {
                                        print(error?.localizedDescription as Any)
                                    }
                                    else {
                                        self.user.email = self.emailTextField.text!
                                        self.index.partialUpdateObject(["email" : self.emailTextField.text! ], withID: (Auth.auth().currentUser?.uid)!)
                                    }
                                }
                            }
                        })
                        
                    }
                    else {
                        errors += (error?.localizedDescription)! + " "
                        Helper.shared.showOKAlert(title: "Error", message: errors, viewController: self)
                        self.emailTextField.text = self.user.email
                    }
                })
            }
            if user.username != self.usernameTextField.text {
                let query = db.collection("users").whereField("username", isEqualTo: self.usernameTextField.text!)
                query.getDocuments(completion: { (snapshots, error) in
                    if (snapshots?.isEmpty)! {
                        self.db.collection("users").document(uid).updateData(["username": self.usernameTextField.text!]) { (error) in
                            if error != nil {
                                errors += (error?.localizedDescription)!
                                Helper.shared.showOKAlert(title: "Error", message: errors, viewController: self)
                            }
                            else {
                                self.user.username = self.usernameTextField.text!
                                self.index.partialUpdateObject(["username" : self.usernameTextField.text! ], withID: (Auth.auth().currentUser?.uid)!)
                            }
                        }
                    }
                    else{
                        Helper.shared.showOKAlert(title: "Username Error", message: "username is already used", viewController: self)
                        self.usernameTextField.text = self.user.username
                    }
                })
            }
            if user.ghostname != self.ghostnameTextField.text {
                let query = db.collection("users").whereField("ghostname", isEqualTo: self.ghostnameTextField.text!)
                query.getDocuments(completion: { (snapshots, error) in
                    if (snapshots?.isEmpty)! {
                        self.db.collection("users").document(uid).updateData(["ghostname": self.ghostnameTextField.text!]) { (error) in
                            if error != nil {
                                errors += (error?.localizedDescription)!
                                Helper.shared.showOKAlert(title: "Error", message: errors, viewController: self)
                                return
                            }
                            else {
                                self.user.ghostname = self.ghostnameTextField.text!
                            }
                        }
                    }
                    else{
                        errors += (error?.localizedDescription)! + " "
                        Helper.shared.showOKAlert(title: "Username Error", message: "username is already used", viewController: self)
                    }
                })
            }
            if self.passwordTextField.text != "" {
                Auth.auth().currentUser?.updatePassword(to: self.passwordTextField.text!.lowercased(), completion: { (error) in
                    if error != nil {
                        errors += (error?.localizedDescription)! + " "
                        Helper.shared.showOKAlert(title: "Error", message: errors, viewController: self)
                        self.passwordTextField.text = ""
                    }
                })
            }
            if user.name != "" && user.name != self.nameTextField.text {
                db.collection("users").document(uid).updateData(["name": self.nameTextField.text!.lowercased()]) { (error) in
                    if error != nil {
                        print(error?.localizedDescription as Any)
                        return
                    }
                    else {
                        self.user.name = self.nameTextField.text!
                        self.index.partialUpdateObject(["name" : self.nameTextField.text! ], withID: (Auth.auth().currentUser?.uid)!)
                    }
                    
                }
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        index = Client(appID: "NZJAE708OM", apiKey: "61672ad893ddeeb69532d2cd146c7913").index(withName: "users")
        Firestore.firestore().collection("users").document((Auth.auth().currentUser?.uid)!).getDocument { (document, error) in
            if error != nil { return }
            if let data = document?.data() {
                let user = User(name: data["name"] as! String, username: data["username"] as! String, ghostname: data["ghostname"] as! String, email: data["email"] as! String, profile_url: data["profile_url"] as! String)
                self.user = user
                self.emailTextField.text = user.email
                self.usernameTextField.text = user.username
                self.ghostnameTextField.text = user.ghostname
                self.nameTextField.text = user.name
                self.passwordTextField.text = ""
                
                // download and load the profile image of user from firestorage
                let profileImageURL = user.profile_url
                if profileImageURL != "" {
                    let url = URL(string: profileImageURL)
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        if error != nil { return }
                        // Move to a background thread to do some long running work
                        // This is also the golden code to reload a specefic uielement on page after fetching data. !!
                        DispatchQueue.main.async {
                            self.profile.image = UIImage(data: data!)
                        }
                    }).resume()
                }
            }
        }
        view.backgroundColor = .white
        view.addSubview(nav_view)
        view.addSubview(profile)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(usernameLabel)
        view.addSubview(usernameTextField)
        view.addSubview(ghostnameLabel)
        view.addSubview(ghostnameTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(saveButton)
        view.addSubview(line1)
        view.addSubview(line2)
        view.addSubview(line3)
        view.addSubview(line4)
        view.addSubview(line5)
        nav_view.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 80)
        profile.anchor(nav_view.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 35, leftConstant: (view.frame.width/2 - 50), bottomConstant: 0, rightConstant: (view.frame.width/2 - 50), widthConstant: 100, heightConstant: 100)
        emailLabel.anchor(profile.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 50, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 70, heightConstant: 50)
        emailTextField.anchor(emailLabel.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 130, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        line1.anchor(emailLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 1)
        nameLabel.anchor(line1.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 50)
        nameTextField.anchor(line1.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 130, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        line2.anchor(nameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 1)
        usernameLabel.anchor(line2.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 50)
        usernameTextField.anchor(nameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 130, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        line3.anchor(usernameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 1)
        ghostnameLabel.anchor(line3.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 50)
        ghostnameTextField.anchor(usernameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 130, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        line4.anchor(ghostnameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 1)
        passwordLabel.anchor(ghostnameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 50)
        passwordTextField.anchor(ghostnameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 130, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        line5.anchor(passwordLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 1)
        saveButton.anchor(line5.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 35, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)
    }
    
    
}
