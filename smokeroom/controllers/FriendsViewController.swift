//
//  FriendsViewController.swift
//  smokeroom
//
//  Created by Austin Kim on 6/20/18.
//  Copyright © 2018 Austin Kim. All rights reserved.
//

import UIKit
import Firebase
import InstantSearch

class FriendsViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    var friendIDS: [String]! = [String]()
    var potentialFriendIDS: [String]! = [String]()
    var friendRequestIDS: [String]! = [String]() // matching pair for potentialFriendIDS
    var userid: String!
    let db = Firestore.firestore()
    
    lazy var SearchVC: SearchViewController = {
        let view = SearchViewController()
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 20)
        label.text = "Friends"
        
        return label
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.setTitleColor(UIColor(red: 31.0/255.0, green: 111.0/255.0, blue: 239.0/255.0, alpha: 1.0), for: .normal)
        button.frame.size = CGSize(width: 40, height: 40)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(addButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "left"), for: .normal)
        button.addTarget(self, action: #selector(dismissButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    // CollectionView methods ----------------------------------------------------------------------------
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return potentialFriendIDS.count
        }
        else //if section == 1
        {
            return friendIDS.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // section 1 is for friendsCells
        if indexPath.section == 1 { // this section is for your confirmed friends
            let friendCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FriendsCell
            Firestore.firestore().collection("users").document(friendIDS[indexPath.item]).getDocument { (document, error) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                }
                else{
                    if let data = document?.data() {
                        friendCell.nameButton.setTitle((data["name"] as? String)!, for: .normal)
                        friendCell.usernameButton.setTitle((data["username"] as? String)!, for: .normal)
                        if (data["profile_url"] as? String)! == "" {
                            friendCell.profile.image = UIImage(named: "avatar")
                        }
                        else{
                            friendCell.profile.loadImageUsingCacheWithUrlString((data["profile_url"] as? String)!)
                        }
                    }
                }
            }
            friendCell.usernameButton.addTarget(self, action: #selector(friendClickedButton(_:)), for: .touchUpInside)
            friendCell.nameButton.addTarget(self, action: #selector(friendClickedButton(_:)), for: .touchUpInside)
            friendCell.usernameButton.tag = indexPath.item
            friendCell.nameButton.tag = indexPath.item
            return friendCell
        }
        else {
            // other section is for friend requests that are pending
            let friendRequestCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendRequestCell", for: indexPath) as! FriendRequestCell
            Firestore.firestore().collection("users").document(potentialFriendIDS[indexPath.item]).getDocument { (document, error) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                }
                else{
                    if let data = document?.data() {
                        friendRequestCell.nameButton.setTitle((data["name"] as? String)!, for: .normal)
                        friendRequestCell.usernameButton.setTitle((data["username"] as? String)!, for: .normal)
                    }
                }
            }
            friendRequestCell.usernameButton.addTarget(self, action: #selector(potentialFriendClickedButton(_:)), for: .touchUpInside)
            friendRequestCell.nameButton.addTarget(self, action: #selector(potentialFriendClickedButton(_:)), for: .touchUpInside)
            friendRequestCell.acceptFriendRequestButton.addTarget(self, action: #selector(acceptFriendButtonAction(_:)), for: .touchUpInside)
            friendRequestCell.usernameButton.tag = indexPath.item
            friendRequestCell.nameButton.tag = indexPath.item
            friendRequestCell.acceptFriendRequestButton.tag = indexPath.item
            return friendRequestCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func setupCollectionView(){
        // create collections view for conversations
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FriendsCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(FriendRequestCell.self, forCellWithReuseIdentifier: "FriendRequestCell")
        collectionView.backgroundColor = UIColor(red: 220.0/255.0, green: 229.0/255.0, blue: 244.0/255.0, alpha: 1.0)
    }
    
    private func fetchFriendsAndRequests() {
        self.friendIDS = []
        self.potentialFriendIDS = []
        self.friendRequestIDS = []
        // should be named friend_request_objects__ instead...
        let friend_requests_by_currentuser_query = db.collection("friendrequests").whereField("userid", isEqualTo: userid as Any)
        friend_requests_by_currentuser_query.getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in snapshot!.documents {
                    let data = document.data()
                    // if friendrequest confirmed, then friends == true
                    if data["confirmed"] as! Bool == true {
                        self.friendIDS.append(data["friendid"] as! String)
                    }
                }
                // now look for next type of friend requests
                let friend_requests_for_currentuser_query = self.db.collection("friendrequests").whereField("friendid", isEqualTo: self.userid as Any)
                friend_requests_for_currentuser_query.getDocuments { (snapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in snapshot!.documents {
                            let data = document.data()
                            // if friendrequest confirmed, then friends == true
                            if data["confirmed"] as! Bool == true {
                                self.friendIDS.append(data["userid"] as! String)
                            }
                            else { // otherwise, it is still a pending friend request
                                // only if the current user is the subject of this FriendsController page
                                if self.userid == Auth.auth().currentUser?.uid {
                                    self.friendRequestIDS.append(document.documentID)
                                    self.potentialFriendIDS.append(data["userid"] as! String)
                                }
                            }
                        }
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    @objc func dismissButtonAction(_ sender:UIButton!){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func friendClickedButton(_ sender:UIButton!){
        let accountVC = AccountViewController()
        accountVC.accountid = friendIDS[sender.tag]
        self.present(accountVC, animated: true, completion: nil)
    }
    
    @objc func potentialFriendClickedButton(_ sender:UIButton!){
        let accountVC = AccountViewController()
        accountVC.accountid = potentialFriendIDS[sender.tag]
        self.present(accountVC, animated: true, completion: nil)
    }

    @objc func acceptFriendButtonAction(_ sender:UIButton!){
        db.collection("friendrequests").document(friendRequestIDS[sender.tag]).updateData(["confirmed": true]) { (error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
            else {
                let notification = Notification(userid: self.potentialFriendIDS[sender.tag], type: "FriendRequest", type_id: (Auth.auth().currentUser?.uid)!, message: Helper.currentUser.name + " accepted your friend request")
                self.db.collection("notifications").addDocument(data: notification.toAnyObject() as! [String: Any])
                self.fetchFriendsAndRequests()
                Helper.shared.showOKAlert(title: "Friend Accepted", message: "Woohoo, new friend!", viewController: self)
                //on success reload collectionview
            }
            
        }
    }
    
    @objc func addButtonAction(_ sender:UIButton!){
        self.present(SearchVC, animated: true, completion:  nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchFriendsAndRequests()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        view.addSubview(dismissButton)
        view.addSubview(titleLabel)
        view.addSubview(addButton)
        view.addSubview(collectionView)
        view.backgroundColor = .white
        dismissButton.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        titleLabel.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 200, heightConstant: 50)
        addButton.anchor(view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 70, heightConstant: 50)
        collectionView.anchor(dismissButton.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
}

// algolia index importing
//        let client = Client(appID: "NZJAE708OM", apiKey: "61672ad893ddeeb69532d2cd146c7913")
//        let index = client.index(withName: "users")
//        let query = Firestore.firestore().collection("users")
//        query.getDocuments { (snapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in snapshot!.documents {
//                    let data = document.data()
//                    index.addObject(["name" : data["name"] as! String, "username" : data["username"] as! String, "email" : data["email"] as! String], withID: document.documentID)
//                }
//                self.collectionView.reloadData()
//            }
//        }
