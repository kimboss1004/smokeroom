//
//  CommentViewController.swift
//  smokeroom
//
//  Created by Austin Kim on 6/29/18.
//  Copyright © 2018 Austin Kim. All rights reserved.
//

import UIKit
import Firebase


class CommentsViewController: UIViewController {
    
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    
    var conversationid : String!
    
    var conversation: Conversation!
    
    var wordsTextField: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 10
        textView.font = UIFont(name: "Apple SD Gothic Neo", size: 20)
        return textView
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "left"), for: .normal)
        button.addTarget(self, action: #selector(dismissButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    let commentButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red:0.41, green:0.75, blue:0.96, alpha:1.0)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)!
        button.setTitle("Comment", for: .normal)
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(commentButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    let ghostCommentButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red:0.41, green:0.75, blue:0.96, alpha:1.0)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)!
        button.setTitle("Ghost Comment", for: .normal)
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(ghostCommentButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.text = "Comment"
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0.90, green:0.94, blue:0.99, alpha:1.0)
        view.addSubview(dismissButton)
        view.addSubview(commentLabel)
        view.addSubview(wordsTextField)
        view.addSubview(commentButton)
        view.addSubview(ghostCommentButton)
        dismissButton.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 25, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        commentLabel.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 25, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        wordsTextField.anchor(dismissButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 30, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 200)
        commentButton.anchor(wordsTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 60)
        ghostCommentButton.anchor(commentButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 60)
    }
    
    
    @objc func dismissButtonAction(_ sender:UIButton!){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func commentButtonAction(_ sender:UIButton!){
        if(wordsTextField.text == ""){
            Helper.shared.showOKAlert(title: "Invalid", message: "Please enter text", viewController: self)
        }
        else{
            let comment = Comment(text: wordsTextField.text, userid: (Auth.auth().currentUser?.uid)!, ghostname: false, conversationid: conversationid)
            ref = db.collection("comments").addDocument(data: comment.toAnyObject() as! [String : Any]
            ) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                }
            }
            db.collection("conversations").document(conversationid).updateData(["buzz": conversation.buzz + 1]) { (error) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                }
            }
            wordsTextField.text = ""
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func ghostCommentButtonAction(_ sender:UIButton!){
        if(wordsTextField.text == ""){
            Helper.shared.showOKAlert(title: "Invalid", message: "Please enter text", viewController: self)
        }
        else{
            let comment = Comment(text: wordsTextField.text, userid: (Auth.auth().currentUser?.uid)!, ghostname: true, conversationid: conversationid)
            ref = db.collection("comments").addDocument(data: comment.toAnyObject() as! [String : Any]
            ) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                }
            }
            db.collection("conversations").document(conversationid).updateData(["buzz" : self.conversation.buzz + 1])
            wordsTextField.text = ""
            Helper.shared.showOKAlert(title: "Success", message: "Your comment has been posted", viewController: self)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
