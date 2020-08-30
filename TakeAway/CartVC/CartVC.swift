//
//  CartVC.swift
//  TakeAway
//
//  Created by kasper on 8/27/20.
//  Copyright © 2020 Mahmoud Abdul-Wahab. All rights reserved.
//

import UIKit


class CartVC: UIViewController {

    @IBOutlet weak var totalPriceLable: UILabel!
    @IBOutlet weak var cartTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
  
        confingureTableView()
    }
    
    
    private func confingureTableView()
    {
        cartTable.dataSource = self
        cartTable.delegate   = self
      //  cartTable.register(<#T##nib: UINib?##UINib?#>, forCellReuseIdentifier: <#T##String#>)
    }
    
    
    
    @IBAction func didTapCheckout(_ sender: UIButton) {
        
    }
    
}


extension CartVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
