//
//  FriendRequest.swift
//  smokeroom
//
//  Created by Austin Kim on 12/24/18.
//  Copyright © 2018 Austin Kim. All rights reserved.
//


import UIKit
import Firebase

class FriendRequest {
    
    let userid: String
    let friendid: String
    let confirmed: Bool
    
    init(userid: String, friendid: String, confirmed: Bool) {
        self.userid = userid
        self.friendid = friendid
        self.confirmed = confirmed
    }
    
    
    func toAnyObject() -> AnyObject {
        return ["userid" : userid, "friendid" : friendid, "confirmed" : confirmed] as AnyObject
    }
    
}
