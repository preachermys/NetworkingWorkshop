//
//  TrainingsListPresenter.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 15.04.2021.
//

import UIKit

typealias EmptyCompletion = () -> Void

protocol TrainingsListPresenterProtocol: LifecyclePresenter {
//    var router: TrainingsListRouterProtocol { get }
    var refreshControlLocal: UIRefreshControl? { get set }
//    var searchController: UISearchController? { get set }
    
//    func openTrainingFromPush(trainingId: String?)
//    func headerTapped(section: Int)
    
    // MARK: - TableView delegate and dataSource
    
    func viewForHeader(in section: Int) -> UIView?
    func numberOfSections() -> Int
    func willDisplay(cell: UITableViewCell, forRowAt indexPath: IndexPath)
    
    // MARK: - ScrollView
    
    func didEndDecelerating(section: Int?)
    func didScroll(_ scrollView: UIScrollView)
}

final class TrainingsListPresenter: NSObject, TrainingsListPresenterProtocol {
    
    private weak var view: TrainingsListView?
//    private(set) var router: TrainingsListRouterProtocol
    
//    private var searchVC: SearchVC?
    private var statusString: String = ""
    private var isRequestStarted: Bool = false
    private var currentPage: Int = 0
    private var indexOfLastCategory = 0
    private var contentOffsetDictionary: [AnyHashable: AnyObject]!

    private var trainings = [String: [TrainingEntity]]()
    private var trainingCategories = [TrainingCategoryEntity]()
    private var pushTrainingId: String?
    
//    private let reportService: ReportServiceProtocol!

    var searchController: UISearchController?
    var refreshControlLocal: UIRefreshControl?
    
    init(view: TrainingsListView?,
         pushTrainingId: String?
//         router: TrainingsListRouterProtocol,
//         reportService: ReportServiceProtocol
    ) {
        self.view = view
        self.pushTrainingId = pushTrainingId
//        self.router = router
//        self.reportService = reportService
    }
    
    func viewDidLoad() {
        setRefreshControlLocal()
//        setSearchController()
        
        view?.setTableView()
        
        getTrainings()
        
        contentOffsetDictionary = [NSObject: AnyObject]()
//        view?.setCategoryButton(with: createCategoryButton(with: "BurgerIcon"))
    }
    
    func viewWillAppear() {
//        view?.setNavigationBarSettings()
//
//        if !(searchController?.isActive ?? false) {
//            view?.setTabBarHidden(false)
//        }
//
//        updateProgress()
    }
    
//    func headerTapped(section: Int) {
//        if let sectionId = trainingCategories[section].id {
//            router.presentTrainingsSectionScreen(
//                trainingsCount: Constants.numbersOfTrainingsInCategory,
//                trainings: trainings[sectionId] ?? [],
//                trainingCategory: trainingCategories.filter { $0.id == sectionId }.first
//            )
//        }
//    }
//
//    private func setSearchController() {
//        if searchVC == nil {
//            searchVC = UIStoryboard.init(name: "GlobalControllers",
//                                         bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchVC") as? SearchVC
//            searchVC?.searchSourceType = .trainings
//            searchVC?.sectionType = .trainings
//        }
//
//        searchController = UISearchController(searchResultsController: searchVC)
//        searchController?.searchResultsUpdater = searchVC
//        searchController?.searchBar.sizeToFit()
//        searchController?.searchBar.placeholder = .emptyLine
//        searchController?.delegate = searchVC
//        searchVC?.searchController = searchController
//    }
//
//    private func createCategoryButton(with imageName: String) -> UIBarButtonItem {
//        let button = UIButton(type: .custom)
//
//        button.setImage(UIImage(named: imageName), for: .normal)
//        button.addTarget(self, action: #selector(categoryButtonPressed), for: .touchUpInside)
//        button.frame = CGRect(x: 0, y: 0, width: 60, height: 50)
//        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)
//
//        if #available(iOS 11.0, *) {
//            button.contentHorizontalAlignment = .trailing
//        }
//
//        let backButton = UIBarButtonItem(customView: button)
//
//        return backButton
//    }
//
//    @objc private func categoryButtonPressed() {
//        router.presentCategoriesList()
//    }
}

