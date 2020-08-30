//
//  Products.swift
//  TakeAway
//
//  Created by kasper on 8/23/20.
//  Copyright © 2020 Mahmoud Abdul-Wahab. All rights reserved.
//

import UIKit
import FirebaseFirestore
import RealmSwift
//: NSObject, NSCoding

@objcMembers
class Products : Object
{
    dynamic var name: String? = nil
    dynamic var categoryId: String? = nil
    dynamic var productDescription: String? = nil
    dynamic var imgURL: String? = nil
    var timeStamp: Timestamp? = nil
     dynamic var price =  RealmOptional<Double>()
    dynamic var stock =  RealmOptional<Int>()
    
    
    override class func ignoredProperties() -> [String] {
        return ["timeStamp"]
    }
    
    static func productToDictionary(with product : Products)-> [String : Any]
    {
        return [
            "categoryId"            : product.categoryId! ,
            "name"                  : product.name!,
            "price"                 : product.price ,
            "productDescription"    : product.productDescription!,
            "imgURL"                : product.imgURL! ,
            "timeStamp"             : product.timeStamp!,
            "stock"                 : product.stock,
        ]
    }
    
    required init() {
        
    }
    
    init(name: String , categoryId : String
        , price : Double
        , productDescription : String
        , imgURL : String
        , timeStamp :Timestamp
        , stock : Int) {
        self.name                 = name
        self.categoryId           = categoryId
        self.price.value          = price
        self.productDescription   = productDescription
        self.imgURL               = imgURL
        self.timeStamp            = timeStamp
        self.stock.value          = stock
    }
    //        required  init?(coder aDecoder: NSCoder) {
    //
    //            self.name = (aDecoder.decodeObject(forKey: "name") as! String)
    //            self.categoryId = aDecoder.decodeObject(forKey: "categoryId") as? String
    //            self.price = (aDecoder.decodeObject(forKey: "price") as? Double)!
    //            self.productDescription = aDecoder.decodeObject(forKey: "productDescription") as? String
    //            self.imgURL = aDecoder.decodeObject(forKey: "imgURL") as? String
    //            self.timeStamp = aDecoder.decodeObject(forKey: "timeStamp") as? Timestamp
    //            self.stock = aDecoder.decodeObject(forKey: "stock") as? Int
    //
    //
    //
    //
    ////       self.init(name: name , categoryId : categoryId
    ////        , price : price
    ////       , productDescription : productDescription
    ////       , imgURL : imgURL
    ////       , timeStamp :timeStamp
    ////       , stock : stock)
    //    }
    //    func encode(with acoder: NSCoder) {
    //
    //         acoder.encode(name,forKey: "name")
    //         acoder.encode(categoryId,forKey: "categoryId")
    //         acoder.encode(price,forKey: "price")
    //         acoder.encode(productDescription,forKey: "productDescription")
    //         acoder.encode(imgURL,forKey: "imgURL")
    //         acoder.encode(timeStamp,forKey: "timeStamp")
    //         acoder.encode(stock,forKey: "stock")
    //    }
    
    static func == (lhs: Products, rhs: Products) -> Bool {
        return lhs.name == rhs.name 
    }
    
    
    
    init(data : [String :Any]) {
        self.categoryId         = data["categoryId"] as? String ?? ""
        self.name               = data["name"] as? String ?? ""
        self.price.value              = data["price"] as? Double   ?? 0.0
        self.productDescription = data["productDescription"] as? String ?? ""
        self.imgURL             = data["imgURL"] as? String ?? ""
        self.timeStamp          = data["timeStamp"] as? Timestamp
        self.stock.value              = data["stock"] as? Int ?? 0
    }
    
    
}
