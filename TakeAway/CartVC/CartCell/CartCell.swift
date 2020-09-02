//
//  CartCell.swift
//  TakeAway
//
//  Created by kasper on 8/28/20.
//  Copyright © 2020 Mahmoud Abdul-Wahab. All rights reserved.
//

import UIKit
import Kingfisher

class CartCell: UITableViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var priceLable: UILabel!
    @IBOutlet weak var amountLable: UILabel!
    @IBOutlet weak var nameLable: UILabel!
    static let identifier = "CartCell"
    var plus : ((_ product : Products)->())?
    var minus : ((_ product : Products)->())?
    var total : (()->())?
    
    
    
    var product:Products?{
        didSet{
            guard product != nil else{return}
            setupCell(with : product!)
        }
    }
    
    var amount : String? {
        didSet{
            guard amount != nil else{return}
            amountLable.text = amount
        }
    }
    
    
    private func setupCell(with product : Products){
        nameLable.text = product.name
        priceLable.text = "\(product.price.value ?? 0.0)$"
        amountLable.text = "\(product.amount.value ?? 1)"
        
        guard let image = product.imgURL , !image.isEmpty ,  let imageURL = URL(string:image )  else {  return }
        productImage.kf.setImage(with: imageURL)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.layer.cornerRadius = 12
    }
    
    
    static func nib()->UINib{
        return UINib(nibName: CartCell.identifier, bundle: nil)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    @IBAction func didTapPlus(_ sender: Any) {
        plus?(self.product!)
    }
    
    
    @IBAction func didTapMinus(_ sender: Any) {
        minus?(self.product!)
    }
    
}
