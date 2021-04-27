//
//  TrainingsListViewController.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 15.04.2021.
//

import UIKit

protocol TrainingsListView: class {
    func setTableView()
    func reloadData()
    func endRefreshing()
    
//    func setNavigationBarSettings()
//    func setTabBarHidden(_ isHidden: Bool)
    
    func visibleTableViewSection() -> Int?
    func setCategoryButton(with button: UIBarButtonItem)
}

final class TrainingsListViewController: UITableViewController, TrainingsListView {
    private enum Constants {
        static let numbersOfTrainingsInCategory: Int = 5
    }
    
//    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    public var navigationBarTintColor: UIColor? { return UIColor.white }
    public var navigationTintColor: UIColor? { return UIColor.black }
    
    var configurator: TrainingsListConfiguratorProtocol = TrainingsListConfigurator()
    var presenter: TrainingsListPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(viewController: self)
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillAppear()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    func setTableView() {
        tableView.register(TrainingTVCell.self, forCellReuseIdentifier: "TrainingTVCell")
        tableView.separatorStyle = .none
        tableView.refreshControl = presenter.refreshControlLocal
        
        let footerView = UIView()
        footerView.frame.size.height = 49
        tableView.tableFooterView = footerView
        
//        if #available(iOS 11.0, *) {
//            navigationItem.searchController = presenter.searchController
//            navigationItem.hidesSearchBarWhenScrolling = true
//        } else {
//            tableView.tableHeaderView = presenter.searchController?.searchBar
//        }
        
        extendedLayoutIncludesOpaqueBars = true
        definesPresentationContext = true
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func endRefreshing() {
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
        
//    func setNavigationBarSettings() {
//        navigationController?.navigationBar.isTranslucent = false
//
//        let backButton = UIBarButtonItem()
//        backButton.title = "back".localized
//        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
//
//        navigationItem.backBarButtonItem?.tintColor = .systemBlue
//
//        if #available(iOS 13.0, *) {
//            presenter.searchController?.searchBar.setBlueCancelButton()
//        }
//
//        if #available(iOS 11.0, *) {
//            navigationController?.navigationBar.prefersLargeTitles = true
//            navigationItem.largeTitleDisplayMode = .never
//        }
//
//        navigationController?.setNavigationBarHidden(false, animated: true)
//
//        navigationController?.navigationBar.barTintColor = .navBarDefaultColor
//        navigationController?.navigationBar.titleTextAttributes = [
//            NSAttributedString.Key.foregroundColor: UIColor.black
//        ]
//
//        if #available(iOS 13.0, *) {
//            let navBarAppearance = UINavigationBarAppearance()
//            navBarAppearance.configureWithOpaqueBackground()
//            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
//
//            navBarAppearance.backgroundColor = .navBarDefaultColor
//            navigationController?.navigationBar.standardAppearance = navBarAppearance
//            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
//        }
//    }
//
//    func setTabBarHidden(_ isHidden: Bool) {
//        tabBarController?.tabBar.isHidden = isHidden
//    }
    
    func visibleTableViewSection() -> Int? {
        tableView.indexPathsForVisibleRows?.last?.section
    }
    
    func setCategoryButton(with button: UIBarButtonItem) {
        navigationItem.rightBarButtonItem = button
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView is UITableView {
            presenter.didEndDecelerating(
                section: tableView.indexPathsForVisibleRows?.last?.section
            )
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        presenter.didScroll(scrollView)
    }
}

// MARK: - TableView delegates and data sources

extension TrainingsListViewController {
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 84
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        presenter.viewForHeader(in: section)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        presenter.numberOfSections()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TrainingTVCell.self)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter.willDisplay(cell: cell, forRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 206
    }
}
