//
//  SearchViewController.swift
//  smokeroom
//
//  Created by Austin Kim on 12/19/18.
//  Copyright © 2018 Austin Kim. All rights reserved.
//

import UIKit
import Firebase
import InstantSearch

class SearchViewController: HitsTableViewController {
    
    // for search->Account button functionality
    var userids: [String] = [String]()
    var accountVC: AccountViewController!
    // Create search widgets
    let searchBar = SearchBarWidget(frame: .zero)
    let tableView = HitsTableWidget(frame: .zero)
    
    let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "left"), for: .normal)
        button.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1.0)
        button.addTarget(self, action: #selector(dismissButtonAction(_:)), for: .touchUpInside)
        return button
    }()

    @objc func dismissButtonAction(_ sender:UIButton!){
        dismiss(animated: true, completion: nil)
    }
    
    func initUI() {
        // Add the declared views to the main view
        self.view.addSubview(searchBar)
        self.view.addSubview(tableView)
        self.view.addSubview(dismissButton)
        
        dismissButton.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 80, heightConstant: 80)
        searchBar.anchor(view.topAnchor, left: dismissButton.rightAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 80)
        tableView.anchor(searchBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        // Register tableView identifier
        tableView.register(FriendsTableCell.self, forCellReuseIdentifier: "hitCell")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing hit: [String : Any]) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hitCell", for: indexPath) as! FriendsTableCell
        // Adding touch link: from every search result -> User Account
        cell.nameButton.setTitle(hit["name"] as? String, for: .normal)
        cell.usernameButton.setTitle(hit["username"] as? String, for: .normal)
        cell.nameButton.addTarget(self, action: #selector(userClickedButton(_:)), for: .touchUpInside)
        cell.usernameButton.addTarget(self, action: #selector(userClickedButton(_:)), for: .touchUpInside)
        cell.nameButton.tag = indexPath.item
        cell.usernameButton.tag = indexPath.item
        // add userid to our array(userids) in which we will use later in combination with tag for button functionality
        userids.append((hit["objectID"] as? String)!)
        return cell
    }

    @objc func userClickedButton(_ sender:UIButton!){
        accountVC = AccountViewController()
        accountVC.accountid = userids[sender.tag]
        self.present(accountVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hitsTableView = tableView
        initUI()
        // Add all widgets to InstantSearch
        InstantSearch.shared.registerAllWidgets(in: self.view)
    }
}
