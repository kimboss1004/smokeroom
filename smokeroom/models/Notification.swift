//
//  Notification.swift
//  smokeroom
//
//  Created by Austin Kim on 1/5/19.
//  Copyright © 2019 Austin Kim. All rights reserved.
//

import UIKit

class Notification {
    var userid: String
    var type: String
    var type_id: String
    var message: String
    var date: String
    var viewed: Bool
    
    init(userid: String, type: String, type_id: String, message: String) {
        self.userid = userid
        self.type = type
        self.type_id = type_id
        self.message = message
        self.viewed = false
        self.date = Helper.shared.getDate()
    }
    
    init(userid: String, type: String, type_id: String, message: String, viewed: Bool, date: String) {
        self.userid = userid
        self.type = type
        self.type_id = type_id
        self.message = message
        self.viewed = viewed
        self.date = date
    }
    
    func toAnyObject() -> AnyObject {
        return ["userid" : userid, "type" : type, "type_id" : type_id, "message" : message, "viewed" : viewed, "date" : date] as AnyObject
    }
}
