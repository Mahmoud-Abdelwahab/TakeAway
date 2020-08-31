//
//  RealmDBManager.swift
//  TakeAway
//
//  Created by kasper on 8/29/20.
//  Copyright © 2020 Mahmoud Abdul-Wahab. All rights reserved.
//

import RealmSwift

class RealmDBManager {
    
    static let shared = RealmDBManager()
    var realm : Realm!
    
    private init(){
        realm = try! Realm()
    }
    
    
    func getCartProducts() -> [Products] {
        let productList: Results<Products> = { self.realm.objects(Products.self) }()
        var array = [Products]()
        for i in 0 ..< productList.count {
            array.append(productList [i])
        }
        
        return array
    }
    
    
    func saveProductsCard(productList : [Products])  {
        try! realm.write() {
            for product in productList {
                self.realm.add(product)
            }
        }
    }
    
    func saveOneProduct(product : Products)  {
        try! realm.write() {
            self.realm.create(Products.self, value: product)
            // Reading from or modifying a `RealmOptional` is done via the `value` property
        }
    }
    
    func deleteAllProducts(){
        
        let objects = realm.objects(Products.self)
        
        try! realm.write {
            realm.delete(objects)
        }
    }
    
    
    func deleteOneProduct(product : Products) {
        let object = realm.objects(Products.self).filter("name = %@", product.name!).first
        
        
        if let obj = object {
            try! realm.write {
                self.realm.delete(obj)
            }
        }
    }
    
    
    func updateProductCount(with product : Products , number : Int){
         try! realm.write {
          product.amount.value = number
        }
    }
    
}

