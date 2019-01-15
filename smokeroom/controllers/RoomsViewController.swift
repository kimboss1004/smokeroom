//
//  HomeViewController.swift
//  smokeroom
//
//  Created by Austin Kim on 6/7/18.
//  Copyright © 2018 Austin Kim. All rights reserved.
//

import UIKit
import Firebase


class RoomsViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    var db = Firestore.firestore()
    var allConversations: [Conversation]! = [Conversation]()
    var conversation_ids: [String]! = [String]()
    var newsfeed: [String: Conversation] = [String: Conversation]()
    
    var createVC: CreateViewController!
    
    lazy var conversationVC: ConversationViewController = {
        let view = ConversationViewController()
        return view
    }()
    
    var usersReference: CollectionReference!
    
    // Top Navbar items --------------------------------------
    let header: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.0, green: 170.0/255, blue: 232.0/255, alpha: 1.0)
        return view
    }()
    
    let composeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Post", for: .normal)
        button.frame.size = CGSize(width: 40, height: 40)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(createButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    let homeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Home", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.frame.size = CGSize(width: 40, height: 40)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(homeClickedButton(_:)), for: .touchUpInside)
        return button
    }()
    
    let titleImageView: UIImageView = {
        let imageView =  UIImageView(image: #imageLiteral(resourceName: "logo"))
        imageView.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // CollectionView methods ----------------------------------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allConversations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ConversationCell
        let conversation = allConversations[indexPath.item]
        usersReference.document(conversation.userid).getDocument { (document, error) in
            if error != nil { return }
            else{
                if let data = document?.data() {
                    let user = User(name: data["name"] as! String, username: data["username"] as! String, ghostname: data["ghostname"] as! String, email: data["email"] as! String, profile_url: data["profile_url"] as! String)
                    if conversation.ghostname {
                        cell.nameLabel.text = "Ghost"
                        cell.usernameLabel.text = user.ghostname
                        cell.profile.image = #imageLiteral(resourceName: "logo")
                    }
                    else{ // if not a ghost post
                        cell.nameLabel.text = user.name
                        cell.usernameLabel.text = "@" + user.username
                        // download & set profile
                        if user.profile_url != "" {
                            cell.profile.loadImageUsingCacheWithUrlString(user.profile_url)
                        }
                        else { // if you don't set each image, one ring will rule them all
                            cell.profile.image = #imageLiteral(resourceName: "avatar")
                        }
                    }
                }
            }
        }
        if conversation.imageUrl != "" {
            cell.imageView.loadImageUsingCacheWithUrlString(conversation.imageUrl)
            cell.imageButton.tag = indexPath.item
            cell.imageButton.addTarget(self, action: #selector(conversationClickedButtonAction(_:)), for: .touchUpInside)
        }
        else {
            cell.imageView.image = UIImage()
        }
        cell.textLabel.addTarget(self, action: #selector(conversationClickedButtonAction(_:)), for: .touchUpInside)
        cell.textLabel.tag = indexPath.item
        cell.buzz.text = String(conversation.buzz)
        cell.textLabel.setTitle(conversation.text, for: .normal)
        cell.dateLabel.text = Helper.shared.formatStringToUserTime(stringDate: conversation.date)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let approximateWidthOfBioTextView = view.frame.width - 180;
        let size = CGSize(width: approximateWidthOfBioTextView, height: 1000)
        let attributes = [kCTFontAttributeName: UIFont.systemFont(ofSize: 15)]
        let conversation = allConversations[indexPath.item] as Conversation
        let estimateFrame = NSString(string: conversation.text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes as [NSAttributedStringKey : Any], context: nil)
        // if conversation contains an image, adjust cell size
        if conversation.imageUrl == "" {
            return CGSize(width: view.frame.width, height: estimateFrame.height + 110)
        }
        else {
            // we add the width, because the image height is equal to width (square)
            return CGSize(width: view.frame.width, height: estimateFrame.height + 110 + view.frame.size.width)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func setupCollectionView(){
        // create collections view for conversations
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 3, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: 90, height: 120)
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ConversationCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
    }
    
// button actions ---------------------------------------------------------------------------------------
    
    @objc func createButtonAction(_ sender:UIButton!) {
        createVC = CreateViewController()
        self.present(createVC, animated: true, completion: nil)
    }
    
    @objc func conversationClickedButtonAction(_ sender:UIButton!) {
        conversationVC = ConversationViewController()
        conversationVC.conversation = allConversations[sender.tag]
        conversationVC.conversationid = conversation_ids[sender.tag]
        self.present(conversationVC, animated: false, completion: nil)
    }
    
    // if image clicked, present the conversation controller
    @objc func imageClickedAction(_ sender:UIImageView!) {
        conversationVC = ConversationViewController()
        conversationVC.conversation = allConversations[sender.tag]
        conversationVC.conversationid = conversation_ids[sender.tag]
        self.present(conversationVC, animated: false, completion: nil)
    }
    
    @objc func selectProfileViewAction(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func homeClickedButton(_ sender:UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
// news feed fectching --------------------------------------------------------------------
    
    private func fetchNewsfeed() {
        // reset newsfeed to nil
        self.newsfeed = [String: Conversation]()
        // method below adds my posts to collections, and at the end it calls a chain of fetch methods
        fetchMyConversations(userid: (Auth.auth().currentUser?.uid)!)
    }
    
    private func fetchMyConversations(userid: String) {
        let query = Firestore.firestore().collection("conversations").whereField("userid", isEqualTo: userid as Any).order(by: "date", descending: true)
        query.getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in snapshot!.documents {
                    let data = document.data()
                    self.newsfeed[(document.documentID)] = Conversation(text: data["text"] as! String, userid: data["userid"] as! String, buzz: data["buzz"] as! Int, ghostname: data["ghostname"] as! Bool, date: data["date"] as! String, imageUrl: data["imageUrl"] as! String)
                }
                self.startFetches()
            }
        }
    }
    
    private func startFetches(){
        // firestore find friends
        let friends_query = self.db.collection("friendrequests").whereField("userid", isEqualTo: Auth.auth().currentUser?.uid as Any)
        var friendIDS: [String] = []
        friends_query.getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in snapshot!.documents {
                    let data = document.data()
                    // if friendrequest confirmed, then friends == true
                    if data["confirmed"] as! Bool == true {
                        friendIDS.append(data["friendid"] as! String)
                    }
                }
                // now look for next type of friendrequests
                let friends_query_2 = self.db.collection("friendrequests").whereField("friendid", isEqualTo: Auth.auth().currentUser?.uid as Any)
                friends_query_2.getDocuments { (snapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in snapshot!.documents {
                            let data = document.data()
                            // if friendrequest confirmed, then friends == true
                            if data["confirmed"] as! Bool == true {
                                friendIDS.append(data["userid"] as! String)
                            }
                        }
                        // ------------------------ at this point, friendIDS[] has all of user's friends ---------------------------------------------
                        for id in friendIDS {
                            //get posts made by user's friends. Inside the following method, at the end, is another fetch method for related_posts
                            self.fetchFriendsConversations(userid: id)
                        }
                    }
                }
            }
        }
    }
    
    private func fetchFriendsConversations(userid: String) {
        let query = self.db.collection("conversations").whereField("userid", isEqualTo: userid).order(by: "date", descending: true)
        query.getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in snapshot!.documents {
                    let data = document.data()
                    self.newsfeed[(document.documentID)] = Conversation(text: data["text"] as! String, userid: data["userid"] as! String, buzz: data["buzz"] as! Int, ghostname: data["ghostname"] as! Bool, date: data["date"] as! String, imageUrl: data["imageUrl"] as! String)
                }
                // now get posts that freinds commented on.
                self.fetchRelatedConversations(userid: userid)
            }
        }
    }
    
    private func fetchRelatedConversations(userid: String) {
        self.db.collection("comments").whereField("userid", isEqualTo: userid).order(by: "date", descending: true).getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                // loop through all comments and get conversation ids they belong to
                var commented_conversation_ids = [String]()
                for document in snapshot!.documents {
                    let data = document.data()
                    commented_conversation_ids.append(data["conversationid"] as! String)
                }
                // make array unique (get rid of duplicate ids)
                commented_conversation_ids = Array(Set(commented_conversation_ids))
                // add to all conversations in array to newsfeed. For efficiency, on the last index of loop, call sort method on newsfeed
                for (index, conversation_id) in commented_conversation_ids.enumerated() {
                    self.db.collection("conversations").document(conversation_id).getDocument{ (document2, error) in
                        if error != nil {
                            print(error?.localizedDescription as Any)
                        }
                        else{
                            if let data2 = document2?.data() {
                                self.newsfeed[(document2?.documentID)!] = Conversation(text: data2["text"] as! String, userid: data2["userid"] as! String, buzz: data2["buzz"] as! Int, ghostname: data2["ghostname"] as! Bool, date: data2["date"] as! String, imageUrl: data2["imageUrl"] as! String)
                            }
                            // on last index of loop, sort the updated newsfeed
                            if index == (commented_conversation_ids.count - 1) {
                                self.sortNewsfeed()
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func sortNewsfeed() {
        // reset conversations storage to prevent duplication
        self.allConversations = []
        self.conversation_ids = []
        // sort newsfeed by most recent date. we must parse out the date in order to use sort properly on our Dictionary
        for (conv_id,conv) in (Array(self.newsfeed).sorted(by: { Helper.shared.DateComparisonFormat(stringDate: $0.value.date) > Helper.shared.DateComparisonFormat(stringDate: $1.value.date)})) {
            // add each date-sorted conversation to new array that we will use in collections
            self.allConversations.append(conv)
            self.conversation_ids.append(conv_id)
        }
        // refresh the collection view
        self.collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersReference = Firestore.firestore().collection("users")
        setupCollectionView()
        view.backgroundColor = .white
        view.addSubview(header)
        view.addSubview(collectionView)
        header.addSubview(titleImageView)
        header.addSubview(composeButton)
        header.addSubview(homeButton)
        
        header.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 80)
        titleImageView.anchor(header.topAnchor, left: header.leftAnchor, bottom: header.bottomAnchor, right: header.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 5, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        homeButton.anchor(header.topAnchor, left: header.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 70, heightConstant: 60)
        composeButton.anchor(header.topAnchor, left: header.rightAnchor, bottom: header.bottomAnchor, right: header.rightAnchor, topConstant: 20, leftConstant: -50, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 60)
        collectionView.anchor(header.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 1, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchNewsfeed()
    }
    
}






