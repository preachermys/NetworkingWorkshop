//
//  FavoritesPresenter.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 15.04.2021.
//

import UIKit

protocol FavoritesPresenterProtocol: CardsPresenter, LifecyclePresenter {
//    var router: FavoritesRouterProtocol { get }
    var favoritesList: [CardEntity] { get set }
    
    func fetchData()
    
    func refreshList()
    func createCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func willDisplay(indexPath: IndexPath)
}

final class FavoritesPresenter: FavoritesPresenterProtocol {
    enum Contants {
        static let favoritesUpdateNotification: String = "FavoritesUpdate"
    }
    
    var selectedTag: String = ""
    var moreTappedRows: [Int] = []
    var favoritesList: [CardEntity] = []
    var isPost: Bool = true
    
    private var paginationOffset: Int = 10
    private var paginatePage: Int = 0
    private var isPaginatedStarted: Bool = false
    private var isPaginationNeed: Bool = true
    private var postFavoritesModel: [FavoriteModelData] = []
    private var trainingFavoritesModel: [FavoriteModelData] = []
    private var duelFavoritesModel: [FavoriteModelData] = []
    
    private var favoritesContainer: [CardEntity] = []
    private var isRequestStarted: Bool = false
//    private var favoritesOpenCardAdapter: OpenCardAdapter?
//    private var surveyStarsSelected: Int?
//    private var comment: [Int: String] = [:]
    
    private weak var view: FavoritesView?
//    private(set) var router: FavoritesRouterProtocol
    private var cellConfiguratorUseCase: CellConfiguratorUseCase
    
//    private let reportService: ReportServiceProtocol!
    
    init(view: FavoritesView?,
         cellConfiguratorUseCase: CellConfiguratorUseCase
//         router: FavoritesRouterProtocol,
//         reportService: ReportServiceProtocol
    ) {
        self.view = view
        self.cellConfiguratorUseCase = cellConfiguratorUseCase
//        self.router = router
//        self.reportService = reportService
    }
    
    func viewDidLoad() {
        view?.setTableView()
        view?.setTitle(with: "Favorites")
    }
    
    func viewWillAppear() {
//        view?.setNavigationBarHidden(false)
//
//        AnaliticsContainer
//            .shared
//            .analiticsProvider
//            .openFavorites()
        
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(Contants.favoritesUpdateNotification),
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self else {
                return
            }
            
            if (notification.object as? CardEntity)?.isFavorited == false {
                self.favoritesList.removeAll(where: { $0.id == (notification.object as? CardEntity)?.id })
//                self.favoritesOpenCardAdapter?.updateCardEntities(with: self.favoritesList)
                self.view?.reloadTableView()
            } else if (notification.object as? CardEntity)?.isFavorited == true {
                
                if let favorite = self.favoritesList.first(where: { $0.id == (notification.object as? CardEntity)?.id }) {
                    favorite.likesCount = (notification.object as? CardEntity)?.likesCount ?? 0
                    favorite.isLiked = (notification.object as? CardEntity)?.isLiked ?? false
//                    self.favoritesOpenCardAdapter?.updateCardEntities(with: self.favoritesList)
                    self.view?.reloadTableView()
                } else if let card = notification.object as? CardEntity {
                    self.favoritesList.insert(card, at: 0)
//                    self.favoritesOpenCardAdapter?.updateCardEntities(with: self.favoritesList)
                    self.view?.reloadTableView()
                }
            }
        }
    }
        
    func fetchData() {
        fetchFavorites()
    }
