//
//  CreateViewController.swift
//  smokeroom
//
//  Created by Austin Kim on 6/12/18.
//  Copyright © 2018 Austin Kim. All rights reserved.
//

import UIKit
import Firebase

class CreateViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    var imagePicker = UIImagePickerController()
    var image: UIImage?
    
    var wordsTextView: UITextView = {
       let textView = UITextView()
        textView.text = "Write something"
        textView.textColor = .lightGray
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 5
        textView.font = UIFont(name: "Apple SD Gothic Neo", size: 20)
        return textView
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    let profileImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "profile_image")
        return view
    }()

    let dismissButton: UIButton = {
       let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "cancel"), for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(dismissButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    // toolbar
    
    var toolbarView: UIView = {
        let view = UIView()
        view.tag = 100
        view.backgroundColor = .white
        return view
    }()
    
    let postButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0/255, green: 154/255, blue: 237/255, alpha: 1.0)
        button.titleLabel?.font = UIFont(name: "GillSans", size: 15)!
        button.setTitle("Post", for: .normal)
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(postButtonAction(_:)), for: .touchUpInside)
        return button
    }()

    let ghostButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0/255, green: 154/255, blue: 237/255, alpha: 1.0)
        button.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 15)!
        button.setTitle("Ghost", for: .normal)
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(ghostButtonAction(_:)), for: .touchUpInside)
        return button
    }()

    let galleryButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 15)!
        button.setImage(UIImage(named: "gallery"), for: .normal)
        button.addTarget(self, action: #selector(selectImagePickerViewAction), for: .touchUpInside)
        return button
    }()
    
    let closeKeyboardButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 15)!
        button.setImage(UIImage(named: "cancel"), for: .normal)
        return button
    }()
    
    let line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.9176, green: 0.9176, blue: 0.9176, alpha: 1.0)
        return view
    }()
    
    // Button Action ------------------------------------------------
    
    @objc func dismissButtonAction(_ sender:UIButton!){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func postButtonAction(_ sender:UIButton!){
        if(wordsTextView.text == ""){
            Helper.shared.showOKAlert(title: "Invalid", message: "Please enter text", viewController: self)
        }
        else{
            // check if var image is uploaded
            if image != nil {
                postWithImage(ghost: false)
            }
            else {
                postWithoutImage(ghost: false)
            }
        }
    }
    
    @objc func ghostButtonAction(_ sender:UIButton!){
        if(wordsTextView.text == ""){
            Helper.shared.showOKAlert(title: "Invalid", message: "Please enter text", viewController: self)
        }
        else{
            // check if var image is uploaded
            if image != nil {
                postWithImage(ghost: true)
            }
            else {
                postWithoutImage(ghost: true)
            }
        }
    }
    
    // this method depends on the image variable that must be updated in imagepicker
    // helpers for the create button actions
    private func postWithImage(ghost: Bool) {
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("conversation_images").child("\(imageName).png")
        let uploadData = image!.resize_and_compress_into_data()
        if uploadData != Data(){
            // upload picture data into firestore
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil { return }
                // if upload successful, then download the image url and save into user_profile_url
                storageRef.downloadURL(completion: { (url, error) in
                    if error != nil { return }
                    let conversation = Conversation(text: self.wordsTextView.text, userid: Auth.auth().currentUser!.uid,  ghostname: ghost, imageUrl: url!.absoluteString)
                    self.ref = self.db.collection("conversations").addDocument(data: conversation.toAnyObject() as! [String : Any]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        }
                    }
                    // Tags
                    let tags = Helper.shared.extract_tags(text: conversation.text)
                    if tags != [] {
                        for t in tags {
                            // check if tagged_username is a real user
                            self.db.collection("users").whereField("username", isEqualTo: t).getDocuments(completion: { (snapshots, error) in
                                if !(snapshots?.isEmpty)! { // if exist than create tag and notification in db
                                    for document in snapshots!.documents { // document = user data
                                        let tag = Tag(tagged_userid: document.documentID, conversation_id: (self.ref?.documentID)!)
                                        let notification = Notification(userid: document.documentID, type: "Conversation", type_id: (self.ref?.documentID)!, message: "")
                                        if ghost {
                                            notification.message = Helper.currentUser.ghostname + " tagged you in a conversation"
                                        }
                                        else {
                                            notification.message = Helper.currentUser.name + " tagged you in a conversation"
                                        }
                                        self.db.collection("tags").addDocument(data: tag.toAnyObject() as! [String: Any])
                                        self.db.collection("notifications").addDocument(data: notification.toAnyObject() as! [String: Any])
                                    }
                                }
                            })
                        }
                    }
                    self.wordsTextView.text = ""
                    Helper.shared.showOKAlert(title: "Success", message: "Your Conversation has been created", viewController: (self.view.window?.rootViewController)!)
                    self.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
    
    private func postWithoutImage(ghost: Bool) {
        let conversation = Conversation(text: wordsTextView.text, userid: Auth.auth().currentUser!.uid,  ghostname: ghost, imageUrl: "")
        self.ref = self.db.collection("conversations").addDocument(data: conversation.toAnyObject() as! [String : Any]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            }
        }
        // Tags
        let tags = Helper.shared.extract_tags(text: conversation.text)
        if tags != [] {
            for t in tags {
                // check if tagged_username is a real user
                self.db.collection("users").whereField("username", isEqualTo: t).getDocuments(completion: { (snapshots, error) in
                    if !(snapshots?.isEmpty)! { // if exist than create tag and notification in db
                        for document in snapshots!.documents { // document = user data
                            let tag = Tag(tagged_userid: document.documentID, conversation_id: (self.ref?.documentID)!)
                            let notification = Notification(userid: document.documentID, type: "Conversation", type_id: (self.ref?.documentID)!, message: "")
                            if ghost {
                                notification.message = Helper.currentUser.ghostname + " tagged you in a conversation"
                            }
                            else {
                                notification.message = Helper.currentUser.name + " tagged you in a conversation"
                            }
                            self.db.collection("tags").addDocument(data: tag.toAnyObject() as! [String: Any])
                            self.db.collection("notifications").addDocument(data: notification.toAnyObject() as! [String: Any])
                        }
                    }
                })
            }
        }
        wordsTextView.text = ""
        Helper.shared.showOKAlert(title: "Success", message: "Your Conversation has been created", viewController: (self.view.window?.rootViewController)!)
        dismiss(animated: true, completion: nil)
    }
    
// image add actions -------------------------------------------------------------
    
    // button action for camera icon
    @objc func selectImagePickerViewAction(){
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    // UIImage Picker dismiss
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
            // image must have square dimensions
            if abs(selectedImage.size.width - selectedImage.size.height) < 10 {
                image = selectedImage
                let oldWidth:CGFloat = selectedImage.size.width
                let scaleFactor:CGFloat = oldWidth/(view.frame.size.width)
                imageView.image = UIImage(cgImage: selectedImage.cgImage!, scale: scaleFactor, orientation: .up)
            }
            else {
                picker.dismiss(animated: true, completion: nil)
                Helper.shared.showOKAlert(title: "Invalid Image dimensions", message: "Image must be cropped into a square.", viewController: self)
                return
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
// keyboard --------------------------------------------------
    private func enableKeyboardHideOnTap(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard(_:)))
        self.closeKeyboardButton.addGestureRecognizer(tap)
        
    }
    
     @objc func keyboardWillShow(_ notification: NSNotification) {
        if wordsTextView.text == "Write something" {
            wordsTextView.textColor = .black
            wordsTextView.text = ""
        }
        if let userinfo = notification.userInfo {
            if let keyboardFrame = userinfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                if let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as? Double {
                    UIView.animate(withDuration: duration) {
                        self.toolbarView.anchor(nil, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: keyboardFrame.cgRectValue.height, rightConstant: 0, widthConstant: 0, heightConstant: 0)
                        self.view.layoutIfNeeded()
                    }
                }
            }
        }
    }
    
     @objc func keyboardWillHide(_ notification: NSNotification) {
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }
        view.addSubview(toolbarView)
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration) {
            self.toolbarView.anchor(nil, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 45)
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func hideKeyboard(_ view: CreateViewController){
        self.wordsTextView.endEditing(true)
    }
    
    func setupToolbar() {
        // setup the inside of toolbar
        view.addSubview(toolbarView)
        toolbarView.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 45)
        toolbarView.addSubview(postButton)
        toolbarView.addSubview(ghostButton)
        toolbarView.addSubview(galleryButton)
        toolbarView.addSubview(closeKeyboardButton)
        toolbarView.addSubview(line)
        line.anchor(toolbarView.topAnchor, left: toolbarView.leftAnchor, bottom: nil, right: toolbarView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        postButton.anchor(toolbarView.topAnchor, left: nil, bottom: toolbarView.bottomAnchor, right: toolbarView.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 8, rightConstant: 10, widthConstant: 45, heightConstant: 0)
        ghostButton.anchor(toolbarView.topAnchor, left: nil, bottom: toolbarView.bottomAnchor, right: postButton.leftAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 8, rightConstant: 10, widthConstant: 60, heightConstant: 0)
        closeKeyboardButton.anchor(toolbarView.topAnchor, left: toolbarView.leftAnchor, bottom: toolbarView.bottomAnchor, right: nil, topConstant: 12, leftConstant: 10, bottomConstant: 12, rightConstant: 0, widthConstant: 20, heightConstant: 0)
        galleryButton.anchor(toolbarView.topAnchor, left: closeKeyboardButton.rightAnchor, bottom: toolbarView.bottomAnchor, right: nil, topConstant: 7, leftConstant: 15, bottomConstant: 7, rightConstant: 0, widthConstant: 30, heightConstant: 0)
        //wordsTextView.inputAccessoryView = toolbarView
    }
    
// ------------------------------------------------------------
    
    override func viewDidAppear(_ animated: Bool) {
        enableKeyboardHideOnTap()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordsTextView.delegate = self as UITextViewDelegate
        view.backgroundColor = .white
        view.addSubview(dismissButton)
        view.addSubview(profileImage)
        view.addSubview(wordsTextView)
        view.addSubview(imageView)
        profileImage.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 30, leftConstant: 15, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        dismissButton.anchor(view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 40, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 30, heightConstant: 30)
        wordsTextView.anchor(dismissButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 15, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 130)
        imageView.anchor(wordsTextView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    
        setupToolbar()

    }
    
}












// keyboard --------------------------------------------------------------
//    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
//        textView.textColor = .black
//        if textView.text == "Write something"{
//            textView.text = ""
//        }
//
//        toolbarView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 45)
//        toolbarView.addSubview(postButton)
//        toolbarView.addSubview(ghostButton)
//        toolbarView.addSubview(galleryButton)
//        postButton.anchor(toolbarView.topAnchor, left: nil, bottom: toolbarView.bottomAnchor, right: toolbarView.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 10, rightConstant: 15, widthConstant: 60, heightConstant: 0)
//        ghostButton.anchor(toolbarView.topAnchor, left: nil, bottom: toolbarView.bottomAnchor, right: postButton.leftAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 10, rightConstant: 15, widthConstant: 60, heightConstant: 0)
//        galleryButton.anchor(toolbarView.topAnchor, left: toolbarView.leftAnchor, bottom: toolbarView.bottomAnchor, right: nil, topConstant: 5, leftConstant: 15, bottomConstant: 5, rightConstant: 0, widthConstant: 50, heightConstant: 0)
//        textView.inputAccessoryView = toolbarView
//        return true
//    }
