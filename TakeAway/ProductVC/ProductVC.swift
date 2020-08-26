//
//  ProductVC.swift
//  TakeAway
//
//  Created by kasper on 8/24/20.
//  Copyright © 2020 Mahmoud Abdul-Wahab. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ProductVC: UIViewController {
    var productList : [Products] = []
    var filteredProductList : [Products] = []
    var isSearchActive : Bool = false
    
    var categoryId : String?
    
    @IBOutlet weak var productCollection: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchControler()
        configureCollection()
        loadProduct(with : categoryId!)
    }
    
    
    private func configureCollection(){
        productCollection.dataSource = self
        productCollection.delegate   = self
        productCollection.register(ProductCell.nib(), forCellWithReuseIdentifier: ProductCell.identifier)
        
        configureCollectionViewFlowlayout()
    }
    
    
    func configureCollectionViewFlowlayout() {
        
        let padding : CGFloat             = 10
        let numberOfItemPerRow : CGFloat  = 1
        let lineSpacing: CGFloat          = 5
        let interItemSpacing : CGFloat    = 5
        
        let width  = (productCollection.frame.width - (padding * 2 ) - ((numberOfItemPerRow - 1)*interItemSpacing)) / numberOfItemPerRow
        let height  = width + 20
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.itemSize = CGSize(width: width, height: height)
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumLineSpacing = lineSpacing
        collectionViewFlowLayout.minimumInteritemSpacing = interItemSpacing
        productCollection.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
        
    }
    
    
    func loadProduct(with categoryId : String ){
        
        let _ = Firestore.firestore().collection("Products").whereField("categoryId", isEqualTo: categoryId).order(by: "timeStamp", descending: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let data = document.data()
                    let product = Products.init(data: data)
                    self.productList.append(product)
                    self.productCollection.reloadData()
                }
            }
        }
        
    }
    
    
    func configureSearchControler() {
        
        let mySearchControler                                   = UISearchController()
        mySearchControler.searchResultsUpdater                  = self // ue need to conform this delegate  wihich is used for detecting any update in thr search feild
        mySearchControler.searchBar.placeholder                 = "Search By Name"
        navigationItem.searchController                         = mySearchControler // naviagtion item has a search controler and it's optional
        mySearchControler.searchBar.delegate                    = self /// for handeling cancel button
        
        mySearchControler.obscuresBackgroundDuringPresentation  = false
        // this for hidding the littel blureing which appear over the collectionView when u type somthing in the searchBar
        
        
    }
    
}


extension ProductVC : UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearchActive {
            return filteredProductList.count
        }else{
            return productList.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = productCollection.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
        
        
        if isSearchActive {
            cell.product  = filteredProductList[indexPath.row]
        }else{
            cell.product = productList[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let productDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
            productDetailsVC.product = productList[indexPath.row]
            
            navigationController?.pushViewController(productDetailsVC, animated: true)
        
    }
    
}


extension ProductVC : UISearchResultsUpdating , UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let filter = searchController.searchBar.text , !filter.isEmpty  else {
            // this code handle a bug when u delelte  character by character from the search bar unti it becomes empty the displayed array will be the filltered so u will find bug when u click in some of the user cards
            filteredProductList.removeAll()
            isSearchActive  = false
            productCollection.reloadData()
            return
            
        }
        isSearchActive  = true
        filteredProductList = productList.filter{$0.name!.lowercased().contains(filter.lowercased())}
        // this called map reduce
        //$0 this is the follower object in every loop in the array
        productCollection.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchActive = false
        productCollection.reloadData()
        
    }
    
}
