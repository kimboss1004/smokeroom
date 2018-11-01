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
    
    var allConversations: [Conversation]! = [Conversation]()
    var conversationIDS: [String]! = [String]()
    
    lazy var createVC: CreateViewController = {
        let view = CreateViewController()
        return view
    }()
    
    lazy var conversationVC: ConversationViewController = {
        let view = ConversationViewController()
        return view
    }()
    
    var currentUser: User!
    
    var usersReference: CollectionReference!
    
    
    // Top Navbar items --------------------------------------
    let header: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let composeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "compose"), for: .normal)
        button.frame.size = CGSize(width: 40, height: 40)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(createButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    let homeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Home", for: .normal)
        button.frame.size = CGSize(width: 40, height: 40)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(homeClickedButton(_:)), for: .touchUpInside)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let titleImageView: UIImageView = {
        let imageView =  UIImageView(image: #imageLiteral(resourceName: "logo"))
        imageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
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
        cell.buzz.text = "buzz " + String(conversation.buzz)
        cell.textLabel.setTitle(conversation.text, for: .normal)
        cell.dateLabel.text = conversation.date
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let approximateWidthOfBioTextView = view.frame.width - 180;
        let size = CGSize(width: approximateWidthOfBioTextView, height: 1000)
        let attributes = [kCTFontAttributeName: UIFont.systemFont(ofSize: 15)]
        let conversation = allConversations[indexPath.item] as Conversation
        //if let user = self.datasource?.item(indexPath) as? User {
        let estimateFrame = NSString(string: conversation.text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes as [NSAttributedStringKey : Any], context: nil)
        return CGSize(width: view.frame.width, height: estimateFrame.height + 80)
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
    
    // ---------------------------------------------------------------------------------------
    
    @objc func createButtonAction(_ sender:UIButton!)
    {
        self.present(createVC, animated: true, completion: nil)
    }
    
    @objc func conversationClickedButton(_ sender:UIButton!)
    {
        conversationVC.view = nil
        conversationVC.conversation = allConversations[sender.tag]
        conversationVC.conversationid = conversationIDS[sender.tag]
        self.present(conversationVC, animated: true, completion: nil)
    }
    
    @objc func homeClickedButton(_ sender:UIButton!)
    {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    private func fetchConversations() {
        let query = Firestore.firestore().collection("conversations").whereField("userid", isEqualTo: Auth.auth().currentUser?.uid as Any)
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersReference = Firestore.firestore().collection("users")
        setupCollectionView()
        fetchConversations()
        view.backgroundColor = .white
        view.addSubview(header)
        view.addSubview(collectionView)
        header.addSubview(titleImageView)
        header.addSubview(composeButton)
        header.addSubview(homeButton)
        
        header.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 60)
        titleImageView.anchor(header.topAnchor, left: header.leftAnchor, bottom: header.bottomAnchor, right: header.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        homeButton.anchor(header.topAnchor, left: header.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 70, heightConstant: 60)
        composeButton.anchor(header.topAnchor, left: header.rightAnchor, bottom: header.bottomAnchor, right: header.rightAnchor, topConstant: 0, leftConstant: -50, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        collectionView.anchor(header.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 1, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchConversations()
    }
    
    
    
    
}
