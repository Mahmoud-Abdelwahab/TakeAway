//
//  RegistrationVC.swift
//  TakeAway
//
//  Created by kasper on 8/21/20.
//  Copyright © 2020 Mahmoud Abdul-Wahab. All rights reserved.
//

import UIKit
import Firebase

class RegistrationVC: UITableViewController {
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var checkConfirmPasswordImage: UIImageView!
    @IBOutlet weak var checkPasswordImage: UIImageView!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
   
    weak var dismissLogin : IDismissLoginScreenDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPasswordFieldsEventListener()
        
        
    }
    
    
    private func  addPasswordFieldsEventListener(){
        passwordField.addTarget(self, action: #selector(textFieldDidChanged), for: UIControl.Event.editingChanged)
        
        confirmPasswordField.addTarget(self, action: #selector(textFieldDidChanged), for: UIControl.Event.editingChanged)// this func will be called eveytime the text is changed
    }
    
    
    @objc private func textFieldDidChanged(_ textField : UITextField){
        
        guard  let password = passwordField.text else {
            return
        }
        
        if textField == confirmPasswordField {
            checkPasswordImage.isHidden = false
            checkConfirmPasswordImage.isHidden = false
        }else{
            if password.isEmpty{
                checkConfirmPasswordImage.isHidden = true
                checkPasswordImage.isHidden = true
                confirmPasswordField.text = ""
            }
        }
        
        if passwordField.text == confirmPasswordField.text {
            checkPasswordImage.image = UIImage(named: "check-green")
            checkConfirmPasswordImage.image = UIImage(named: "check-green")
        }else{
            checkPasswordImage.image = UIImage(named: "uncheck-red")
            checkConfirmPasswordImage.image = UIImage(named: "uncheck-red")
        }
    }
    
    
    @IBAction func didTapRegister(_ sender: Any) {
        guard  let username = usernameField.text , username.isNotEmpty , let email = emailField.text , email.isNotEmpty , let password = passwordField.text , password.isNotEmpty else {
            print(" please fill the empty fields")
            return
        }
        
        guard checkConfirmPasswordImage.image ==  UIImage(named: "check-green") else {
            print(" Password doesn't matches ")
            return
        }
        
        
        Auth.auth().createUser(withEmail: email, password: password) {[weak self ] authResult, error in
            
            guard let self = self else { return}
            guard error == nil else{
                debugPrint(error.debugDescription)
                return
            }
            print("******** Successfully Created ********")
            
            self.addNewUserInFireStore(username: username , email: email)
            
            
        }
    }
    
    private func addNewUserInFireStore(username : String , email : String ){
        
        let dbRef =  Firestore.firestore().collection("Users").document()
        dbRef.setData([
            "id"   : Auth.auth().currentUser!.uid,
            "name" : username ,
            "email": email,
            "stripeId": ""
        ]) {[weak self] err in
            guard let self = self else { return}
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                self.dismiss(animated: true) {
                    print("aaa")
                     self.dismissLogin.dismissLogin();
                }
               
                
            }
        }
        
    }
    
    
    private func showLoginScreen(){
        let loginStroyboard = UIStoryboard(name: "LoginVC", bundle: nil)
                                 let loginVC = loginStroyboard.instantiateViewController(withIdentifier: Storyboard.LoginVC) as! LoginVC
                                 loginVC.modalPresentationStyle = .fullScreen
                                 self.present(loginVC, animated: true, completion: nil)
      }
    
    @IBAction func didTapLogin(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
   
}
