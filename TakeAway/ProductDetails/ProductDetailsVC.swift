//
//  ProductDetailsVC.swift
//  TakeAway
//
//  Created by kasper on 8/25/20.
//  Copyright © 2020 Mahmoud Abdul-Wahab. All rights reserved.
//

import UIKit
import  Kingfisher

class ProductDetailsVC: UIViewController {
    
    var product:Products?
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productStock: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
         configureForm(with: product!)
    }
    
    @IBAction func onAddProductToCartClicked(_ sender: Any) {
        
    //      ProductVC.favoriteAndUnFavorite(with : product!)
    }
    
    private func configureForm(with product : Products) {
        
        productName.text        = product.name
        productDescription.text = product.productDescription
        productStock.text       = "Stock  : \(product.stock.value ?? 0)"
        productPrice.text       = " Price : \((product.price.value)! )$"
        guard let url           = URL(string: product.imgURL!) else{return}
        
        productImage.kf.setImage(with:url)
        
    }
    
    
    
    
}
