//
//  User.swift
//  Healthify
//
//  Created by Himanshu Joshi on 18/09/20.
//  Copyright © 2020 Himanshu Joshi. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var id: String?
    var name: String?
    var email: String?
    
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
    }
    
}
