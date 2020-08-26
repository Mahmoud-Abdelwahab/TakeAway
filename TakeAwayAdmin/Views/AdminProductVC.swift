//
//  AdminProductVC.swift
//  TakeAwayAdmin
//
//  Created by kasper on 8/24/20.
//  Copyright © 2020 Mahmoud Abdul-Wahab. All rights reserved.
//

import UIKit

class AdminProductVC: ProductVC {
 
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Add Product", style: .done, target: self, action: #selector(didTapAddProduct)), animated: true)
        
    }
    
   @objc func didTapAddProduct()  {
   
       let addNewProductVC = self.storyboard?.instantiateViewController(withIdentifier: "AddProductVC") as! AddProductVC
       navigationController?.pushViewController(addNewProductVC, animated: true)
 
    
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }


}
