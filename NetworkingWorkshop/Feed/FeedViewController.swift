//
//  FeedViewController.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 09.04.2021.
//

import UIKit

protocol FeedView: class {
    func registerCells()
    
    func isDataChanged() -> Bool
    func reloadData()
    func reloadRow(with rowIndex: Int, section: Int)
    
//    func showEmptyView(needShow: Bool)
    
    func updateTableView()
    
    func setRefreshControl(refreshControl: UIRefreshControl?)
    func endRefreshingControl()
    func setTableView()
    func setView()
//    func setSearchController()
//    func setEdgesForLayout()
//
//    func hideNavigationBar(isHidden: Bool)
//    func hideTabBar(isHidden: Bool)
//
//    func setFilterButton(with button: UIBarButtonItem)
}

final class FeedViewController: UITableViewController, FeedView {
    
    var configurator = FeedConfigurator()
    var presenter: FeedPresenterProtocol!
                
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(feedViewController: self)
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillAppear()
    }
    
    func setRefreshControl(refreshControl: UIRefreshControl?) {
        tableView.refreshControl = refreshControl
    }
    
    func endRefreshingControl() {
        tableView.refreshControl?.endRefreshing()
    }
    
    func registerCells() {
        tableView.register(cellType: FeedAudioTVCell.self)
        tableView.register(cellType: FeedTimeLineTVC.self)
        tableView.register(cellType: FeedQuizTVCell.self)
        tableView.register(cellType: FeedOpenQuizTVCell.self)
        tableView.register(cellType: FeedVideoTVCell.self)
        tableView.register(cellType: ErrorTVCell.self)
    }
    
    func setTableView() {
        let footerView = UIView()
        footerView.frame.size.height = 49
        tableView.tableFooterView = footerView

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = footerView
    }
    
    func isDataChanged() -> Bool {
        return tableView.dataHasChanged
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func reloadRow(with rowIndex: Int, section: Int = 0) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
//    func showEmptyView(needShow: Bool) {
//        showEmptyView(neadShow: needShow, state: .feed)
//    }
    
    func setView() {
        extendedLayoutIncludesOpaqueBars = true
        definesPresentationContext = true
    }
    
    func updateTableView() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension FeedViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.feedWorker.cardsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return presenter.createCell(tableView: tableView, indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter.paginate(with: indexPath.row)
    }
}

// MARK: - Maintenance searchBar appearance

extension FeedViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.panGestureRecognizer.translation(in: scrollView).y > 0 else {
            tableView.contentInset.top = 0
            return
        }
        
        guard scrollView.contentOffset.y > 0 else {
            return
        }

    }
}
