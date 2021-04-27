//
//  FavoritesViewController.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 15.04.2021.
//

import UIKit
//import Toast

protocol FavoritesView: class {
    func setTableView()
    func reloadTableView()
    func setTitle(with text: String)
//    func showEmptyView(needShow: Bool)
    func endRefreshing()
    func reloadRows(with indexPath: IndexPath)
}

final class FavoritesViewController: UITableViewController, FavoritesView {
    
    var configurator = FavoritesConfigurator()
    var presenter: FavoritesPresenterProtocol!

    private var refreshControlLocal: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(viewController: self)
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        presenter.viewWillAppear()
        
        if isMovingToParent {
            presenter.fetchData()
        }
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        presenter.viewWillDisappear()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func setTableView() {
        tableView.allowsSelection = false
        
        tableView.register(cellType: TrainingSectionTVCell.self)
        tableView.register(cellType: FeedAudioTVCell.self)
        tableView.register(cellType: FeedTimeLineTVC.self)
        tableView.register(cellType: FeedQuizTVCell.self)
        tableView.register(cellType: FeedOpenQuizTVCell.self)
        tableView.register(cellType: FeedVideoTVCell.self)
                
        refreshControlLocal = UIRefreshControl()
        refreshControlLocal?.addTarget(self, action: #selector(refreshList(refreshControl:)), for: .valueChanged)
        tableView.refreshControl = refreshControlLocal
        
        tableView.backgroundColor = UIColor.BasicUI.backgroundLightGray

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 350
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func setTitle(with text: String) {
        title = text
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
//    func showEmptyView(needShow: Bool) {
//        showEmptyView(neadShow: needShow, state: .favourite)
//    }
    
    func endRefreshing() {
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func reloadRows(with indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
            
    @objc private func refreshList(refreshControl: UIRefreshControl) {
        presenter.refreshList()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.favoritesList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return presenter.createCell(tableView, indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter.willDisplay(indexPath: indexPath)
    }
}
