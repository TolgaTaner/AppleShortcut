//
//  ProductViewController.swift
//  Shortcut
//
//  Created by Tolga Taner on 1.09.2022.
//

import UIKit

class ProductViewController: UIViewController {

    
    private var productId: String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    init(productId: String) {
        self.productId = productId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func request() {
        // request with product id
    }
}
