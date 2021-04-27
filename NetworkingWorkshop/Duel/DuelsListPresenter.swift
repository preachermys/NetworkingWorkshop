//
//  DuelsListPresenter.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 05.04.2021.
//

import UIKit

protocol DuelsListPresenterProtocol: LifecyclePresenter {
    var newDuelGameId: String? { get set }
    
    func configureCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func heightForHeaderInSection(_ section: Int) -> CGFloat
    func heightForRowAt(_ indexPath: IndexPath) -> CGFloat
    func numberOfRowsInSection(_ section: Int) -> Int
    func willDisplay(indexPath: IndexPath)
}

final class DuelsListPresenter: DuelsListPresenterProtocol {
   
    private let worker = DuelsWorker()
   
    private var moreWasTapped: [Int] = []
    
    private var statusString: String = ""
    private var isPaginatedStarted = false
    
    private weak var view: DuelsListView?

    var newDuelGameId: String?
    
    init(view: DuelsListView?,
         newDuelGameId: String? = nil) {
        
        self.view = view
        self.newDuelGameId = newDuelGameId
    }
    
    func viewDidLoad() {
        view?.setTableView()
        
        
        view?.setViewPreferences()
    }
    
    func viewWillAppear() {
        statusString = ""
        
        worker.getFavoriteDuels { [weak self] in
            self?.worker.getLikedDuels { _ in
                self?.view?.reloadData()
            }
        }
        
        refreshView()
        view?.setTableFooter()
    }
    
    @objc private func refreshList() {
        view?.endRefreshing()
        worker.refreshList { [weak self] _ in
            DispatchQueue.main.async {
                self?.view?.reloadData()
            }
        }
    }
    
    private func refreshView() {
        view?.reloadData()
        
        worker.refreshView { [weak self] _ in
            guard let self = self else { return }
            
            let completionHandler: () -> Void = { [weak self] in
                self?.newDuelGameId = nil
                
                self?.view?.reloadData()
            }
        }
    }
}

// MARK: - TableView

extension DuelsListPresenter {
    func configureCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if worker.duelsCount() == 0 {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: EmptyCell.self)
            cell.selectionStyle = .none
            cell.prepareView(title: "no_duels",
                             imageName: "empty-duels",
                             description: "prepare_fresh_duels_materials")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: DuelCell.self)
            
            cell.prepareView(duel: worker.getDuel(for: indexPath.row),
                             cellIndex: indexPath.row)
            return cell
        }
        

        
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        print(worker.duelsCount())
            return worker.duelsCount() == 0 ? 1 : worker.duelsCount()
    }
    
    func heightForHeaderInSection(_ section: Int) -> CGFloat {
        if section == 1 {
            return worker.duelsCount() == 0 ? 0 : 30
        }
        
        return 0
    }
    
    func heightForRowAt(_ indexPath: IndexPath) -> CGFloat {
        if worker.duelsCount() == 0 {
            return 0
        }
        
        return indexPath.section == 0 ? 100 : UITableView.automaticDimension
    }
    
    func willDisplay(indexPath: IndexPath) {
        let previousDuelsCount = worker.duelsCount()
        
        if worker.duelsCount() - 1 == indexPath.row {
            if isPaginatedStarted { return }
            isPaginatedStarted = true
            
            worker.getPaginatedDuels { [weak self] in
                DispatchQueue.main.async {
                    if self?.worker.duelsCount() != previousDuelsCount {
                        self?.view?.reloadData()
                    }
                    
                    self?.isPaginatedStarted = false
                }
            }
        }

    }
}
