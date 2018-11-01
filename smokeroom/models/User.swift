//
//  User.swift
//  smokeroom
//
//  Created by Austin Kim on 6/20/18.
//  Copyright © 2018 Austin Kim. All rights reserved.
//

import UIKit
import Firebase

class User {
    
    var name: String
    var username: String
    var ghostname: String
    var email: String
    
    init(){
        self.name = ""
        self.username = ""
        self.ghostname = ""
        self.email = ""
    }
    
    init(name: String, username: String, ghostname: String, email: String){
        self.name = name
        self.username = username
        self.ghostname = ghostname
        self.email = email
    }
    
    init(snapshot : DataSnapshot){
        let snapValue = snapshot.value as? NSDictionary
        if let name = snapValue?["name"] as? String {
            self.name = name
        }else{
            name = ""
        }
        if let username = snapValue?["username"] as? String {
            self.username = username
        }else{
            username = ""
        }
        if let ghostname = snapValue?["ghostname"] as? String {
            self.ghostname = ghostname
        }else{
            ghostname = ""
        }
        if let email = snapValue?["email"] as? String {
            self.email = email
        }else{
            email = ""
        }
    }
    
    func toAnyObject() -> AnyObject {
        return ["name" : name, "username" : username, "ghostname" : ghostname, "email" : email] as AnyObject
    }
    
    
}

