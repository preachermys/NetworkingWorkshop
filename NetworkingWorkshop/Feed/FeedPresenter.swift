//
//  FeedPresenter.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 09.04.2021.
//

import UIKit

protocol FeedPresenterProtocol: LifecyclePresenter {
    var feedWorker: FeedWorker { get }
    
    var refreshControlLocal: UIRefreshControl? { get }
        
    func createCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    
    func paginate(with row: Int)
}

final class FeedPresenter: FeedPresenterProtocol, CardsPresenter {
    var selectedTag: String =  " "
    var moreTappedRows: [Int] = []
    
    var refreshControlLocal: UIRefreshControl?
    var isPost: Bool = true
    
    private var isRequestStarted: Bool = false
    private var isPaginatedStarted: Bool = false
    private var types: [FeedCardType]?

    private weak var view: FeedView?
    private var cellConfiguratorUseCase: CellConfiguratorUseCase
    let feedWorker: FeedWorker
            
    init(view: FeedView,
         feedWorker: FeedWorker,
         cellConfiguratorUseCase: CellConfiguratorUseCase
    ) {
        
        self.view = view
        self.feedWorker = feedWorker
        self.cellConfiguratorUseCase = cellConfiguratorUseCase
    }
    
    func viewDidLoad() {
        view?.registerCells()
        
        getFeedData()
        
        setRefreshControl()
        view?.setTableView()
        
        view?.setView()
    }
        
    func updateTableView() {
        view?.updateTableView()
    }
    
    func taskEntity(for cellIndex: Int) -> TaskEntity? {
        return nil
    }
    
    private func getFeedData() {
        isRequestStarted = true
        
        feedWorker.getFeedData(types: types) { [weak self] isEmpty in
            guard let self = self else { return }
            self.view?.reloadData()
            self.isRequestStarted = false
        }
        self.setCellConfigurator()
    }
    
    private func setCellConfigurator() {
        let feedReloadCardAdapter = ReloadAdapter(presenter: self)

        cellConfiguratorUseCase.setup(
            presenter: self,
            reloadAdapter: feedReloadCardAdapter
        )
    }
    
    private func setRefreshControl() {
        refreshControlLocal = UIRefreshControl()
        refreshControlLocal?.addTarget(self,
                                       action: #selector(refreshList(refreshControl:)),
                                       for: .valueChanged)
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        refreshControlLocal?.attributedTitle = NSAttributedString(string: "updating materials", attributes: attributes)
        view?.setRefreshControl(refreshControl: refreshControlLocal)
    }
    
    @objc private func refreshList(refreshControl: UIRefreshControl) {
        view?.endRefreshingControl()
        
        refreshFeed()
    }
    
    private func refreshFeed() {
        if isRequestStarted { return }
        isRequestStarted = true
        
        let localDispatchGroup = DispatchGroup()
        
        localDispatchGroup.enter()
        feedWorker.updateFeedData(types: types, completionHandler: { [weak self] in
            self?.moreTappedRows = []
            localDispatchGroup.leave()
        })
        
        localDispatchGroup.notify(queue: .global(qos: .userInitiated)) { [weak self] in
            DispatchQueue.main.async {
                self?.isRequestStarted = false
                self?.view?.reloadData()
                self?.view?.endRefreshingControl()
            }
        }
    }
        
    func createCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        guard !(feedWorker.cardsCount == 0) else { return UITableViewCell() }
        let type = feedWorker.getPostType(at: indexPath.row)
        let card = feedWorker.cardModel(for: indexPath.row)
        
        if !card.isRequiredPropertyExist {
            cell = tableView.dequeueReusableCell(for: indexPath, cellType: ErrorTVCell.self)

            cellConfiguratorUseCase.congifure(cell: cell, cellIndex: indexPath.row, card: card)

            return cell
        }
        
        switch type {
        case .timeline, .photo, .test, .duel, .photoMark, .longread, .kase:
            cell = tableView.dequeueReusableCell(for: indexPath, cellType: FeedTimeLineTVC.self)
        case .video:
            cell = tableView.dequeueReusableCell(for: indexPath, cellType: FeedVideoTVCell.self)
        case .openquestion:
            cell = tableView.dequeueReusableCell(for: indexPath, cellType: FeedOpenQuizTVCell.self)
        case .survey:
            cell = tableView.dequeueReusableCell(for: indexPath, cellType: FeedQuizTVCell.self)
        case .audio:
            cell = tableView.dequeueReusableCell(for: indexPath, cellType: FeedAudioTVCell.self)
        default:
            return UITableViewCell()
        }
        
        cellConfiguratorUseCase.congifure(cell: cell, cellIndex: indexPath.row, card: card)
        
        return cell
    }
    
    func paginate(with row: Int) {
        let previousCardsCount = feedWorker.cardsCount
        
        if feedWorker.cardsCount - 1 == row {
            if isPaginatedStarted { return }
            isPaginatedStarted = true
            
            feedWorker.getPaginatedFeedData(types: types) { [weak self] isEmpty in
                DispatchQueue.main.async {
                    if self?.feedWorker.cardsCount != previousCardsCount {
                        self?.view?.reloadData()
                    }
                    
                    self?.isPaginatedStarted = false
                }
            }
        }
    }
}

// MARK: - Methods for cells

extension FeedPresenter {
    
    private func feedTextType(cardModel: CardEntity?) -> String? {
        if !(cardModel as? SurveyEntity).isNil {
            return "ОПРОС"
        } else if !(cardModel as? OpenQuestionEntity).isNil {
            return "ОТКРЫТЫЙ ВОПРОС"
        } else if !(cardModel as? CaseCardEntity).isNil {
            return "КЕЙС"
        }
        
        return nil
    }
}

