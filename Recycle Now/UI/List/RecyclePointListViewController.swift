//
//  RecyclePointListViewController.swift
//  Recycle Now
//
//  Created by Carl on 25/02/2018.
//  Copyright © 2018 CarlJNash. All rights reserved.
//

import UIKit

class RecyclePointListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    // ===============================================
    // MARK: - Properties
    // ===============================================
    
    @IBOutlet weak var tableView: UITableView!
    
    var recycleItems: RecycleItems? {
        didSet {
            self.reloadTable()
        }
    }
    
    var searchDataTask: URLSessionDataTask?
    
    
    
    // ===============================================
    // MARK: - UIViewController Lifecycle
    // ===============================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpSearchBar()
        
        self.setUpTableView()
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
    
    fileprivate func setUpSearchBar() {
        let searchViewController = RecyclePointSearchViewController.loadFromStoryboard()
        let searchController = UISearchController.init(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    
    // ===============================================
    // MARK: - Private
    // ===============================================
    
    fileprivate func fetchRecyclePoints(forLocation location: String?) {
        guard let location = location, location.count > 0 else { return }
        
        self.searchDataTask?.cancel()
        
        let config = URLSessionDataTaskConfig.RecycleLocation.init(location: location)
        self.searchDataTask = NetworkClient.shared.dataTaskWith(config: config, decodableType: RecycleItems.self, successBlock: { (response) in
            
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
        self.fetchRecyclePoints(forLocation: "")
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
    
    
    
    // ===============================================
    // MARK: - UISearchResultsUpdating
    // ===============================================
    
    func updateSearchResults(for searchController: UISearchController) {
        print()
    }
    
    
    
    // ===============================================
    // MARK: - UISearchBarDelegate
    // ===============================================
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchBarText = searchBar.text else { return }
        guard searchBarText.count >= 3 else { return }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.fetchRecyclePoints(forLocation: searchBarText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.fetchRecyclePoints(forLocation: searchBar.text)
        self.navigationItem.searchController?.dismiss(animated: true, completion: {
            // TODO: show loading view
        })
    }
}
