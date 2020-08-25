//
//  ViewController.swift
//  TakeAway
//
//  Created by kasper on 8/21/20.
//  Copyright © 2020 Mahmoud Abdul-Wahab. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth


class HomeVC: UIViewController ,  UITableViewDelegate , UITableViewDataSource{
    
    var categoryList : [Category] = []
    var filteredCategoryList : [Category] = []
    var isSearchActive : Bool = false
    
    @IBOutlet weak var categoryTable: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser == nil {
            showLoginScreen()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
       
         configureSearchControler()
        configureTableView()
         loadCategories()
        
       
        
    }
    
    @IBAction func didTapLogout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            showLoginScreen()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
    func loadCategories(){
        let storeRef = Firestore.firestore().collection("Categories")
        
        storeRef.getDocuments {[weak self] (snap, error) in
            guard let self = self else {return}
            guard error == nil , let documents = snap?.documents  else {
                print("something went wrong ")
                return
            }
            for document in documents{
                
                let data = document.data()
                let newCategory = Category.init(data: data)
                self.categoryList.append(newCategory)
                self.categoryTable.reloadData()
            }
        }
        }
    
    private func showLoginScreen(){
        let loginStroyboard = UIStoryboard(name: "LoginVC", bundle: nil)
        let loginVC = loginStroyboard.instantiateViewController(withIdentifier: Storyboard.LoginVC) as! LoginVC
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
        
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
    
    
    func configureTableView(){
        categoryTable.dataSource    = self
        categoryTable.delegate      = self
        categoryTable.register(HomeCell.nib(), forCellReuseIdentifier: HomeCell.identifier)
        categoryTable.separatorInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50)

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearchActive {
            return filteredCategoryList.count
        }else{
            return categoryList.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTable.dequeueReusableCell(withIdentifier: HomeCell.identifier , for: indexPath) as! HomeCell
        if isSearchActive {
            cell.category = filteredCategoryList[indexPath.row]
        }else{
            cell.category = categoryList[indexPath.row]
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let productVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductVC") as! ProductVC
        
       
        
        if isSearchActive {
            productVC.categoryId = filteredCategoryList[indexPath.row].id
        }else{
            productVC.categoryId =  categoryList[indexPath.row].id
        }
        
        self.navigationController?.pushViewController(productVC, animated: true)
    }
    
}


extension HomeVC  {
    
    
}


extension HomeVC : UISearchResultsUpdating , UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        //        guard let filter = searchController.searchBar.text , !filter.isEmpty  else {
        //            // this code handle a bug when u delelte  character by character from the search bar unti it becomes empty the displayed array will be the filltered so u will find bug when u click in some of the user cards
        //            filterebFollowers.removeAll()
        //            updataData(on: followersList)
        //            isSearchActive  = false
        //            return
        //
        //        }
        //        isSearchActive  = true
        //        filteredCategoryList = categoryList.filter{$0.name.lowercased().contains(filter.lowercased())}
        //        // this called map reduce
        //        //$0 this is the follower object in every loop in the array
        //        updataData(on: filterebFollowers)
    }
    
    //
    
    //    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    //        isSearchActive = false
    //        updataData(on: followersList)
    //
    //    }
    
}
