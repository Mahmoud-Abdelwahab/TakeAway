//
//  UIViewControllerEXT.swift
//  TakeAwayAdmin
//
//  Created by kasper on 8/22/20.
//  Copyright © 2020 Mahmoud Abdul-Wahab. All rights reserved.
//

import UIKit

extension UIViewController{
    
    func saveProductsInUserDefault(with product  : [Products] , Key : String){
         UserDefaults.standard.set( product, forKey: key)
    }
    
    func getProductsFromUserDefault(key : String ) -> [Products] {
       return  UserDefaults.standard.object(forKey: key) as? [Products] ?? []
        
    }
    
    
}
