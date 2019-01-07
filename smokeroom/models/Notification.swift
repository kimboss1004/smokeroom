//
//  Notification.swift
//  smokeroom
//
//  Created by Austin Kim on 1/5/19.
//  Copyright © 2019 Austin Kim. All rights reserved.
//

import UIKit

class Notification {
    let userid: String
    let type: String
    let type_id: String
    let message: String
    let date: String
    let viewed: Bool
    
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
