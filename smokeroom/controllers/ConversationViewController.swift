//
//  ConversationViewController.swift
//  smokeroom
//
//  Created by Austin Kim on 6/24/18.
//  Copyright © 2018 Austin Kim. All rights reserved.
//

import UIKit
import Firebase

class ConversationViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    var conversation: Conversation!
    var conversationid: String!
    var allComments: [Comment]! = [Comment]()
    var bottomConstraint: NSLayoutConstraint?
    
    var usersReference: CollectionReference!
    
    lazy var commentsVC: CommentsViewController = {
       let vc = CommentsViewController()
        return vc
    }()
    
    let nav: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(red: 0.0, green: 170.0/255, blue: 232.0/255, alpha: 1.0)
        return view
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.addTarget(self, action: #selector(dismissButtonAction(_:)), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let titleImageView: UIImageView = {
        let imageView =  UIImageView(image: #imageLiteral(resourceName: "logo"))
        imageView.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let commentBarView: UIView = {
        let view = UIView()
        view.tag = 100
        view.backgroundColor = .white
        return view
    }()
    
    let commentTextField: UITextField = {
       let textfield = UITextField()
        textfield.placeholder = "Enter message..."
        return textfield
    }()
    
    let topBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.9176, green: 0.9176, blue: 0.9176, alpha: 1.0)
        return view
    }()
    
    let commentButton: UIButton = {
        let button = UIButton()
        //button.backgroundColor = UIColor(red: 0/255, green: 154/255, blue: 237/255, alpha: 1.0)
        button.setImage(#imageLiteral(resourceName: "send"), for: .normal)
        //button.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 17)!
        //button.setTitle("Send", for: .normal)
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(commentButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    let ghostButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ghost"), for: .normal)
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(ghostCommentButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func commentButtonAction(_ sender:UIButton!){
        if(commentTextField.text == ""){
            Helper.shared.showOKAlert(title: "Invalid", message: "Please enter text", viewController: self)
        }
        else{
            let comment = Comment(text: commentTextField.text!, userid: (Auth.auth().currentUser?.uid)!, ghostname: false, conversationid: conversationid)
            ref = db.collection("comments").addDocument(data: comment.toAnyObject() as! [String : Any])
            conversation.buzz += 1
            db.collection("conversations").document(conversationid).updateData(["buzz": conversation.buzz])
            // notify tagged users
            let tags = Helper.shared.extract_tags(text: comment.text)
            if tags != [] {
                for t in tags {
                    // check if tagged_username is a real user
                    self.db.collection("users").whereField("username", isEqualTo: t).getDocuments(completion: { (snapshots, error) in
                        if !(snapshots?.isEmpty)! { // if exist than create tag and notification in db
                            for document in snapshots!.documents { // document = user data
                                let notification = Notification(userid: document.documentID, type: "Comment", type_id: (self.ref?.documentID)!, message: Helper.currentUser.name + " tagged you in a comment")
                                self.db.collection("notifications").addDocument(data: notification.toAnyObject() as! [String: Any])
                            }
                        }
                    })
                }
            }
            commentTextField.text = ""
            fetchComments(scroll: true)
            commentTextField.endEditing(true)

        }
    }
    
    @objc func ghostCommentButtonAction(_ sender:UIButton!){
        if(commentTextField.text == ""){
            Helper.shared.showOKAlert(title: "Invalid", message: "Please enter text", viewController: self)
        }
        else{
            let comment = Comment(text: commentTextField.text!, userid: (Auth.auth().currentUser?.uid)!, ghostname: true, conversationid: conversationid)
            ref = db.collection("comments").addDocument(data: comment.toAnyObject() as! [String : Any]
            ) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                }
            }
            conversation.buzz += 1
            db.collection("conversations").document(conversationid).updateData(["buzz" : self.conversation.buzz])
            // notify tagged users
            let tags = Helper.shared.extract_tags(text: comment.text)
            if tags != [] {
                for t in tags {
                    // check if tagged_username is a real user
                    self.db.collection("users").whereField("username", isEqualTo: t).getDocuments(completion: { (snapshots, error) in
                        if !(snapshots?.isEmpty)! { // if exist than create tag and notification in db
                            for document in snapshots!.documents { // document = user data
                                let notification = Notification(userid: document.documentID, type: "Comment", type_id: (self.ref?.documentID)!, message: Helper.currentUser.ghostname + " tagged you in a comment")
                                self.db.collection("notifications").addDocument(data: notification.toAnyObject() as! [String: Any])
                            }
                        }
                    })
                }
            }
            commentTextField.text = ""
            fetchComments(scroll: true)
            commentTextField.endEditing(true)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let userinfo = notification.userInfo {
            if let keyboardFrame = userinfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                commentBarView.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: keyboardFrame.cgRectValue.height, rightConstant: 0, widthConstant: 0, heightConstant: 0)

            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }
        view.addSubview(commentBarView)
        commentBarView.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
    }
    
    
    // CollectionView methods ----------------------------------------------------------------------------
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        commentTextField.endEditing(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let approximateWidthOfBioTextView = view.frame.width - 180;
        let size = CGSize(width: approximateWidthOfBioTextView, height: 1000)
        let attributes = [kCTFontAttributeName: UIFont.systemFont(ofSize: 15)]
        //if let user = self.datasource?.item(indexPath) as? User {
        let estimateFrame = NSString(string: conversation.text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes as [NSAttributedStringKey : Any], context: nil)
        //header.frame.size.height = estimateFrame.height + 110
        return CGSize(width: view.frame.width, height: estimateFrame.height + 125)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allComments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CommentsCell
        let comment = allComments[indexPath.item]
        
        usersReference.document(comment.userid).getDocument { (document, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            }
            else{
                if let data = document?.data() {
                    let user = User(name: data["name"] as! String, username: data["username"] as! String, ghostname: data["ghostname"] as! String, email: data["email"] as! String)
                    if comment.ghostname {
                        cell.nameLabel.text = "Ghost"
                        cell.usernameLabel.text = user.ghostname
                    }
                    else{
                        cell.nameLabel.text = user.name
                        cell.usernameLabel.text = "@" + user.username
                    }
                }
            }
        }
        cell.textLabel.tag = indexPath.item
        cell.textLabel.text = comment.text
        cell.dateLabel.text = Helper.shared.formatStringToUserTime(stringDate: comment.date)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let comment = allComments[indexPath.item] as Comment
        let approximateWidthOfBioTextView = view.frame.width - 180;
        let size = CGSize(width: approximateWidthOfBioTextView, height: 1000)
        let attributes = [kCTFontAttributeName: UIFont.systemFont(ofSize: 15)]
        let estimateFrame = NSString(string: comment.text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes as [NSAttributedStringKey : Any], context: nil)
        return CGSize(width: view.frame.width, height: estimateFrame.height + 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView : UICollectionReusableView? = nil
        if (kind == UICollectionElementKindSectionHeader) {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header", for: indexPath as IndexPath) as! HeaderCell
            header.textLabel.text = conversation.text
            header.dateLabel.text = Helper.shared.formatStringToUserTime(stringDate: conversation.date)
            header.buzz.text = String(allComments.count) + " buzz"
            usersReference.document(conversation.userid).getDocument { (document, error) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                }
                else{
                    if let data = document?.data() {
                        let user = User(name: data["name"] as! String, username: data["username"] as! String, ghostname: data["ghostname"] as! String, email: data["email"] as! String)
                        if self.conversation.ghostname {
                            header.nameLabel.text = "Ghost"
                            header.usernameLabel.text = user.ghostname
                        }
                        else{
                            header.nameLabel.text = user.name
                            header.usernameLabel.text = user.username
                        }
                    }
                }
            }
            reusableView = header
        }
        return reusableView!
    }

    func setupCollectionView(){
        // create collections view for conversations
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CommentsCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.backgroundColor = UIColor(red: 220.0/255.0, green: 229.0/255.0, blue: 244.0/255.0, alpha: 1.0)
    }
    
    @objc func dismissButtonAction(_ sender:UIButton!){
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        fetchComments()
    }
    
    private func fetchComments(scroll: Bool = false) {
        let query = Firestore.firestore().collection("comments").whereField("conversationid", isEqualTo: conversationid as Any).order(by: "date")
        query.getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.allComments = []
                for document in snapshot!.documents {
                    let data = document.data()
                    self.allComments.append(Comment(text: data["text"] as! String, userid: data["userid"] as! String, ghostname: data["ghostname"] as! Bool, conversationid: data["conversationid"] as! String, date: data["date"] as! String))
                }
                self.collectionView.reloadData()
                if scroll {
                    if self.allComments.count != 0 {
                        let indexPath = IndexPath(item: self.allComments.count-1, section: 0)
                        self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        usersReference = db.collection("users")
        setupCollectionView()
        fetchComments()
        view.addSubview(nav)
        nav.addSubview(titleImageView)
        nav.addSubview(backButton)
        view.addSubview(collectionView)
        view.addSubview(commentBarView)
        view.backgroundColor = UIColor(red: 220.0/255.0, green: 229.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        
        nav.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 75)
        titleImageView.anchor(nav.topAnchor, left: nav.leftAnchor, bottom: nav.bottomAnchor, right: nav.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 5, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        backButton.anchor(nav.topAnchor, left: nav.leftAnchor, bottom: nav.bottomAnchor, right: nil, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 0)
        commentBarView.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        commentBarView.addSubview(commentTextField)
        commentBarView.addSubview(commentButton)
        commentBarView.addSubview(ghostButton)
        commentBarView.addSubview(topBorderView)
        commentButton.anchor(commentBarView.topAnchor, left: nil, bottom: commentBarView.bottomAnchor, right: commentBarView.rightAnchor, topConstant: 10, leftConstant: 8, bottomConstant: 10, rightConstant: 5, widthConstant: 40, heightConstant: 0)
        ghostButton.anchor(commentBarView.topAnchor, left: nil, bottom: commentBarView.bottomAnchor, right: commentButton.leftAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 5, rightConstant: 12, widthConstant: 40, heightConstant: 40)
        commentTextField.anchor(commentBarView.topAnchor, left: commentBarView.leftAnchor, bottom: commentBarView.bottomAnchor, right: ghostButton.leftAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        topBorderView.anchor(commentBarView.topAnchor, left: commentBarView.leftAnchor, bottom: nil, right: commentBarView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
        collectionView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 80, leftConstant: 0, bottomConstant: 50, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
}
