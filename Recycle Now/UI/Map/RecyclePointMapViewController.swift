//
//  RecyclePointMapViewController.swift
//  Recycle Now
//
//  Created by Carl on 25/02/2018.
//  Copyright © 2018 CarlJNash. All rights reserved.
//

import UIKit

class RecyclePointMapViewController: BaseViewController {

    // ===============================================
    // MARK: - Properties
    // ===============================================
    
    var recycleItems: RecycleItems? {
        didSet {
            // TODO: update map pins
        }
    }
    
    
    
    // ===============================================
    // MARK: - UIViewController Lifecycle
    // ===============================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchRecyclePoints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // ===============================================
    // MARK: - Private
    // ===============================================
    
    fileprivate func fetchRecyclePoints() {
        // TODO: make location not hardcoded!
        let config = URLSessionDataTaskConfig.RecycleLocation.init(location: "EH35BW")
        NetworkClient.shared.dataTaskWith(config: config, decodableType: RecycleItems.self, successBlock: { (response) in
            
            if let recycleItems = response.decodableResponse as? RecycleItems {
                self.recycleItems = recycleItems
            }
        }) { (failure) in
            // TODO: Handle error
            print(failure.error as Any)
        }
    }
}

