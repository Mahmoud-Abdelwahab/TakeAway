//
//  ProductCell.swift
//  TakeAway
//
//  Created by kasper on 8/24/20.
//  Copyright © 2020 Mahmoud Abdul-Wahab. All rights reserved.
//

import UIKit
import Kingfisher
protocol AddToCartDelegate : class {
    func didTapAddToCart(product : Products , cell : ProductCell)
}
class ProductCell: UICollectionViewCell {
 
    static let identifier = "ProductCell"
    weak var addToCartDelegate : AddToCartDelegate!
    
    @IBOutlet weak var cartImage: UIButton!
    @IBOutlet weak var favoriteStare: UIButton!
    @IBOutlet weak var descriptionLable: UILabel!
    @IBOutlet weak var productNameText: UILabel!
    @IBOutlet weak var productPriceText: UILabel!
    
    @IBOutlet weak var productImage: UIImageView!
    
    var favortie: (()->())?
    var product : Products?{
        didSet{
            setupCell(with : product!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    static func nib() -> UINib{
        return UINib(nibName: ProductCell.identifier, bundle: nil)
    }
    
    func setupCell(with product: Products){
        
        productNameText.text = product.name
        productPriceText.text =  "\(product.price.value ?? 0.0)$"
        descriptionLable.text = product.productDescription
        if HomeVC.favoriteArray.contains(where: { (pro) -> Bool in
            return pro.name == product.name
        }){
        favoriteStare.setImage(UIImage(named: "fill-star"), for: .normal)
        }else{
             favoriteStare.setImage(UIImage(named: "empty-star"), for: .normal)
        }
        
        if  RealmDBManager.shared.getCartProducts().contains(where: { (pro) -> Bool in
            return pro.name == product.name
        }){
             cartImage.setImage(UIImage(named: "fill-cart"), for: .normal)
        }else{
             cartImage.setImage(UIImage(named: "empty-cart"), for: .normal)
        }
        guard  let url = URL(string: product.imgURL!) else {
            return
        }
        productImage.kf.setImage(with: url)
        
    }
    @IBAction func didTapAddToCartBtn(_ sender: Any) {
        addToCartDelegate.didTapAddToCart(product: self.product!, cell : self)
    }
    
    @IBAction func didTapFavoriteBtn(_ sender: Any) {
        favortie!()
    }
    
}
