//
//  FriendsViewController.swift
//  smokeroom
//
//  Created by Austin Kim on 6/20/18.
//  Copyright © 2018 Austin Kim. All rights reserved.
//

import UIKit
import Firebase

class FriendsViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    var friendIDS: [String]! = [String]()
    var friends: [User]! = [User]()
    var userid: String!
    
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friendIDS.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FriendsCell
        Firestore.firestore().collection("users").document(friendIDS[indexPath.item]).getDocument { (document, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            }
            else{
                if let data = document?.data() {
                    let friend = User(name: (data["name"] as? String)!, username: (data["username"] as? String)!, ghostname: (data["ghostname"] as? String)!, email: (data["email"] as? String)!)
                    self.friends.append(friend)
                    cell.nameButton.setTitle(friend.name, for: .normal)
                    cell.usernameButton.setTitle(friend.username, for: .normal)
                }
            }
        }
        cell.usernameButton.addTarget(self, action: #selector(friendClickedButton(_:)), for: .touchUpInside)
        cell.nameButton.addTarget(self, action: #selector(friendClickedButton(_:)), for: .touchUpInside)
        cell.usernameButton.tag = indexPath.item
        cell.nameButton.tag = indexPath.item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
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
        collectionView.backgroundColor = UIColor(red: 220.0/255.0, green: 229.0/255.0, blue: 244.0/255.0, alpha: 1.0)
    }
    
    private func fetchConversations() {
        let query = Firestore.firestore().collection("friends").whereField("userid", isEqualTo: Auth.auth().currentUser?.uid as Any).order(by: "date", descending: true)
        query.getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.friendIDS = []
                for document in snapshot!.documents {
                    let data = document.data()
                    self.friendIDS.append(data["friend_id"] as! String)
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc func dismissButtonAction(_ sender:UIButton!){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func friendClickedButton(_ sender:UIButton!){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addButtonAction(_ sender:UIButton!){
        Helper.shared.showOKAlert(title: "blabla", message: "yblaha", viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(dismissButton)
        view.addSubview(titleLabel)
        view.addSubview(addButton)
        view.addSubview(collectionView)
        setupCollectionView()
        view.backgroundColor = .white
        dismissButton.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        titleLabel.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 200, heightConstant: 50)
        addButton.anchor(view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 70, heightConstant: 50)
        collectionView.anchor(dismissButton.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
}
