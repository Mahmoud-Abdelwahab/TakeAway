//
//  StripePaymentVC.swift
//  TakeAway
//
//  Created by kasper on 9/1/20.
//  Copyright © 2020 Mahmoud Abdul-Wahab. All rights reserved.
//

import UIKit
import Stripe
import Alamofire

class StripePaymentVC: UIViewController , STPAuthenticationContext {
  
    
    let backendURL : String = "https://mystrip.herokuapp.com/"
    lazy var activityIndicatore = UIActivityIndicatorView()
    lazy var stackView : UIStackView = {
        let stack = UIStackView()
        stack.alignment    = .fill
        stack.axis         = .vertical
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    lazy var imagelogo : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image  = UIImage(named: "visa")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    
    
    lazy var cardField : STPPaymentCardTextField = {
        let cartField  = STPPaymentCardTextField()
        cartField.translatesAutoresizingMaskIntoConstraints = false
        return cartField
    }()
    
    
    lazy var payBtn : UIButton = {
        let btn = UIButton()
        // btn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        btn.backgroundColor = .black
        btn.layer.borderColor = #colorLiteral(red: 1, green: 0.852338399, blue: 0.2632973031, alpha: 1)
        btn.layer.borderWidth = 2
        btn.setTitle("Palce Order", for: .normal)
        btn.setTitleColor(.yellow, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(didTapPalceOrder), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Card Field"
        view.backgroundColor = UIColor.white
        view.addSubview(cardField)
        edgesForExtendedLayout = []
        
        cardField.borderWidth = 1.0
        cardField.postalCodeEntryEnabled = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        setupUI()
    }
    
    
    func  setupUI(){
        view.addSubview(stackView)
        stackView.addArrangedSubview(imagelogo)
        stackView.addArrangedSubview(cardField)
        stackView.addArrangedSubview(payBtn)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 400) ,
            
            imagelogo.heightAnchor.constraint(equalToConstant: 60),
            imagelogo.widthAnchor.constraint(equalToConstant: 60)
        ])
        
    }
    
    //MARK: - Button Action
    @objc func didTapPalceOrder(){
        // 1-) [srver-side] create payment Intent
        // 2-) [slient-side] Confirme the payment intent
        
        //make a POST request to the backendURL end point
        self.startLoading()
        self.createPaymentIntent {[weak self] (paymentIntentResponse, error) in
            guard let self = self else{return}
            if let error = error {
                print(error)
                self.stopeLoading()
                return
            }
            else{
                guard let responseDictinary = paymentIntentResponse as?[String : AnyObject] else {
                    print("Incorrect Response")
                    return
                }
             // success
                let clientSecret = responseDictinary["secret"] as! String
              self.stopeLoading()
                
                // now  i get cleint secret from the server
                // 1- i wanna confirm the payment intent  using STPPaymentHandler
                // 2- implement delegate for STPAuthenticationContext
                
                let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
                
                let paymentMehodeParams = STPPaymentMethodParams(card: self.cardField.cardParams, billingDetails: nil, metadata: nil)
                paymentIntentParams.paymentMethodParams = paymentMehodeParams
                
                STPPaymentHandler.shared().confirmPayment(withParams: paymentIntentParams, authenticationContext: self) { [weak self](status, paymentIntent, error) in
                      guard let self = self else{return}
                    self.stopeLoading()
                    var resultString = ""
                    
                    switch(status){
                        
                    case .succeeded:
                        resultString = "payment Successful"
                    case .canceled:
                        resultString = "Payment Canceled"
                    case .failed:
                        resultString = "Payment failed please try a different card"
                    @unknown default:
                        print("UnKnown Status .....")
                    }
                    
                    print(resultString)
                   // self.showAlert(title : "Alert" , message : resultString)
                    /// here i  will clear the realm cart
                    
                    let alert = UIAlertController(title: "Alert" , message: resultString, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                        RealmDBManager.shared.deleteAllProducts()
                                          CartVC.checkoutPrice = 0.0
                                          self.popViewControllerss(popViews: 2)
                    }))
                    self.present(alert , animated:  true)
                }
            }
        }
    }
    
    
    func popViewControllerss(popViews: Int, animated: Bool = true) {
        if self.navigationController!.viewControllers.count > popViews
        {
            let vc = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - popViews - 1]
             // -1 cause the count starts from 1 buth the stack starts from 0 index 
             self.navigationController?.popToViewController(vc, animated: animated)
        }
    }
    
    
    func createPaymentIntent(completion : @escaping STPJSONResponseCompletionBlock){
        
        var url = URL(string: backendURL)!
        // the file https://github.com/stripe/example-terminal-backend/blob/master/web.rb
        url.appendPathComponent("create_payment_intent")
        // put amount of the charge here ... in the post params
        AF.request(url ,method:
            .post , parameters: ["amount":"60"]).validate(statusCode : 200..<600).responseJSON { (response) in
                
                switch(response.result){
                    
                case .success(let json):
                    completion(json as? [String : Any], nil)
                case .failure( let error):
                    completion(nil, error)
                }
        }
        
    }
    
    // MARK: STPAuthenticationContext
    func authenticationPresentingViewController() -> UIViewController {
          // this methode show which VC presents the authentication UI
        return self
      }
      
    
    @objc func done() {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cardField.becomeFirstResponder()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let padding: CGFloat = 15
        cardField.frame = CGRect(x: padding,
                                 y: padding,
                                 width: view.bounds.width - (padding * 2),
                                 height: 50)
    }
    
    private func startLoading(){
        activityIndicatore.startAnimating()
        activityIndicatore.isHidden = false
    }
    
    private func stopeLoading(){
        activityIndicatore.stopAnimating()
        activityIndicatore.isHidden = true
    }
    
   
    
}
