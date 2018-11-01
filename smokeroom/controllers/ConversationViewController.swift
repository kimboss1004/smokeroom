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
    
    var conversation: Conversation!
    var conversationid: String!
    var allComments: [Comment]! = [Comment]()
    
    var usersReference: CollectionReference!
    
    lazy var commentsVC: CommentsViewController = {
       let vc = CommentsViewController()
        return vc
    }()
    
    let nav: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.addTarget(self, action: #selector(dismissButtonAction(_:)), for: .touchUpInside)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let commentButton: UIButton = {
        let button = UIButton()
        button.setTitle("Comment", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        button.setTitleColor(UIColor(red: 0, green: 0.5373, blue: 0.949, alpha: 1.0), for: .normal)
        button.addTarget(self, action: #selector(commentButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersReference = Firestore.firestore().collection("users")
        setupCollectionView()
        fetchComments()
        view.addSubview(nav)
        nav.addSubview(backButton)
        nav.addSubview(commentButton)
        view.addSubview(collectionView)
        view.backgroundColor = UIColor(red: 220.0/255.0, green: 229.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        
        nav.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 75)
        backButton.anchor(nav.topAnchor, left: nav.leftAnchor, bottom: nav.bottomAnchor, right: nil, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 0)
        commentButton.anchor(nav.topAnchor, left: nil, bottom: nav.bottomAnchor, right: nav.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 0)
        collectionView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 80, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    
    // CollectionView methods ----------------------------------------------------------------------------
    
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
        cell.dateLabel.text = comment.date
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
            header.dateLabel.text = conversation.date
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
    
    @objc func commentButtonAction(_ sender:UIButton!){
        commentsVC.conversationid = conversationid
        commentsVC.conversation = self.conversation
        self.present(commentsVC, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchComments()
    }
    
    private func fetchComments() {
        let query = Firestore.firestore().collection("comments").whereField("conversationid", isEqualTo: conversationid as Any)
        query.getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.allComments = []
                for document in snapshot!.documents {
                    let data = document.data()
                    self.allComments.append(Comment(text: data["text"] as! String, userid: data["userid"] as! String, ghostname: data["ghostname"] as! Bool, conversationid: data["conversationid"] as! String, date: data["date"] as! String))
                }
                self.allComments = self.allComments.reversed()
                self.collectionView.reloadData()
            }
        }
    }
    
}
