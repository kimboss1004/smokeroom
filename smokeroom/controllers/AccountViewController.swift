//
//  AccountViewController.swift
//  smokeroom
//
//  Created by Austin Kim on 6/3/18.
//  Copyright © 2018 Austin Kim. All rights reserved.
//

import UIKit
import Firebase

class AccountViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    var accountid: String!
    let db = Firestore.firestore()
    var usersReference: CollectionReference!
    var allConversations: [Conversation]! = [Conversation]()
    var conversationIDS: [String]! = [String]()
    var friend_request_id: String = ""
    
    lazy var friendsVC: FriendsViewController = {
        let view = FriendsViewController()
        return view
    }()
    
    lazy var conversationVC: ConversationViewController = {
        let view = ConversationViewController()
        return view
    }()
    
    let conversation: Conversation = {
        let c = Conversation(text: "I like apples and Bananas when I eat my coke and rum.", userid: "asdf23r", ghostname: false)
        return c
    }()
    
    // Top Navbar items
    let header: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    let friendsButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "friends"), for: .normal)
        button.frame.size = CGSize(width: 40, height: 40)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(friendsButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    let headerTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"HelveticaNeue", size: 17.0)
        label.text = "Profile"
        label.textAlignment = .center
        return label
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "left"), for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(dismissButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    let border: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.9176, green: 0.9176, blue: 0.9176, alpha: 1.0)
        return view
    }()
    
    // CollectionView methods ----------------------------------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allConversations.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ConversationCell
        let conversation = allConversations[indexPath.item]
        usersReference.document(conversation.userid).getDocument { (document, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            }
            else{
                if let data = document?.data() {
                    let user = User(name: data["name"] as! String, username: data["username"] as! String, ghostname: data["ghostname"] as! String, email: data["email"] as! String)
                    if conversation.ghostname {
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
        cell.textLabel.addTarget(self, action: #selector(conversationClickedButton(_:)), for: .touchUpInside)
        cell.textLabel.tag = indexPath.item
        cell.buzz.text = "Comments: " + String(conversation.buzz)
        cell.textLabel.setTitle(conversation.text, for: .normal)
        cell.dateLabel.text = Helper.shared.formatStringToUserTime(stringDate: conversation.date)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let approximateWidthOfBioTextView = view.frame.width - 180;
        let size = CGSize(width: approximateWidthOfBioTextView, height: 1000)
        let attributes = [kCTFontAttributeName: UIFont.systemFont(ofSize: 15)]
        //if let user = self.datasource?.item(indexPath) as? User {
        let estimateFrame = NSString(string: conversation.text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes as [NSAttributedStringKey : Any], context: nil)
        return CGSize(width: view.frame.width, height: estimateFrame.height + 85)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView : UICollectionReusableView? = nil
        if (kind == UICollectionElementKindSectionHeader) {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header", for: indexPath as IndexPath) as! AccountHeader
            // if this is the current users account
            if accountid == Auth.auth().currentUser?.uid {
                header.friendRequestButton.isHidden = true
            }
            else {
                // query to see if already friends or friend requested
                let current_user_made_request_query = db.collection("friendrequests").whereField("userid", isEqualTo: Auth.auth().currentUser?.uid as Any).whereField("friendid", isEqualTo: accountid)
                current_user_made_request_query.getDocuments(completion: { (snapshots, error) in
                    if !(snapshots?.isEmpty)! {
                        // if snapshot exists, friend request already exist
                        for document in snapshots!.documents {
                            // if confirmation is true, hide button
                            if document.data()["confirmed"] as! Bool == true {
                                header.friendRequestButton.setTitle("Already Friends", for: .normal)
                                // header.friendRequestButton.isHidden = true
                            }
                            else {
                                // else request not confirmed
                                header.friendRequestButton.setTitle("Request Pending", for: .normal)
                            }
                            header.friendRequestButton.removeTarget(nil, action: nil, for: .allEvents)
                            //self.collectionView.reloadData()
                        }
                    }
                    else {
                        // check for friendreqest snapshot where currentuser was the reciever
                        let current_user_got_request_query = self.db.collection("friendrequests").whereField("userid", isEqualTo: self.accountid).whereField("friendid", isEqualTo: Auth.auth().currentUser?.uid as Any)
                        current_user_got_request_query.getDocuments(completion: { (snapshots, error) in
                            if !(snapshots?.isEmpty)! {
                                // if snapshot exists, friend request exists
                                for document in snapshots!.documents {
                                    // if confirmation is true, hide button
                                    if document.data()["confirmed"] as! Bool == true {
                                        header.friendRequestButton.setTitle("Friends", for: .normal)
                                        header.friendRequestButton.removeTarget(nil, action: nil, for: .allEvents)
                                    }
                                    else {
                                        // else request not confirmed
                                        header.friendRequestButton.setTitle("Accept Friend Request", for: .normal)
                                        header.friendRequestButton.removeTarget(nil, action: nil, for: .allEvents)
                                        self.friend_request_id = document.documentID
                                        header.friendRequestButton.addTarget(self, action: #selector(self.acceptFriendButtonAction(_:)), for: .touchUpInside)
                                    }
                                    //self.collectionView.reloadData()
                                }
                            }
                            else {
                                // not friend requested yet
                                header.friendRequestButton.addTarget(self, action: #selector(self.friendrequestButtonAction(_:)), for: .touchUpInside)
                            }
                        })
                    }
                })
            }
            // add account info on user
            usersReference.document(accountid).getDocument { (document, error) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                }
                else{
                    if let data = document?.data() {
                        let user = User(name: data["name"] as! String, username: data["username"] as! String, ghostname: data["ghostname"] as! String, email: data["email"] as! String)
                        header.namelabel.text = user.name
                        header.usernamelabel.text = "@" + user.username
                    }
                }
            }
            reusableView = header
        }
        return reusableView!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 220)
    }
    
    // create collections view for conversations
    func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 120)
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ConversationCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(AccountHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.backgroundColor = .white
    }
    
    // ---------------------------------------------------------------------------------
    @objc func conversationClickedButton(_ sender:UIButton!)
    {
        conversationVC.view = nil
        conversationVC.conversation = allConversations[sender.tag]
        conversationVC.conversationid = conversationIDS[sender.tag]
        self.present(conversationVC, animated: true, completion: nil)
    }
    
    private func fetchConversations() {
        let query = db.collection("conversations").whereField("userid", isEqualTo: accountid as Any).order(by: "date", descending: true)
        query.getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.allConversations = []
                self.conversationIDS = []
                for document in snapshot!.documents {
                    let data = document.data()
                    self.conversationIDS.append(document.documentID)
                    self.allConversations.append(Conversation(text: data["text"] as! String, userid: data["userid"] as! String, buzz: data["buzz"] as! Int, ghostname: data["ghostname"] as! Bool, date: data["date"] as! String))
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc func dismissButtonAction(_ sender:UIButton!){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func friendsButtonAction(_ sender:UIButton!)
    {
        friendsVC.userid = accountid
        self.present(friendsVC, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchConversations()
    }
    
    @objc func friendrequestButtonAction(_ sender: UIButton! ) {
        let friendRequest = FriendRequest(userid: (Auth.auth().currentUser?.uid)!, friendid: accountid, confirmed: false)
        db.collection("friendrequests").addDocument(data: friendRequest.toAnyObject() as! [String : Any]
        ) { err in
            if let err = err {
                print("Error adding document: \(err)")
            }
            else {
                let notification = Notification(userid: self.accountid, type: "FriendRequest", type_id: (Auth.auth().currentUser?.uid)!, message: Helper.currentUser.name + " sent you a friend request")
                self.db.collection("notifications").addDocument(data: notification.toAnyObject() as! [String: Any])
                Helper.shared.showOKAlert(title: "Success", message: "Your Request has been sent", viewController: self)
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc func acceptFriendButtonAction(_ sender:UIButton!){
        db.collection("friendrequests").document(friend_request_id).updateData(["confirmed": true]) { (error) in
            if error == nil {
                let notification = Notification(userid: self.accountid, type: "FriendRequest", type_id: (Auth.auth().currentUser?.uid)!, message: Helper.currentUser.name + " accepted your friend request")
                self.db.collection("notifications").addDocument(data: notification.toAnyObject() as! [String: Any])
                Helper.shared.showOKAlert(title: "Friend Accepted", message: "Woohoo, new friend!", viewController: self)
                self.collectionView.reloadData()
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersReference = db.collection("users")
        fetchConversations()
        view.backgroundColor = .white
        view.addSubview(header)
        header.addSubview(dismissButton)
        header.addSubview(headerTitle)
        header.addSubview(friendsButton)
        view.addSubview(border)
        setupCollectionView()
        view.addSubview(collectionView)
        
        header.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 15, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        dismissButton.anchor(header.topAnchor, left: header.leftAnchor, bottom: header.bottomAnchor, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        headerTitle.anchor(header.topAnchor, left: header.leftAnchor, bottom: header.bottomAnchor, right: header.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        friendsButton.anchor(header.topAnchor, left: nil, bottom: header.bottomAnchor, right: header.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 50, heightConstant: 50)
        border.frame.size.width = view.frame.width
        border.anchor(header.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        collectionView.anchor(border.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 1, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
}
