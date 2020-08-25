//
//  AddProductVC.swift
//  TakeAwayAdmin
//
//  Created by kasper on 8/24/20.
//  Copyright © 2020 Mahmoud Abdul-Wahab. All rights reserved.
//

import UIKit
import Firebase

class AddProductVC: UIViewController {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var stockField: UITextField!
    @IBOutlet weak var productDescreptionField: UITextField!
    @IBOutlet weak var productPriceField: UITextField!
    @IBOutlet weak var productNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTaped(_:)))
               productImage.addGestureRecognizer(tap)
    }
    
    
    @objc private func imageTaped(_: UITapGestureRecognizer){
        launchImagePicker()
        
    }
    
    
    @IBAction func didTapAddProductBtn(_ sender: Any) {
        
        guard let image = productImage.image else {return}
        // 1- converting image into data
        let imageData = image.jpegData(compressionQuality: 0.2)
        // 2- setting the meta data
        let imageMetaData = st
    }


}


extension AddProductVC : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    func launchImagePicker(){
         let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker , animated: true)
      }
      
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
       guard let image = info[.originalImage] as? UIImage else {return}
        productImage.contentMode = .scaleAspectFill
        productImage.image = image
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
