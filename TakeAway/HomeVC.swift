//
//  ViewController.swift
//  TakeAway
//
//  Created by kasper on 8/21/20.
//  Copyright © 2020 Mahmoud Abdul-Wahab. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        let loginStroyboard = UIStoryboard(name: "LoginVC", bundle: nil)
        let loginVC = loginStroyboard.instantiateViewController(withIdentifier: Storyboard.LoginVC) as! LoginVC
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}

