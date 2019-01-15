//
//  AccountViewController.swift
//  smokeroom
//
//  Created by Austin Kim on 6/3/18.
//  Copyright © 2018 Austin Kim. All rights reserved.
//

import UIKit
import Firebase


class NotificationsViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    var notifications: [Notification] = [Notification]()
    let db = Firestore.firestore()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 20)
        label.text = "Notifications"
        
        return label
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "left"), for: .normal)
        button.addTarget(self, action: #selector(dismissButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var conversationVC: ConversationViewController = {
        let view = ConversationViewController()
        return view
    }()
    
    lazy var accountVC: AccountViewController = {
        let vc = AccountViewController()
        vc.accountid = Auth.auth().currentUser?.uid
        return vc
    }()
    
    // CollectionView methods ----------------------------------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let notificationCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! NotificationCell
        notificationCell.textButton.setTitle(notifications[indexPath.item].message, for: .normal)
        notificationCell.dateButton.setTitle(Helper.shared.formatStringToUserTime(stringDate: notifications[indexPath.item].date), for: .normal)
        // check if notification is a Conversation link
        notificationCell.textButton.tag = indexPath.item
        notificationCell.textButton.addTarget(self, action: #selector(notificationClickedButton(_:)), for: .touchUpInside)
        // set the image of notification icon
        if notifications[indexPath.item].type == "Conversation" || notifications[indexPath.item].type == "Comment" {
            notificationCell.iconButton.setImage(#imageLiteral(resourceName: "logo"), for: .normal)
        }
        else if notifications[indexPath.item].type == "FriendRequest" {
            notificationCell.iconButton.setImage(#imageLiteral(resourceName: "friends"), for: .normal)
        }
        return notificationCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let approximateWidthOfBioTextView = view.frame.width - 85;
        let size = CGSize(width: approximateWidthOfBioTextView, height: 1000)
        let attributes = [kCTFontAttributeName: UIFont.systemFont(ofSize: 15)]
        let notification = notifications[indexPath.item] as Notification
        let estimateFrame = NSString(string: notification.message).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes as [NSAttributedStringKey : Any], context: nil)
        return CGSize(width: view.frame.width, height: estimateFrame.height + 65)
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
        collectionView.register(NotificationCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = .white
    }
    
    private func fetchNotifications() {
        self.notifications = []
        let query = Firestore.firestore().collection("notifications").whereField("userid", isEqualTo: Auth.auth().currentUser?.uid as Any).order(by: "date", descending: true)
        query.getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in snapshot!.documents {
                    let data = document.data()
                    self.notifications.append(Notification(userid: data["userid"] as! String, type: data["type"] as! String, type_id: data["type_id"] as! String, message: data["message"] as! String, viewed: data["viewed"] as! Bool, date: data["date"] as! String))
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc func dismissButtonAction(_ sender:UIButton!){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func friendNotifcationClickedButton(_ sender:UIButton!){
        accountVC = AccountViewController()
        accountVC.accountid = notifications[sender.tag].type_id
        self.present(accountVC, animated: true, completion: nil)
    }
    
    @objc func notificationClickedButton(_ sender:UIButton!){
        // depending on the type, do corresponding action. This code will only work in here and nowhere else for some mysterious reason. Or at least, you can only allow there to be one button action assigned to collection cells. cant have multiple button actions for dynamic cells.
        if notifications[sender.tag].type == "Conversation" || notifications[sender.tag].type == "Comment" {
            self.db.collection("conversations").document(notifications[sender.tag].type_id).getDocument { (document, error) in
                if error == nil {
                    if let data = document?.data() {
                        self.conversationVC = ConversationViewController()
                        self.conversationVC.conversationid = document?.documentID
                        self.conversationVC.conversation = Conversation(text: data["text"] as! String, userid: data["userid"] as! String, buzz: data["buzz"] as! Int, ghostname: data["ghostname"] as! Bool, date: data["date"] as! String, imageUrl: data["imageUrl"] as! String)
                        self.present(self.conversationVC, animated: false, completion: nil)
                    }
                }
            }
        }
        else if notifications[sender.tag].type == "FriendRequest" {
            accountVC = AccountViewController()
            accountVC.accountid = notifications[sender.tag].type_id
            self.present(accountVC, animated: false, completion: nil)
        }
    
    }

    override func viewDidAppear(_ animated: Bool) {
        fetchNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        view.addSubview(dismissButton)
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.backgroundColor = .white
        dismissButton.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        titleLabel.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 200, heightConstant: 50)
        collectionView.anchor(dismissButton.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
}
