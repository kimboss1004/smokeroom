//
//  SearchViewController.swift
//  smokeroom
//
//  Created by Austin Kim on 12/19/18.
//  Copyright © 2018 Austin Kim. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var collectionView: UICollectionView!
    var friendIDS: [String]! = [String]()
    var friends: [User]! = [User]()
    
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
        cell.usernameButton.addTarget(self, action: #selector(friendClickedButtonAction(_:)), for: .touchUpInside)
        cell.nameButton.addTarget(self, action: #selector(friendClickedButtonAction(_:)), for: .touchUpInside)
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
    
    private func fetchUsers() {
        let query = Firestore.firestore().collection("users").whereField("userid", isEqualTo: Auth.auth().currentUser?.uid as Any).order(by: "date", descending: true)
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
    
    @objc func friendClickedButtonAction(_ sender:UIButton!){
        dismiss(animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()

    }
}