//
//    func viewWillDisappear() {
//        view?.setNavigationBarHidden(true)
//    }
    
    func refreshList() {
        if isRequestStarted { return }
        isRequestStarted = true
        
        paginatePage = 0
        favoritesContainer.removeAll()
        isPaginationNeed = true

//        router.presentHUD()
        
        FavoritesService.shared.getAllFavorites { [weak self] cardsFavorites, trainingFavorites, duelsFavorites in
            self?.postFavoritesModel = cardsFavorites
            self?.trainingFavoritesModel = trainingFavorites
            self?.duelFavoritesModel = duelsFavorites

            self?.favoritesList.removeAll()

            self?.getFavoritePosts(
                cardsFavorites: cardsFavorites,
                trainingsFavorites: trainingFavorites,
                duelsFavorites: duelsFavorites
            ) {
//                self?.router.dismissHUD()
//                self?.getReports()
                self?.isRequestStarted = false
                self?.view?.endRefreshing()
            }
        }
    }
    
    func taskEntity(for cellIndex: Int) -> TaskEntity? {
        return nil
    }
    
    private func fetchFavorites() {
//        router.presentHUD()
        
        paginatePage = 0
        favoritesList.removeAll()
        favoritesContainer.removeAll()
        isPaginationNeed = true

        FavoritesService.shared.getAllFavorites { [weak self] cardsFavorites, trainingFavorites, duelsFavorites in
            self?.postFavoritesModel = cardsFavorites
            self?.trainingFavoritesModel = trainingFavorites
            self?.duelFavoritesModel = duelsFavorites
            
            self?.getFavoritePosts(
                cardsFavorites: cardsFavorites,
                trainingsFavorites: trainingFavorites,
                duelsFavorites: duelsFavorites
            ) {
                self?.setCellConfigurator()
//                self?.getReports()
//                self?.router.dismissHUD()
            }
        }
    }
    
    private func setCellConfigurator() {
//        let surveyDelegate = SurveyDelegateAdapter(presenter: self)
//        let commentDelegate = CommentDelegateAdapter(presenter: self)
        
//        let cards = favoritesList.compactMap { $0 }
//
//        favoritesOpenCardAdapter = OpenCardAdapter(
//            router: router,
////            surveyDelegate: surveyDelegate,
////            commentDelegate: commentDelegate,
//            cardEntities: cards
////            openFromPush: false
//        )
        
        let feedReloadCardAdapter = ReloadAdapter(presenter: self)
        
        cellConfiguratorUseCase.setup(
            presenter: self,
//            openCardAdapter: favoritesOpenCardAdapter,
            reloadAdapter: feedReloadCardAdapter
        )
    }
    
    func createCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if favoritesList[indexPath.row].type == nil
            || FeedType(string: favoritesList[indexPath.row].type ?? "post") == .training,
            let training = favoritesList[indexPath.row] as? TrainingEntity {
            
            cell = tableView.dequeueReusableCell(for: indexPath, cellType: TrainingSectionTVCell.self)
            
            cellConfiguratorUseCase.congifure(
                cell: cell,
                cellIndex: indexPath.row,
                card: training
            )
            
            cell.contentView.backgroundColor = UIColor.BasicUI.backgroundLightGray
            
            return cell
        }
        
        switch FeedType(string: favoritesList[indexPath.row].type!) {
        case .timeline, .photo, .test, .photoMark, .longread, .kase:
            cell = tableView.dequeueReusableCell(for: indexPath, cellType: FeedTimeLineTVC.self)
        case .duel:
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
        
        cellConfiguratorUseCase.congifure(
            cell: cell,
            cellIndex: indexPath.row,
            card: favoritesList[indexPath.row]
        )
        
        cell.contentView.backgroundColor = UIColor.BasicUI.backgroundLightGray
        
        return cell
    }
    
    func willDisplay(indexPath: IndexPath) {
        let previousCardsCount = favoritesList.count
        
        if favoritesList.count - 1 == indexPath.row, isPaginationNeed {
            if isPaginatedStarted { return }
            isPaginatedStarted = true
            
            paginatePage += 1
            
//            router.presentHUD()
            
            getFavoritePosts(
                cardsFavorites: postFavoritesModel,
                trainingsFavorites: trainingFavoritesModel,
                duelsFavorites: duelFavoritesModel
            ) {
                DispatchQueue.main.async {
                    if self.favoritesList.count != previousCardsCount {
//                        self.favoritesOpenCardAdapter?.updateCardEntities(with: self.favoritesList)
                        self.view?.reloadTableView()
                    } else {
                        self.isPaginationNeed = false
                    }
                    
                    self.isPaginatedStarted = false
//                    self.router.dismissHUD()
                }
            }
        }
    }
}

// MARK: - Fetch all types of content

