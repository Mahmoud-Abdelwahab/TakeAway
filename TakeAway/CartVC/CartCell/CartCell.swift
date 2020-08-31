//
//  CartCell.swift
//  TakeAway
//
//  Created by kasper on 8/28/20.
//  Copyright © 2020 Mahmoud Abdul-Wahab. All rights reserved.
//

import UIKit

class CartCell: UITableViewCell {
    
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
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