// MARK: - Set Refresh Controller

extension TrainingsListPresenter {
    private func setRefreshControlLocal() {
        refreshControlLocal = UIRefreshControl(frame: CGRect.zero)
        refreshControlLocal?.addTarget(
            self,
            action: #selector(refreshList(refreshControl:)),
            for: .valueChanged
        )
        
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        refreshControlLocal?.attributedTitle = NSAttributedString(
            string: "updating materials",
            attributes: attributes
        )
    }
    
    @objc func refreshList(refreshControl: UIRefreshControl) {
        TrainingService.shared.removeTrainingsFromDb()
        indexOfLastCategory = 0
        trainingCategories = []
        if isRequestStarted { return }
        isRequestStarted = true
        currentPage = 0
        
//        guard ConnectionService.shared.isConnected() else {
//            statusString = "NoConnection"
//            view?.reloadData()
//            return
//        }
        
        TrainingService.shared.getCategories(
            page: currentPage, perPage: 5
        ) { [weak self] trainingCategories in
            guard let self = self else {
                return
            }
            
            self.trainingCategories = trainingCategories
            self.statusString = ""
            if !trainingCategories.isEmpty {
//                self.router.showEmptyView(needShow: false, state: .training)
                self.getTrainingsForCategory(categoryIndex: 0)
            } else {
                self.view?.endRefreshing()
                self.view?.reloadData()
//                self.router.showEmptyView(needShow: self.trainingCategories.isEmpty, state: .training)
                self.isRequestStarted = false
//                self.router.dismissHUD()
            }
        }
    }

}

// MARK: - Get trainings

private extension TrainingsListPresenter {
    func getTrainings() {
//        guard ConnectionService.shared.isConnected() else {
//            statusString = "NoConnection"
//            view?.reloadData()
//            return
//        }
        
        TrainingService.shared.removeTrainingsFromDb()
        
//        router.presentHUD()
        isRequestStarted = true
        TrainingService.shared.getCategories(
            page: currentPage, perPage: 5
        ) { [weak self] trainingCategories in
            guard let self = self else {
                return
            }
            
            self.trainingCategories = trainingCategories
            if !trainingCategories.isEmpty {
                self.getTrainingsForCategory(categoryIndex: 0)
            } else {
//                self.router.showEmptyView(needShow: self.trainingCategories.isEmpty, state: .training)
                self.isRequestStarted = false
//                self.router.dismissHUD()
            }
        }
    }
    