private extension FavoritesPresenter {
    func getFavoritePosts(
        cardsFavorites: [FavoriteModelData],
        trainingsFavorites: [FavoriteModelData],
        duelsFavorites: [FavoriteModelData],
        completion: EmptyClosure? = nil
    ) {
        var chunkModels = cardsFavorites + trainingsFavorites + duelsFavorites
        chunkModels.sort(by: { $0.created?.toDate() ?? Date() > $1.created?.toDate() ?? Date() })

        let (cardsFavorites, trainingsFavorites, duelsFavorites) = resolveFavoritesRequest(favoritesModels: chunkModels)
            
        favoritesContainer.removeAll()
        
        getFavoriteCards(favorites: cardsFavorites) { [weak self] in
            guard let self = self else { return }
            
            self.getFavoriteDuels(favorites: duelsFavorites) {
                self.getFavoriteTrainings(favorites: trainingsFavorites) {
                    self.favoritesContainer.sort {
                        guard let firstPublished = $0.favoriteCreated,
                            let secondPublished = $1.favoriteCreated else {
                                return false
                        }
                        return firstPublished > secondPublished
                    }
                    
                    self.favoritesList.append(contentsOf: self.favoritesContainer)
                    self.favoritesList.forEach({ $0.isFavorited = true })
                    
                    DispatchQueue.main.async {
//                        self.view?.showEmptyView(needShow: self.favoritesList.isEmpty)
                        self.view?.reloadTableView()
                    }
                    
                    completion?()
                }
            }
        }
    }

    func getFavoriteCards(favorites: [FavoriteModelData], completion: @escaping EmptyClosure) {
        guard !favorites.isEmpty else {
            return completion()
        }
        
        let postIdsList = favorites.compactMap({ $0.entityId })
        FeedService.shared.getCardsByIds(ids: postIdsList) { [weak self] cards in
            cards.forEach { card in
                card.favoritesCount = Int16(favorites.first(where: { $0.entityId == card.postId })?.favoritesCount ?? 0)
                card.likesCount = Int16(favorites.first(where: { $0.entityId == card.postId })?.likesCount ?? 0)
                card.favoriteCreated = favorites.first(where: { $0.entityId == card.postId })?.created?.toDate() ?? Date()
            }
            
            self?.favoritesContainer.append(contentsOf: cards)
            completion()
        }
    }
    
    func getFavoriteDuels(favorites: [FavoriteModelData], completion: @escaping EmptyClosure) {
        guard !favorites.isEmpty else {
            return completion()
        }
        
        let duelsIdsList = favorites.compactMap({ $0.entityId })
        DuelsService.shared.getDuelsBy(ids: duelsIdsList, completionHandler: { [weak self] duels in
            duels.forEach { duel in
                duel.favoritesCount = Int16(favorites.first(where: { $0.entityId == duel.id })?.favoritesCount ?? 0)
                duel.likesCount = Int16(favorites.first(where: { $0.entityId == duel.id })?.likesCount ?? 0)
                duel.favoriteCreated = favorites.first(where: { $0.entityId == duel.id })?.created?.toDate() ?? Date()
            }
            
            self?.favoritesContainer.append(contentsOf: duels.unique)
            completion()
        })
    }
    
    func getFavoriteTrainings(favorites: [FavoriteModelData], completion: @escaping EmptyClosure) {
        guard !favorites.isEmpty else {
            return completion()
        }

        let trainingsIdsList = favorites.compactMap({ $0.entityId })
        TrainingService.shared.getTrainingsByIds(
            categoryId: "",
            ids: trainingsIdsList
        ) { [weak self] (trainings, _) in
            trainings.forEach { training in
                training.favoritesCount = Int16(favorites.first(where: { $0.entityId == training.id })?.favoritesCount ?? 0)
                training.likesCount = Int16(favorites.first(where: { $0.entityId == training.id })?.likesCount ?? 0)
                training.favoriteCreated = favorites.first(where: { $0.entityId == training.id })?.created?.toDate() ?? Date()
            }
            
            self?.favoritesContainer.append(contentsOf: trainings)
            completion()
        }
    }
    
    private func resolveFavoritesRequest(
        favoritesModels: [FavoriteModelData]
    ) -> ([FavoriteModelData], [FavoriteModelData], [FavoriteModelData]) {
        var postFavorites: [FavoriteModelData] = []
        var trainingFavorites: [FavoriteModelData] = []
        var duelFavorites: [FavoriteModelData] = []
        
        let favoritesChunkedModels = favoritesModels.chunked(into: paginationOffset)
        
        if let favoritesForRequest = favoritesChunkedModels[safe: paginatePage] {
            postFavorites = favoritesForRequest.filter({ $0.type == .post })
            trainingFavorites = favoritesForRequest.filter({ $0.type == .training })
            duelFavorites = favoritesForRequest.filter({ $0.type == .duel })
        }
        
        return (postFavorites, trainingFavorites, duelFavorites)
    }
}

