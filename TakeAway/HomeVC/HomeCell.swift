//
//  HomeCell.swift
//  TakeAway
//
//  Created by kasper on 8/24/20.
//  Copyright © 2020 Mahmoud Abdul-Wahab. All rights reserved.
//

import UIKit
import Kingfisher

class HomeCell: UITableViewCell {
 
    static let identifier = "HomeCell"
    var category : Category?{
        didSet{
            setupCell(with: category!)
        }
    }
    
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 12
        categoryImage.layer.cornerRadius = 12
    }

    
    static func nib() -> UINib {
        return UINib(nibName: HomeCell.identifier, bundle: nil)
    }
    
    private func setupCell(with category : Category){
        categoryName.text = category.name
        guard let url = URL(string: category.imgURL) else {return}
        categoryImage.kf.setImage(with: url)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
