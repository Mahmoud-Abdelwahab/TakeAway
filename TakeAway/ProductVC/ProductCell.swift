//
//  ProductCell.swift
//  TakeAway
//
//  Created by kasper on 8/24/20.
//  Copyright © 2020 Mahmoud Abdul-Wahab. All rights reserved.
//

import UIKit
import Kingfisher

class ProductCell: UICollectionViewCell {
 
    static let identifier = "ProductCell"
    
    @IBOutlet weak var productNameText: UILabel!
    @IBOutlet weak var productPriceText: UILabel!
    
    @IBOutlet weak var productImage: UIImageView!
    
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
        productPriceText.text =  "\(product.price)"
        guard  let url = URL(string: product.imgURL!) else {
            return
        }
        productImage.kf.setImage(with: url)
        
    }
    @IBAction func didTapAddToCartBtn(_ sender: Any) {
    }
    
    @IBAction func didTapFavoriteBtn(_ sender: Any) {
    }
    
}
