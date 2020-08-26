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
    
    var tableHeight : CGFloat = 0
    var categoryDataSource : [String : String] = [:]
    var dataSource :[String] = []
    let tableView = UITableView()
    var categoryId : String? = nil
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var stockField: UITextField!
    @IBOutlet weak var productDescreptionField: UITextField!
    @IBOutlet weak var productPriceField: UITextField!
    @IBOutlet weak var productNameField: UITextField!
    
    @IBOutlet weak var chooseCategoryBtn: UIButton!
    
    lazy var transparentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTaped(_:)))
        productImage.addGestureRecognizer(tap)
        
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.register(MenuCell.self, forCellReuseIdentifier: "MenuCell")
        
        categoryDataSource = UserDefaults.standard.object(forKey: "CATEGORY") as? [String:String] ?? [:]
        
        for (key ,value) in categoryDataSource {
            print("\(key) and the value is \(value)")
            dataSource.append(key)
        }
    }
    
    
    @IBAction func didTapChooseCategory(_ sender: Any) {
        addTransparentView(buttonFrame: chooseCategoryBtn.frame)
    }
    
    
    @objc private func imageTaped(_: UITapGestureRecognizer){
        launchImagePicker()
        
    }
    
    
    @IBAction func didTapAddProductBtn(_ sender: Any) {
        
        guard let image = productImage.image , let productName = productNameField.text , productName.isNotEmpty else {return}
        
        // 1- converting image into data
        let imageData = image.jpegData(compressionQuality: 0.2)
        // 2- setting the meta data
        let imageMetaData = StorageMetadata()
        imageMetaData.contentType = "image/jpg"
        // 3- upload image to fireSorage
        let storageRef = Storage.storage().reference().child("product\(productName).jpg")
        
        storageRef.putData(imageData!, metadata: imageMetaData) { (metaData, err) in
            
            guard err == nil  else {
                print("unable to upload image")
                return
            }
            // retrieve the download linke
            // 5- once image is uploaded retrieve the image url
            storageRef.downloadURL {[weak self] (url , error) in
                guard let self = self else { return }
                guard let url = url  else{
                    print("Error Retreving the url ")
                    return
                }
                // 6 - uplaod new category
                let strURL = url.absoluteString
                
                self.uploadNewProduct(with: strURL)
            }
        }
    }
    
    func uploadNewProduct(with url : String){
          
        guard let categoryId = categoryId,let price =  (productPriceField.text as NSString?)?.doubleValue  , let description = productDescreptionField.text , description.isNotEmpty , let stock = stockField.text , stock.isNotEmpty else {return}
        
        let dbRef =  Firestore.firestore().collection("Products").document()
        dbRef.setData([
            "categoryId"  : categoryId,
            "name"        : productNameField.text! ,
            "imgURL"      : url,
            "price"       : price ,
            "productDescription" : description,
            "stock"       : stock ,
            "timeStamp"   : Timestamp()
            
        ]) {[weak self] err in
            guard let self = self else { return}
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Product successfully Created!")
                self.navigationController?.popViewController(animated: true)
            }
        }
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



extension AddProductVC : UITableViewDelegate , UITableViewDataSource{
    
    private func addTransparentView(buttonFrame : CGRect){
        tableHeight = (CGFloat(dataSource.count * 50)) // 50 this is the cell height
        // let window = UIApplication.shared.keyWindow
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        
        tableView.frame = CGRect(x: buttonFrame.origin.x, y: buttonFrame.origin.y + buttonFrame.height + 5, width: buttonFrame.width, height: 0)
        tableView.layer.cornerRadius = 7
        tableView.separatorStyle = .none
        
        self.view.addSubview(tableView)
        
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        
        transparentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeTransparentView)))
        transparentView.alpha = 0 // to do some animation
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: { [weak self]in
            guard let self = self else {return}
            self.transparentView.alpha = 0.5 //animate from 0 to 0.5
            self.tableView.frame = CGRect(x: buttonFrame.origin.x, y: buttonFrame.origin.y + buttonFrame.height + 5, width: buttonFrame.width, height: self.tableHeight) // animate from height = 0 to height = 200
            
            }, completion: nil)
        
        
        
    }
    
    @objc func removeTransparentView(){
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: { [weak self]in
            guard let self = self else {return}
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: self.chooseCategoryBtn.frame.origin.x, y: self.chooseCategoryBtn.frame.origin.y + self.chooseCategoryBtn.frame.height + 5, width: self.chooseCategoryBtn.frame.width, height: 0)
            }, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        cell.textLabel!.text = dataSource[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = dataSource[indexPath.row]
        self.categoryId = self.categoryDataSource[key]
        print( self.categoryId!)
        removeTransparentView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
}

class MenuCell : UITableViewCell{
    
}
