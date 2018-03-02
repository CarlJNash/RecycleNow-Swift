//
//  RecyclePointListViewController.swift
//  Recycle Now
//
//  Created by Carl on 25/02/2018.
//  Copyright © 2018 CarlJNash. All rights reserved.
//

import UIKit

class RecyclePointListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    // ===============================================
    // MARK: - Properties
    // ===============================================
    
    @IBOutlet weak var tableView: UITableView!
    
    var recycleItems: RecycleItems? {
        didSet {
            self.reloadTable()
        }
    }
    
    
    
    // ===============================================
    // MARK: - UIViewController Lifecycle
    // ===============================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpTableView()
        
        self.fetchRecyclePoints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // ===============================================
    // MARK: - Setup
    // ===============================================
    
    private func setUpTableView() {
        self.tableView.register(UINib.init(nibName: "RecyclePointCell",
                                           bundle: nil),
                                forCellReuseIdentifier: "RecyclePointCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let refreshControl = UIRefreshControl.init()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: UIControlEvents.valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    
    
    // ===============================================
    // MARK: - Private
    // ===============================================
    
    fileprivate func fetchRecyclePoints() {
        // TODO: make location not hardcoded!
        let config = URLSessionDataTaskConfig.RecycleLocation.init(location: "EH35BW")
        NetworkClient.shared.dataTaskWith(config: config, decodableType: RecycleItems.self, successBlock: { (response) in
            
            self.tableView.refreshControl?.endRefreshing()
            
            if let recycleItems = response.decodableResponse as? RecycleItems {
                self.recycleItems = recycleItems
            }
        }) { (failure) in
            // TODO: Handle error
            print(failure.error as Any)
        }
    }
    
    @objc private func pullToRefresh() {
        self.fetchRecyclePoints()
    }
    
    private func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func recyclePoint(for indexPath: IndexPath) -> RecyclePoint? {
        guard let recycleItems = self.recycleItems else { return nil }
        let recyclePoint = recycleItems.items[indexPath.row] as RecyclePoint
        return recyclePoint
    }
    
    
    
    // ===============================================
    // MARK: - UITableViewDataSource
    // ===============================================
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let recycleItems = self.recycleItems else { return 0 }
        return recycleItems.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecyclePointCell", for: indexPath) as! RecyclePointCell
        cell.setUp(withRecyclePoint: self.recyclePoint(for: indexPath))
        return cell
    }
    
    
    
    // ===============================================
    // MARK: - UITableViewDelegate
    // ===============================================
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? RecyclePointCell {
            cell.render()
        }
    }
}
