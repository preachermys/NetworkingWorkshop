//
//  DuelsListViewController.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 05.04.2021.
//

import UIKit

protocol DuelsListView: class {
    func setTableView()
    func setTableFooter()
    func endRefreshing()
    func reloadData()
    func updateData()
    func reloadRows(at indexPath: [IndexPath])
    
    func setViewPreferences()
    
}

final class DuelsListViewController: UITableViewController, DuelsListView {
    
    var configurator: DuelsListConfiguratorProtocol = DuelsListConfigurator()
    var presenter: DuelsListPresenterProtocol!
    
    public var navigationBarTintColor: UIColor? { return .white }
    public var navigationTintColor: UIColor? { return .black }
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(viewController: self)
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillAppear()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.viewDidAppear()
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    func setTableView() {
        tableView.separatorColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 350
        tableView.register(cellType: EmptyCell.self)
    }
    
    
    func endRefreshing() {
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func reloadRows(at indexPath: [IndexPath]) {
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: indexPath, with: .none)
        }
    }
    
    func setViewPreferences() {
        extendedLayoutIncludesOpaqueBars = true
        definesPresentationContext = true
        navigationItem.backBarButtonItem?.title = "  "
    }
    
    
    func setTableFooter() {
        let footerView = UIView()
        footerView.frame.size.height = 49
        tableView.tableFooterView = footerView
        
        guard #available(iOS 11, *) else {
            edgesForExtendedLayout = UIRectEdge(rawValue: 0)
            return
        }
    }
    
    func updateData() {
        UIView.transition(with: tableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { self.tableView.reloadData() })
    }
}

extension DuelsListViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard scrollView.panGestureRecognizer.translation(in: scrollView).y > 0 else {
            tableView.contentInset.top = 0
            return
        }
        
        guard scrollView.contentOffset.y > 0 else {
            tableView.contentInset.top = 0
            return
        }
        
    }
}

extension DuelsListViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return presenter.heightForHeaderInSection(section)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 400
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return presenter.numberOfRowsInSection(section)
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return presenter.configureCell(tableView, indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter.willDisplay(indexPath: indexPath)
    }
}

