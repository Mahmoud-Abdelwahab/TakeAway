//
//  ForgetPasswordVC.swift
//  TakeAway
//
//  Created by kasper on 8/24/20.
//  Copyright © 2020 Mahmoud Abdul-Wahab. All rights reserved.
//

import UIKit
import Firebase

class ForgetPasswordVC: UIViewController {

    @IBOutlet weak var confirmeEmailField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func didTapConfirmeBtn(_ sender: Any) {
        guard  let email = confirmeEmailField.text , email.isNotEmpty else {
            print("please Enter your Email")
            return
        }
        
                Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
                   guard let strongSelf = self else { return }
                             guard error == nil else {
                                 print(error?.localizedDescription ?? " something went wrong")
                                 return
                             }
                    strongSelf.dismiss(animated: true, completion: nil)
                }
        
    }
    
}
