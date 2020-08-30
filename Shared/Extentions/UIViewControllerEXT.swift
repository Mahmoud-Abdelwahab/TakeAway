//
//  UIViewControllerEXT.swift
//  TakeAwayAdmin
//
//  Created by kasper on 8/22/20.
//  Copyright © 2020 Mahmoud Abdul-Wahab. All rights reserved.
//

import UIKit

extension UIViewController{
    
   
    
    
}


extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }

        return array
    }
}
