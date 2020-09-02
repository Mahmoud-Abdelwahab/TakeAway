//
//  UIViewControllerEXT.swift
//  TakeAwayAdmin
//
//  Created by kasper on 8/22/20.
//  Copyright © 2020 Mahmoud Abdul-Wahab. All rights reserved.
//

import UIKit

extension UIViewController{
    
    func showAlert(title : String , message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert , animated:  true)
    }
    
    
}

