//
//  AccountViewController.swift
//  smokeroom
//
//  Created by Austin Kim on 6/3/18.
//  Copyright © 2018 Austin Kim. All rights reserved.
//

import UIKit


class AccountViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    
    lazy var settingVC: SettingViewController = {
        let view = SettingViewController()
        return view
    }()
    
    lazy var friendsVC: FriendsViewController = {
        let view = FriendsViewController()
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
    
    let settingButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "setting"), for: .normal)
        button.frame.size = CGSize(width: 40, height: 40)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(settingsButtonAction(_:)), for: .touchUpInside)
        return button
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
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 20.0)
        label.text = "@Kimboss1004"
        return label
    }()
    
    let border: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220.0/255.0, green: 229.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        return view
    }()
    
    // info bar -------------------------------
    
    let infoBar: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let nameContainer: UIView = {
        let view = UIView()
        view.layer.borderWidth =  1
        view.layer.borderColor = UIColor(red: 146/255, green: 168/255, blue: 204/255, alpha:1.0).cgColor
        return view
    }()
    
    let firstName: UILabel = {
       let label = UILabel()
        label.text = "Austin"
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let lastName: UILabel = {
        let label = UILabel()
        label.text = "Kim"
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let postsContainer: UIView = {
        let view = UIView()
        view.layer.borderWidth =  1
        view.layer.borderColor = UIColor(red: 146/255, green: 168/255, blue: 204/255, alpha:1.0).cgColor
        return view
    }()
    
    let postsLabel: UILabel = {
        let label = UILabel()
        label.text = "Posts"
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let postsNumLabel: UILabel = {
        let label = UILabel()
        label.text = "45"
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let friendsContainer: UIView = {
        let view = UIView()
        view.layer.borderWidth =  1
        view.layer.borderColor = UIColor(red: 146/255, green: 168/255, blue: 204/255, alpha:1.0).cgColor
        return view
    }()
    
    let friendsLabel: UIButton = {
        let button = UIButton()
        button.setTitle("Friends", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(friendsButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    let friendsNumLabel: UIButton = {
        let button = UIButton()
        button.setTitle("120", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    // CollectionView methods ----------------------------------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let approximateWidthOfBioTextView = view.frame.width - 180;
        let size = CGSize(width: approximateWidthOfBioTextView, height: 1000)
        let attributes = [kCTFontAttributeName: UIFont.systemFont(ofSize: 15)]
        //if let user = self.datasource?.item(indexPath) as? User {
        let estimateFrame = NSString(string: conversation.text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes as [NSAttributedStringKey : Any], context: nil)
        return CGSize(width: view.frame.width, height: estimateFrame.height + 85)
        //}
        // return CGSize(width: view.frame.width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupInfoBar()
        view.backgroundColor = .white
        view.addSubview(header)
        view.addSubview(border)
        view.addSubview(infoBar)
        view.addSubview(collectionView)
        
        header.addSubview(headerTitle)
        header.addSubview(settingButton)
        header.addSubview(friendsButton)
        
        header.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 15, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        headerTitle.anchor(header.topAnchor, left: header.leftAnchor, bottom: header.bottomAnchor, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        settingButton.anchor(header.topAnchor, left: nil, bottom: header.bottomAnchor, right: header.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 50, heightConstant: 50)
        friendsButton.anchor(header.topAnchor, left: nil, bottom: header.bottomAnchor, right: settingButton.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 50, heightConstant: 50)

        border.frame.size.width = view.frame.width
        border.anchor(header.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        
        infoBar.anchor(border.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 80)
        nameContainer.anchor(infoBar.topAnchor, left: infoBar.leftAnchor, bottom: infoBar.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.width/3, heightConstant: 0)
        firstName.anchor(nameContainer.topAnchor, left: nameContainer.leftAnchor, bottom: nil, right: nameContainer.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        lastName.anchor(nil, left: nameContainer.leftAnchor, bottom: nameContainer.bottomAnchor, right: nameContainer.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        friendsContainer.anchor(infoBar.topAnchor, left: nil, bottom: infoBar.bottomAnchor, right: infoBar.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.width/3, heightConstant: 0)
        friendsLabel.anchor(friendsContainer.topAnchor, left: friendsContainer.leftAnchor, bottom: nil, right: friendsContainer.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        friendsNumLabel.anchor(nil, left: friendsContainer.leftAnchor, bottom: friendsContainer.bottomAnchor, right: friendsContainer.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        postsContainer.anchor(infoBar.topAnchor, left: nameContainer.rightAnchor, bottom: infoBar.bottomAnchor, right: friendsContainer.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        postsLabel.anchor(postsContainer.topAnchor, left: postsContainer.leftAnchor, bottom: nil, right: postsContainer.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        postsNumLabel.anchor(nil, left: postsContainer.leftAnchor, bottom: postsContainer.bottomAnchor, right: postsContainer.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        
        collectionView.anchor(infoBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 1, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func setupCollectionView(){
        // create collections view for conversations
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 120)
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ConversationCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor(red: 220.0/255.0, green: 229.0/255.0, blue: 244.0/255.0, alpha: 1.0)
    }
    
    func setupInfoBar() {
        infoBar.addSubview(nameContainer)
        nameContainer.addSubview(firstName)
        nameContainer.addSubview(lastName)
        infoBar.addSubview(postsContainer)
        postsContainer.addSubview(postsLabel)
        postsContainer.addSubview(postsNumLabel)
        infoBar.addSubview(friendsContainer)
        friendsContainer.addSubview(friendsLabel)
        friendsContainer.addSubview(friendsNumLabel)
    }
    
    
    @objc func settingsButtonAction(_ sender:UIButton!)
    {
        self.present(settingVC, animated: true, completion: nil)
    }
    
    @objc func friendsButtonAction(_ sender:UIButton!)
    {
        self.present(friendsVC, animated: true, completion: nil)
    }
    
}
