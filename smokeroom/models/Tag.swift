//
//  Tag.swift
//  smokeroom
//
//  Created by Austin Kim on 1/3/19.
//  Copyright © 2019 Austin Kim. All rights reserved.
//

import UIKit
import Firebase

class Tag {
    
    let tagged_userid: String
    let conversation_id: String
    let date: String
    
    init(tagged_userid: String, conversation_id: String, date: String) {
        self.tagged_userid = tagged_userid
        self.conversation_id = conversation_id
        self.date = date
    }
    
    init(tagged_userid: String, conversation_id: String) {
        self.tagged_userid = tagged_userid
        self.conversation_id = conversation_id
        self.date = Helper.shared.getDate()
    }
    
    
    func toAnyObject() -> AnyObject {
        return ["tagged_userid" : tagged_userid, "conversation_id" : conversation_id, "date" : date] as AnyObject
    }
    
}
