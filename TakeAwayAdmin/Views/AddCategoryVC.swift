//
//  AddCategoryVC.swift
//  TakeAwayAdmin
//
//  Created by kasper on 8/24/20.
//  Copyright © 2020 Mahmoud Abdul-Wahab. All rights reserved.
//

import UIKit
import Firebase

class AddCategoryVC: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var chooseImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
   
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTaped(_:)))
        chooseImage.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    
    @objc func imageTaped(_ tap : UITapGestureRecognizer){
        // launch the image picker
        launchImagePicker()
        
    }
    
    @IBAction func didTapAddCategory(_ sender: Any) {
        uploadImageThenDocument()
        
    }
    
    
    
    private func uploadImageThenDocument(){
        guard  let image = chooseImage.image , let name = nameField.text , name.isNotEmpty else {
            return
        }
            // 1 - turn the image into data
        guard  let  imageData = image.jpegData(compressionQuality: 0.2) else {
            return
        }
        
             // 2- create storage ref
        
        let storageRef = Storage.storage().reference().child("/categories/\(name).jpg")
         /// 3- set the meta dat
        let imageMeta = StorageMetadata()
        imageMeta.contentType = "image/jpg"
         //4 - uplaod the data
        storageRef.putData(imageData , metadata: imageMeta){(metaData , error) in
            guard error == nil  else {
                print("unable to upload image")
                return
            }
            // retrieve the download linke
            // 5- once image is uploaded retrieve the image url
            storageRef.downloadURL { (url , error) in
                guard let url = url  else{
                    print("Error Retreving the url ")
                    return
                }
                // 6 - uplaod new category
                let strURL = url.absoluteString

                uploadNewCategory(with: strURL, name: name)
            }
             
            
        }
         
        
         func uploadNewCategory(with url : String , name : String){
            
                    let dbRef =  Firestore.firestore().collection("Categories").document()
                           dbRef.setData([
                               "id"        : dbRef.documentID,
                               "name"      : name ,
                               "imgURL"    : url,
                               "isActive"  : true ,
                               "timeStamp" : Timestamp()
                           ]) {[weak self] err in
                               guard let self = self else { return}
                               if let err = err {
                                   print("Error writing document: \(err)")
                               } else {
                                   print("Category successfully Created!")
                                   self.dismiss(animated: true)
                               }
                           }
        }
 
                  
            
        }

}


extension AddCategoryVC : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    func launchImagePicker(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker , animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else{return}
        chooseImage.contentMode = .scaleAspectFill
        chooseImage.image = image
        dismiss(animated: true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
