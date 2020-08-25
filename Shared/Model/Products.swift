//
//  Products.swift
//  TakeAway
//
//  Created by kasper on 8/23/20.
//  Copyright © 2020 Mahmoud Abdul-Wahab. All rights reserved.
//

import UIKit
import FirebaseFirestore

 //: NSObject, NSCoding
class Products  {
    
    var categoryId : String?
    var name : String?
    var price : Double
    var productDescription : String?
    var imgURL : String?
    var timeStamp :Timestamp?
    var stock : Int?
    
    init(data : [String :Any]) {
        self.categoryId         = data["categoryId"] as? String ?? ""
        self.name               = data["name"] as? String ?? ""
        self.price              = data["price"] as? Double   ?? 0.0
        self.productDescription = data["productDescription"] as? String ?? ""
        self.imgURL             = data["imgURL"] as? String ?? ""
        self.timeStamp          = data["timeStamp"] as? Timestamp
        self.stock              = data["stock"] as? Int ?? 0
    }
    
    
}
