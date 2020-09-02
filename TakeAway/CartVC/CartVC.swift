//
//  CartVC.swift
//  TakeAway
//
//  Created by kasper on 8/27/20.
//  Copyright © 2020 Mahmoud Abdul-Wahab. All rights reserved.
//

import UIKit

class CartVC: UIViewController {
    
    @IBOutlet weak var checkoutViewOutlite: UIView!
    @IBOutlet weak var totalPriceLable: UILabel!
    @IBOutlet weak var cartTable: UITableView!
    var cartList : [Products] = []
    static var checkoutPrice : Double = 0.0
    static var isChanged  = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkoutViewOutlite.layer.cornerRadius = 12
    
        confingureTableView()
        loadCartProducts()
        if CartVC.isChanged {
              CartVC.checkoutPrice = 0.0
            cartList.forEach {[weak self] (product) in
                guard self != nil else{return}
              
                CartVC.checkoutPrice += ((product.price.value)! * Double(product.amount.value!))
                self!.totalPriceLable.text = "\(CartVC.checkoutPrice) $"
                CartVC.isChanged = false
            }
            
        }else{
            
            totalPriceLable.text = "\(CartVC.checkoutPrice) $"
        }
        
    }
    
    
    private func confingureTableView()
    {
        cartTable.dataSource = self
        cartTable.delegate   = self
        cartTable.register(CartCell.nib(), forCellReuseIdentifier: CartCell.identifier)
    }
    
    private func  loadCartProducts(){
        cartList = RealmDBManager.shared.getCartProducts()
    }
    
    @IBAction func didTapCheckout(_ sender: UIButton) {
        let payment =  StripePaymentVC()

        navigationController?.pushViewController(payment, animated: true)
    }
    
}


extension CartVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTable.dequeueReusableCell(withIdentifier: CartCell.identifier, for: indexPath) as! CartCell
        let product = cartList[indexPath.row]
        cell.product = product
        
        plusLogic(cell : cell )
        minusLogic(cell : cell)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    private func plusLogic(cell : CartCell){
        cell.plus = {[weak self] (product)in
            guard let self = self else{return}
            var number    = ((cell.amountLable.text)! as NSString).intValue
            number += 1
            cell.amount = "\(number)"
            // let doublePrice =
            // let oldVal = (self.totalPriceLable.text! as NSString).doubleValue
            RealmDBManager.shared.updateProductCount(with: product, number: Int(number))
            // let Val = Double(number) * product.price.value!
            CartVC.checkoutPrice += product.price.value!
            self.totalPriceLable.text = "\(CartVC.checkoutPrice)$"
            print(number)
            
        }
    }
    
    
    private func minusLogic(cell : CartCell){
        cell.minus = {[weak self] (product)in
            guard let self = self else{return}
            var number    = ((cell.amountLable.text)! as NSString).intValue
            
            print(number)
            if number > 1 {
                number -= 1
                cell.amount = "\(number)"
                CartVC.checkoutPrice -= product.price.value!
                self.totalPriceLable.text = "\(CartVC.checkoutPrice)$"
                RealmDBManager.shared.updateProductCount(with: product, number: Int(number))

            }
        }
    }
    
}
