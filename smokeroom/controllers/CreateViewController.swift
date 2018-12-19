//
//  CreateViewController.swift
//  smokeroom
//
//  Created by Austin Kim on 6/12/18.
//  Copyright © 2018 Austin Kim. All rights reserved.
//

import UIKit
import Firebase



class CreateViewController: UIViewController, UITextViewDelegate {
    
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    var toolbarView: UIView?
    
    var wordsTextView: UITextView = {
       let textView = UITextView()
        textView.text = "Write something"
        textView.textColor = .lightGray
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 5
        textView.font = UIFont(name: "Apple SD Gothic Neo", size: 20)
        return textView
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
    
    let postButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0/255, green: 154/255, blue: 237/255, alpha: 1.0)
        button.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 19)!
        button.setTitle("Post", for: .normal)
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(postButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    let ghostButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0/255, green: 154/255, blue: 237/255, alpha: 1.0)
        button.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 19)!
        button.setTitle("Ghost", for: .normal)
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(ghostButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    
    
    
    
    
    @objc func dismissButtonAction(_ sender:UIButton!){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func postButtonAction(_ sender:UIButton!){
        if(wordsTextView.text == ""){
            Helper.shared.showOKAlert(title: "Invalid", message: "Please enter text", viewController: self)
        }
        else{
            let conversation = Conversation(text: self.wordsTextView.text, userid: Auth.auth().currentUser!.uid,  ghostname: false)
            ref = db.collection("conversations").addDocument(data: conversation.toAnyObject() as! [String : Any]
                ) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        }
                    }
            wordsTextView.text = ""
            self.dismiss(animated: true, completion: nil)
            Helper.shared.showOKAlert(title: "Success", message: "Your Room has been created", viewController: self)
        }
    }
    
    @objc func ghostButtonAction(_ sender:UIButton!){
        if(wordsTextView.text == ""){
            Helper.shared.showOKAlert(title: "Invalid", message: "Please enter text", viewController: self)
        }
        else{
            let conversation = Conversation(text: self.wordsTextView.text, userid: Auth.auth().currentUser!.uid,  ghostname: true)
            db.collection("conversations").addDocument(data: conversation.toAnyObject() as! [String : Any]) { (err) in
                if let err = err {
                    print("Error adding document: \(err)")
                }
            }
            Helper.shared.showOKAlert(title: "Success", message: "Your thread has been ghost posted", viewController: self)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.textColor = .black
        textView.text = ""
        if toolbarView == nil{
            toolbarView = UIView(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 55))
            let line = UIView()
            line.backgroundColor = UIColor(red: 0.9176, green: 0.9176, blue: 0.9176, alpha: 1.0)
            toolbarView?.addSubview(line)
            toolbarView?.addSubview(postButton)
            toolbarView?.addSubview(ghostButton)
            line.anchor(toolbarView?.topAnchor, left: toolbarView?.leftAnchor, bottom: nil, right: toolbarView?.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
            postButton.anchor(toolbarView?.topAnchor, left: nil, bottom: toolbarView?.bottomAnchor, right: toolbarView?.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 5, rightConstant: 15, widthConstant: 70, heightConstant: 0)
            ghostButton.anchor(toolbarView?.topAnchor, left: nil, bottom: toolbarView?.bottomAnchor, right: postButton.leftAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 5, rightConstant: 15, widthConstant: 80, heightConstant: 0)
        }
        textView.inputAccessoryView = toolbarView
        return true;
    }

    @objc func doBtnPrev() {
        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordsTextView.becomeFirstResponder()
        wordsTextView.delegate = self as UITextViewDelegate
        view.backgroundColor = .white
        view.addSubview(dismissButton)
        view.addSubview(profileImage)
        view.addSubview(wordsTextView)
        profileImage.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 30, leftConstant: 15, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        dismissButton.anchor(view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 40, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 30, heightConstant: 30)
        wordsTextView.anchor(dismissButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 15, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 400)

    }
    
    
    
    
    
    
    
}





