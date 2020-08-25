//
//  Category.swift
//  TakeAway
//
//  Created by kasper on 8/24/20.
//  Copyright © 2020 Mahmoud Abdul-Wahab. All rights reserved.
//

import Foundation
import Firebase

struct Category {
    var id : String
    var name : String
    var imgURL : String
    var isActive : Bool = true
    var timeStamp : Timestamp
    
     init(data : [String :Any]) {
           self.id                 = data["id"] as? String ?? ""
           self.name               = data["name"] as? String ?? ""
           self.imgURL             = data["imgURL"] as? String ?? ""
           self.isActive           = data["isActive"] as? Bool   ?? true
           self.timeStamp          = data["timeStamp"] as? Timestamp ?? Timestamp()
       }
}