// MARK: - Fetch reports

//private extension FavoritesPresenter {
//    func getReports() {
//        let trainingIds = favoritesList
//            .filter({ $0.type == FavoriteType.training.stringValue() })
//            .compactMap({ $0.id })
//
//        let cardIds = favoritesList
//            .filter({ $0.type != FavoriteType.training.stringValue() })
//            .compactMap({ $0.id })
//
//        let localGroup = DispatchGroup()
//
//        localGroup.enter()
//        reportService.getReports(for: trainingIds, with: .trainings) { [weak self] reports in
//            self?.favoritesList.forEach { card in
//                if let report = reports.first(where: { $0.id == card.id }) {
//                    card.reports.removeAll()
//                    card.reports.append(report)
//                }
//            }
//            localGroup.leave()
//        }
//
//        localGroup.enter()
//        reportService.getReports(for: cardIds, with: .cards) { [weak self] reports in
//            self?.favoritesList.forEach { card in
//                if let report = reports.first(where: { $0.id == card.id }) {
//                    card.reports.removeAll()
//                    card.reports.append(report)
//                }
//            }
//            localGroup.leave()
//        }
//
//        localGroup.notify(queue: .main) {
//            self.view?.reloadTableView()
//        }
//    }
//}

// MARK: - Cells methods

extension FavoritesPresenter {
//    func shareButtonTap(cellIndex: Int) {
//        guard let id = favoritesList[cellIndex].id,
//            let type = favoritesList[cellIndex].type else { return }
//
//        router.presentHUD()
//
//        switch FeedType(string: type) {
//        case .training:
//            getShareLinkTraining(for: id, cellIndex: cellIndex)
//        case .duel:
//            getShareLinkDuel(for: id, cellIndex: cellIndex)
//        default:
//            getShareLinkCard(for: id, cellIndex: cellIndex)
//        }
//    }
//
//    func tapOnLink(url: URL) {
//        router.openLink(with: url)
//    }
//
//    func commentSend(cellIndex: Int) {
//        if !isCommentsAvailable(cellIndex: cellIndex) {
//            router.showToast(with: "Комментарий отправлен".localized)
//        }
//
//        favoritesList[cellIndex].isCommentSend = true
//        view?.reloadRows(with: IndexPath(row: cellIndex, section: 0))
//    }
//
//    func addMarkButtonAction(cellIndex: Int, stars: Int, isReportSend: Bool) {
//        surveyStarsSelected = stars
//        guard let updatedCard = favoritesList[cellIndex] as? SurveyEntity else { return }
//        updatedCard.starsCount = Int16(stars)
//        favoritesList[cellIndex] = updatedCard
//        FeedService.shared.saveCards()
//        surveyStarsSelected = nil
//
//        if !isReportSend { sendReport(event: .surveyCompleted, cellIndex: cellIndex) }
//
//        router.showToast(with: "Оценка отправлена".localized)
//        view?.reloadRows(with: IndexPath(row: cellIndex, section: 0))
//    }
//
//    func favoriteButtonTap(isFavorited: Bool, cellIndex: Int) {
//        guard
//            let id = favoritesList[cellIndex].id,
//            let type = favoritesList[cellIndex].type else { return }
//
//        guard !isFavorited else { return }
//
//        switch type {
//        case "training": FavoritesService.shared.removeFavoriteTrainings(trainingId: id)
//        case "duel": FavoritesService.shared.removeFavoriteDuel(duelId: id)
//        default:
//            guard let postId = favoritesList[cellIndex].postId else { return }
//            FavoritesService.shared.removeFavoritePost(postId: postId)
//        }
//
//        favoritesList[cellIndex].isFavorited = isFavorited
//        favoritesList.remove(at: cellIndex)
//
//        view?.reloadTableView()
//    }
//
//    func addCommentButtonAction(cellIndex: Int) {
//        router.presentCommentScreen(
//            cardModel: favoritesList[cellIndex],
//            commentDelegate: self,
//            needShowComments: isCommentsAvailable(cellIndex: cellIndex),
//            cellIndex: cellIndex,
//            feedTypeText: feedTextType(cardModel: favoritesList[cellIndex])
//        )
//    }
//
//    func tagSelected(cellIndex: Int, tags: [String]) { }
//
//    func likeButtonTap(isLiked: Bool, cellIndex: Int) {
//        guard
//            let userId = UserModel.shared.userId,
//            let id = favoritesList[cellIndex].id,
//            let type = favoritesList[cellIndex].type else { return }
//
//        favoritesList[cellIndex].isLiked = isLiked
//
//        switch type {
//        case "duel":
//            if isLiked {
//                LikesService.shared.addLikedDuel(userId: userId, duelId: id) { [weak self] likeModel in
//                    self?.favoritesList[cellIndex].likesCount = Int16(likeModel.likesCount)
//                }
//            } else {
//                favoritesList[cellIndex].likesCount -= 1
//                LikesService.shared.removeLikedDuel(userId: userId, duelId: id)
//            }
//        default:
//            guard let postId = favoritesList[cellIndex].postId else { return }
//
//            if isLiked {
//                LikesService.shared.addLikedPost(userId: userId, postId: postId) { [weak self] card in
//                    self?.favoritesList[cellIndex].likesCount = card.likesCount
//                }
//            } else {
//                favoritesList[cellIndex].likesCount -= 1
//                LikesService.shared.removeLikedPost(userId: userId, postId: postId)
//            }
//        }
//    }
        
