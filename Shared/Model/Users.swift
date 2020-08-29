//
//  Users.swift
//  TakeAway
//
//  Created by kasper on 8/23/20.
//  Copyright © 2020 Mahmoud Abdul-Wahab. All rights reserved.
//

import UIKit

struct  Users {
    
    let id : String
    let name : String
    let email : String
    var stripeId : String
    
    init(id : String = "" , name : String = "" , email : String = "" , stripeId : String = "") {
        self.id                  = id
        self.name                = name
        self.email               = email
        self.stripeId            = stripeId
    }
    
    init(data : [String :Any]) {
          self.id                = data["id"] as? String ?? ""
          self.name              = data["name"] as? String ?? ""
          self.email             = data["email"] as? String ?? ""
          self.stripeId          = data["stripeId"] as? String ?? ""
    }
    
}
