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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    @IBAction func didTapPlus(_ sender: Any) {
        
    }
    
    
    @IBAction func didTapMinus(_ sender: Any) {
        
    }
    
}