    func updateTableView() {
        view?.reloadTableView()
    }
    
    // MARK: - Private
    
//    private func getShareLinkDuel(for id: String, cellIndex: Int) {
//        FavoritesService.shared.getShareLinkDuels(for: id) { [weak self] shareUrl in
//            self?.showShareMenu(with: shareUrl,
//                                type: .duel,
//                                cellIndex: cellIndex)
//        }
//    }
//
//    private func getShareLinkCard(for id: String, cellIndex: Int) {
//        FavoritesService.shared.getShareLinkCard(for: id) { [weak self] shareUrl in
//            self?.showShareMenu(with: shareUrl, cellIndex: cellIndex)
//        }
//    }
//
//    private func getShareLinkTraining(for id: String, cellIndex: Int) {
//        FavoritesService.shared.getShareLinkTraining(for: id) { [weak self] shareUrl in
//            self?.showShareMenu(with: shareUrl,
//                                type: .training,
//                                cellIndex: cellIndex)
//        }
//    }
//
//    private func showShareMenu(with url: String,
//                               type: ShareType = ShareType.feed,
//                               cellIndex: Int) {
//        router.showShareActivity(favoritesList[cellIndex], shareUrl: url, type: type)
//        DispatchQueue.main.async { [weak self] in
//            self?.router.dismissHUD()
//            self?.view?.reloadTableView()
//        }
//    }
//
//    private func isCommentsAvailable(cellIndex: Int) -> Bool {
//        if let card = favoritesList[safe: cellIndex] as? SurveyEntity {
//            return card.isWithComments
//        } else if let card = favoritesList[safe: cellIndex] as? OpenQuestionEntity {
//            return card.isWithComments
//        } else {
//            return false
//        }
//    }
    
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

// MARK: - Report service

//private extension FavoritesPresenter {
//    func sendReport(event: ReportEventType, cellIndex: Int) {
//        let body = createReportBody(comment: comment[cellIndex])
//        let report = ReportModel(cardModel: favoritesList[cellIndex], taskId: favoritesList[cellIndex].taskId, event: event, body: body)
//        
//        reportService.postReport(report)
//    }
//    
//    func createReportBody(comment: String?) -> [String: String] {
//        guard let comment = comment else { return [:] }
//        return ["comment": comment]
//    }
//}

// MARK: - Comment delegate

//extension FavoritesPresenter: CommentDelegate {
//
//    func answerSent(forCell: Int?, comment: String) {
//        guard let cell = forCell else { return }
//
//        if !(favoritesList[cell] as? SurveyEntity).isNil {
//            self.comment[cell] = comment
//        }
//
//        guard let id = favoritesList[cell].id else { return }
//
//        reportService.getReports(cardId: id) { [weak self] reports in
//            self?.favoritesList[cell].reports.removeAll()
//            self?.favoritesList[cell].reports.append(contentsOf: reports)
//
//            DispatchQueue.main.async {
//                self?.view?.reloadRows(with: IndexPath(row: cell, section: 0))
//                self?.commentSend(cellIndex: cell)
//            }
//        }
//    }
//}


extension UIColor {
    
    enum BasicUI {
        static let backgroundLightGray = UIColor(red: 243.0 / 255.0, green: 245.0 / 255.0, blue: 249.0 / 255.0, alpha: 1)
    }
}