    func getTrainingsForCategory(categoryIndex: Int) {
        let category = trainingCategories[categoryIndex]
        let trainingsIds = (category.trainingsIds?.allObjects as? [IdEntity])?.map({ $0.elementId ?? "" })
        guard let safeIds = trainingsIds?.prefix(Constants.numbersOfTrainingsInCategory) else { return }
        
        TrainingService.shared.getTrainingsByIds(
            categoryId: category.id ?? "",
            ids: Array(safeIds)
        ) { [weak self] (trainings, categoryId) in
            guard let self = self else {
                return
            }
            
            if trainings.isEmpty, let indexForRemove = self.trainingCategories.firstIndex(where: {$0.id == categoryId}) {
                self.trainingCategories.remove(at: indexForRemove)
            } else {
                var sortedTrainings: [TrainingEntity] = []
                
                trainings.enumerated().forEach { index, _ in
                    if let newTraining = trainings.first(where: { $0.id == safeIds[index] }) {
                        sortedTrainings.append(newTraining)
                    }
                }
                
                self.trainings[categoryId] = sortedTrainings
            }
            
            if self.trainingCategories.count > categoryIndex + 1 {
//                self.getProgressForTrainings(with: trainings) {
                    self.getTrainingsForCategory(categoryIndex: categoryIndex + 1)
//                }
            } else {
                if trainings.count < 1 {

                    self.view?.endRefreshing()
//                    self.router.showEmptyView(needShow: self.trainingCategories.isEmpty, state: .training)
                    self.isRequestStarted = false

                }
                
                self.view?.endRefreshing()
                self.view?.reloadData()
                self.isRequestStarted = false
                self.indexOfLastCategory = categoryIndex
//                    self.router.dismissHUD()

                if self.currentPage != Int.max {
                    self.currentPage += 1
                }
//                self.getProgressForTrainings(with: trainings) {
//                    self.view?.endRefreshing()
//                    self.view?.reloadData()
//                    self.isRequestStarted = false
//                    self.indexOfLastCategory = categoryIndex
////                    self.router.dismissHUD()
//
//                    if self.currentPage != Int.max {
//                        self.currentPage += 1
//                    }
//                }
            }
        }
    }

//    func getProgressForTrainings(with trainings: [TrainingEntity], completion: @escaping EmptyCompletion) {
//        let localGroup = DispatchGroup()
//
//        trainings
//            .compactMap { $0.id }
//            .chunked(into: 10)
//            .forEach {
//
//                getProgress(with: $0, in: trainings, dispatchGroup: localGroup)
//        }
//
//        localGroup.notify(queue: .global()) {
//            completion()
//        }
//    }
    
//    func getProgress(with ids: [String], in trainings: [TrainingEntity], dispatchGroup: DispatchGroup) {
//        dispatchGroup.enter()
//
//        reportService.getTrainingProgress(for: ids) { progress in
//            trainings.forEach { training in
//                if let progress = progress.first(where: { training.id == $0.trainingId && $0.taskId == nil }) {
//                    training.progress = progress.percentage
//                    training.cardsCompleted = Int32(progress.completed)
//                }
//            }
//
//            dispatchGroup.leave()
//        }
//    }
    
//    func updateProgress() {
//        if !trainings.isEmpty {
//
//            var trainingsContainer: [TrainingEntity] = []
//
//            trainings.values.forEach({ trainingsContainer.append(contentsOf: $0) })
//
//            getProgressForTrainings(with: trainingsContainer) { [weak self] in
//                self?.view?.reloadData()
//            }
//        }
//    }
}

// MARK: - Notification opening

//extension TrainingsListPresenter {
//    func openTrainingFromPush(trainingId: String?) {
//        guard let trainingId = trainingId else { return }
//
//        pushTrainingId = nil
//
//        router.presentHUD()
//
//        TrainingService.shared.getTrainings(
//            ids: [trainingId]
//        ) { [weak self] pushTrainings in
//            guard let strongSelf = self, let training = pushTrainings.first else {
//                self?.router.dismissHUD()
//                return
//            }
//
//            strongSelf.router.dismissHUD()
//
//            let vc = TrainingMainViewController.instantiateFrom(appStoryboard: .trainingMain)
//            training.isFavorited = FavoritesService.shared.isModelInFavorites(id: training.id ?? .emptyLine)
//
//            strongSelf.getProgressForTrainings(with: [training]) {
//                vc.configurator = TrainingMainConfigurator(trainingModel: training)
//                strongSelf.router.openFromPush(vc: vc)
//            }
//        }
//    }
//}

// MARK: - TableView and DataSource

