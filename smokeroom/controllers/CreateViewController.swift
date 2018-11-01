//
//  CreateViewController.swift
//  smokeroom
//
//  Created by Austin Kim on 6/12/18.
//  Copyright © 2018 Austin Kim. All rights reserved.
//

import UIKit
import Firebase



class CreateViewController: UIViewController {
    
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    
    var wordsTextField: UITextView = {
       let textView = UITextView()
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 5
        textView.font = UIFont(name: "Apple SD Gothic Neo", size: 20)
        return textView
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
        button.setTitle("Post", for: .normal)
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(postButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    let ghostButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 252/255, green: 107/255, blue: 88/255, alpha:1.0)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)!
        button.setTitle("Ghost", for: .normal)
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(ghostButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    let postLabel: UILabel = {
        let label = UILabel()
        label.text = "Discussion Thread"
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0.90, green:0.94, blue:0.99, alpha:1.0)
        view.addSubview(dismissButton)
        view.addSubview(postLabel)
        view.addSubview(wordsTextField)
        view.addSubview(postButton)
        view.addSubview(ghostButton)
        dismissButton.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 25, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        postLabel.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 25, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        wordsTextField.anchor(dismissButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 15, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 400)
        postButton.anchor(wordsTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        ghostButton.anchor(postButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)
    }
    
    
    @objc func dismissButtonAction(_ sender:UIButton!){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func postButtonAction(_ sender:UIButton!){
        if(wordsTextField.text == ""){
            Helper.shared.showOKAlert(title: "Invalid", message: "Please enter text", viewController: self)
        }
        else{
            let conversation = Conversation(text: self.wordsTextField.text, userid: Auth.auth().currentUser!.uid,  ghostname: false)
            ref = db.collection("conversations").addDocument(data: conversation.toAnyObject() as! [String : Any]
                ) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        }
                    }
            wordsTextField.text = ""
            self.dismiss(animated: true, completion: nil)
            Helper.shared.showOKAlert(title: "Success", message: "Your Room has been created", viewController: self)
        }
    }
    
    @objc func ghostButtonAction(_ sender:UIButton!){
        if(wordsTextField.text == ""){
            Helper.shared.showOKAlert(title: "Invalid", message: "Please enter text", viewController: self)
        }
        else{
            let conversation = Conversation(text: self.wordsTextField.text, userid: Auth.auth().currentUser!.uid,  ghostname: true)
            db.collection("conversations").addDocument(data: conversation.toAnyObject() as! [String : Any]) { (err) in
                if let err = err {
                    print("Error adding document: \(err)")
                }
            }
            Helper.shared.showOKAlert(title: "Success", message: "Your thread has been ghost posted", viewController: self)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
