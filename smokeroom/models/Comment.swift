//
//  Comment.swift
//  smokeroom
//
//  Created by Austin Kim on 10/26/18.
//  Copyright © 2018 Austin Kim. All rights reserved.
//

import Foundation
import Firebase

class Comment {
    
    let text: String
    let userid: String
    let ghostname: Bool
    let date: String
    let conversationid: String
    
    init(text: String, userid: String, ghostname: Bool, conversationid: String) {
        self.text = text
        self.userid = userid
        self.ghostname = ghostname
        self.conversationid = conversationid
        self.date = Helper.shared.getDate()
    }
    
    init(text: String, userid: String, ghostname: Bool, conversationid: String, date: String) {
        self.text = text
        self.userid = userid
        self.ghostname = ghostname
        self.conversationid = conversationid
        self.date = date
    }
    
    func toAnyObject() -> AnyObject {
        return ["text" : text, "userid" : userid, "ghostname" : ghostname, "conversationid" : conversationid, "date" : date] as AnyObject
    }
    
}
