//
//  LoginVC.swift
//  TakeAway
//
//  Created by kasper on 8/21/20.
//  Copyright © 2020 Mahmoud Abdul-Wahab. All rights reserved.
//

import UIKit
import Firebase


class LoginVC: UITableViewController {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser != nil {
                          dismiss(animated: true, completion: nil)
                      }
           print("will didload called")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("will appear called")
     
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
       print("did appear called")
      
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        guard  let email = emailField.text , email.isNotEmpty , let password = passwordField.text , password.isNotEmpty else {
                    print(" please fill the empty fields")
                   return
                   }
        
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            guard error == nil else {
                print(error?.localizedDescription ?? " something went wrong")
                return
            }
            
            print("Login successfully ")
            strongSelf.dismiss(animated: true, completion: nil)
        }
        
        
    }
  
    @IBAction func didTapRegisterBtn(_ sender: Any) {
        let registrationVC = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationVC") as! RegistrationVC
        registrationVC.modalPresentationStyle = .fullScreen
        registrationVC.dismissLogin = self
        present(registrationVC, animated: true, completion: nil)
        
    }
    
    @IBAction func didTapForgetPassword(_ sender: Any) {
        
        let forgetPasswordVC = ForgetPasswordVC()
        present(forgetPasswordVC ,animated:  true)
       }
       
    

}


extension LoginVC : IDismissLoginScreenDelegate {
    func dismissLogin()
    {
        self.dismiss(animated: true, completion: nil)
    }
}
