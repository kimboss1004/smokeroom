//
//  Conversation.swift
//  smokeroom
//
//  Created by Austin Kim on 6/3/18.
//  Copyright © 2018 Austin Kim. All rights reserved.
//

import Foundation
import Firebase

class Conversation {
    
    let text: String
    let userid: String
    let ghostname: Bool
    var buzz: Int
    let views: Int
    let date: String
    
    init(text: String, userid: String, ghostname: Bool) {
        self.text = text
        self.userid = userid
        self.ghostname = ghostname
        self.buzz = 0
        self.views = 0
        self.date = Helper.shared.getDate()
    }
    
    init(text: String, userid: String, buzz: Int, ghostname: Bool, date: String) {
        self.text = text
        self.userid = userid
        self.ghostname = ghostname
        self.buzz = buzz
        self.views = 0
        self.date = Helper.shared.formatStringToUserTime(stringDate: date)
    }
    
    init(snapshot : DataSnapshot){
        let snapValue = snapshot.value as? NSDictionary
        if let text = snapValue?["text"] as? String {
            self.text = text
        }else{
            text = ""
        }
        if let userid = snapValue?["userid"] as? String {
            self.userid = userid
        }else{
            userid = ""
        }
        if let ghostname = snapValue?["ghostname"] as? Bool {
            self.ghostname = ghostname
        }else{
            ghostname = false
        }
        if let buzz = snapValue?["buzz"] as? Int {
            self.buzz = buzz
        }else{
            buzz = 0
        }
        if let views = snapValue?["views"] as? Int {
            self.views = views
        }else{
            views = 0
        }
        if let date = snapValue?["date"] as? String {
            self.date = date
        }else{
            date = ""
        }
    }
    
    func toAnyObject() -> AnyObject {
        return ["text" : text, "userid" : userid, "ghostname" : ghostname, "buzz" : buzz, "views" : views, "date" : date] as AnyObject
    }
    
}