extension TrainingsListPresenter {
    func viewForHeader(in section: Int) -> UIView? {
        if trainingCategories.count != 0 && section < trainingCategories.count {
            let view = TrainingSectionHeaderView(frame: CGRect.zero)
            view.titleLabel.text = trainingCategories[section].name
            
            if let trainingsInCategory = trainingCategories[section].trainingsIds?.count {
                view.subtitleLabel.text = "\(String(describing: trainingsInCategory))"
            }
            
            view.tag = section
//            view.headerTap = headerTapped
            
            return view
//        } else if !isRequestStarted,
//            !statusString.isEmpty,
//            let view = Bundle.main.loadNibNamed(statusString, owner: nil, options: nil)?.first as? ServerErrorView {
//
//            view.tryAgain.addTarget(self, action: #selector(refreshList(refreshControl:)), for: .touchUpInside)
//            return view
        } else if !isRequestStarted,
            !statusString.isEmpty,
            let view = Bundle.main.loadNibNamed(statusString, owner: nil, options: nil)?.first as? UIView {
            
            return view
        }
        
        return nil
    }
    
    func numberOfSections() -> Int {
        return trainingCategories.count
    }
    
    func willDisplay(cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let collectionCell = cell as? TrainingTVCell else { return }
        
        collectionCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, index: indexPath.section)
        
        let index = collectionCell.collectionView.tag
        let value = contentOffsetDictionary[index]
        
        let horizontalOffset = CGFloat(value != nil ? value!.floatValue : 0)
        
        collectionCell.collectionView.setContentOffset(
            CGPoint(x: horizontalOffset, y: 0),
            animated: false
        )
    }
}

// MARK: - CollectionView delegate and DataSource

extension TrainingsListPresenter: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard !trainingCategories.isEmpty, collectionView.tag < trainingCategories.count,
            let categoryTrainings = trainingCategories[collectionView.tag].trainingsIds else {
                return 0
        }
        
        if categoryTrainings.count > Constants.numbersOfTrainingsInCategory {
            return Constants.numbersOfTrainingsInCategory + 1
        }
        
        return categoryTrainings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if indexPath.row == Constants.numbersOfTrainingsInCategory {
//            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: TrainingMoreCell.self)
//
//            return cell
//        }
        
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: TrainingCVCell.self)
        let collectionViewArray = trainings[trainingCategories[collectionView.tag].id ?? ""]
        var trainingCategoriesCount = trainingCategories.count
        print("training categories count: ", trainingCategoriesCount)
        var tg = collectionView.tag
        print("collection view tag: ", tg)
        var ip = indexPath.row
        print("index path: ", ip)
        cell.prepareCell(trainingModel: collectionViewArray?[indexPath.row])
        cell.backgroundColor = UIColor.white
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == Constants.numbersOfTrainingsInCategory {
//            headerTapped(section: collectionView.tag)
        } else {
            let collectionViewArray = trainings[trainingCategories[collectionView.tag].id!]
            
//            router.presentTrainingMainScreen(
//                trainingModel: collectionViewArray?[indexPath.row],
//                categoryName: trainingCategories[collectionView.tag].name
//            )
        }
    }
    
    func didEndDecelerating(section: Int?) {
        if section == trainingCategories.count - 1 {
            if currentPage == Int.max { return }
            if isRequestStarted { return }
            isRequestStarted = true
            
            TrainingService.shared.getCategories(
                page: currentPage, perPage: 5
            ) { [weak self] trainingCategories in
                guard let self = self else {
                    return
                }
                
                if !trainingCategories.isEmpty {
                    self.trainingCategories.append(contentsOf: trainingCategories)
                    self.getTrainingsForCategory(categoryIndex: self.indexOfLastCategory + 1)
                } else {
                    self.isRequestStarted = false
                    self.currentPage = Int.max
                }
            }
        }
    }
    
    func didScroll(_ scrollView: UIScrollView) {
        if !(scrollView is UICollectionView) {
            return
        }
        
        let horizontalOffset = scrollView.contentOffset.x
        guard let collectionView = scrollView as? UICollectionView else { return }
        contentOffsetDictionary[collectionView.tag] = horizontalOffset as AnyObject
    }
}

// MARK: - Constants

private extension TrainingsListPresenter {
    enum Constants {
        static let numbersOfTrainingsInCategory: Int = 5
    }
}
