//
//  FeedManager.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 30.03.2021.
//

import Alamofire

class FeedManager: CommonNetworkManager {
    
    // MARK: Get feed
    
    func getFeedIds(
        page: Int,
        timestamp: Int,
        searchTags: [String]? = nil,
        searchString: String? = nil,
        types: [FeedCardType]?,
        completion: @escaping ([PostModel]
    ) -> Void) {
        guard let userId = UserModel.shared.userId else { return }
        
        let request = FeedRouter.getFeed(
            userId: userId,
            page: page,
            timestamp: timestamp,
            searchTags: searchTags,
            searchString: searchString,
            types: types
        ).asURL()
        
        session.request(request).validate().responseJSON { response in
            
            switch response.result {
            case .success(let posts):
                var cards: [PostModel] = []
                if let data = posts as? [String: Any],
                    let dataList = data["data"] as? [[String: Any]] {
                    
                    for post in dataList {
                        let postModel = PostModel(dict: post)
                        cards.append(postModel)
                    }
                    completion(cards)
                }
            case .failure:
                completion([])
            }
        }
    }
    
    func getCards(with cardIds: [String]?, completion: @escaping ([CardEntity]) -> Void) {
        
        session.request(FeedRouter.getCards(cardIds: cardIds).asURL()).validate().responseJSON { response in
            
            switch response.result {
            case .success(let cards):
                if let data = cards as? [String: Any],
                    let dataList = data["data"] as? [[String: Any]] {
                    
                    let cards: [CardEntity] = dataList.compactMap({ card in
                        guard let cardModel = self.createCard(card: card) else { return nil }
                        return cardModel
                    })
                    
                    completion(cards)
                }
            case .failure:
                completion([])
            }
        }
    }
    
    // MARK: - Get posts by ids
    
    func getPosts(by ids: [String], completion: @escaping ([[String: Any]]) -> Void) {
        guard let userId = UserModel.shared.userId else { return }
        
        let request = FeedRouter.getPosts(userId: userId, by: ids).asURL()
        
        session.request(request).validate().responseJSON { response in
            
            switch response.result {
            case .success(let response):
                if let dict = response as? [String: Any],
                    let dataList = dict["data"] as? [[String: Any]] {
                    
                    completion(dataList)
                }
            case .failure:
                completion([])
            }
        }
    }
        
    // MARK: - Get tags
    
    func getTags(page: Int, searchString: String, completion: @escaping ([String]) -> Void) {
        guard let userId = UserModel.shared.userId else { return }
        
        let request = FeedRouter.getTags(userId: userId,
                                         page: page,
                                         searchString: searchString).asURL()
        
        session.request(request).validate().responseJSON { response in
            
            switch response.result {
            case .success(let response):
                if let dict = response as? [String: Any],
                    let dataArray = dict["data"] as? [String] {
                    
                    completion(dataArray)
                }
            case .failure:
                completion([])
            }
        }
    }
}

private extension FeedManager {
    func createCard(card: [String: Any]) -> CardEntity? {
        guard
            let cardDict = card["card"] as? [String: Any],
            let id = cardDict["id"] as? String,
            let type = cardDict["type"] as? String,
            let cardSpecial = card["special"] as? [String: Any]  else { return nil }

        var cardModel: CardEntity?
        
        cardModel = TimeLineCardEntity.createOrReuseEntity(id: id)
        (cardModel as? TimeLineCardEntity)?.updateFromDict(dict: cardDict, special: cardSpecial)
        cardModel?.setRequiredProperty(by: (cardModel as? TimeLineCardEntity)?.blocks)

//        switch FeedType(string: type) {
//        case .timeline:
//            cardModel = TimeLineCardEntity.createOrReuseEntity(id: id)
//            (cardModel as? TimeLineCardEntity)?.updateFromDict(dict: cardDict, special: cardSpecial)
//            cardModel?.setRequiredProperty(by: (cardModel as? TimeLineCardEntity)?.blocks)
//        case .longread:
//            cardModel = LongReadCardEntity.createOrReuseEntity(id: id)
//            (cardModel as? LongReadCardEntity)?.updateFromDict(dict: cardDict, special: cardSpecial)
//            cardModel?.setRequiredProperty(by: (cardModel as? LongReadCardEntity)?.blocks)
//        case .video:
//            cardModel = VideoCardEntity.createOrReuseEntity(id: id)
//            (cardModel as? VideoCardEntity)?.updateFromDict(dict: cardDict, special: cardSpecial)
//            cardModel?.setRequiredPropertyExplicit(isEmpty: (((cardModel as? VideoCardEntity)?.fileUrls?[safe: 0]) as String?)?.isEmpty)
//        case .audio:
//            cardModel = AudioCardEntity.createOrReuseEntity(id: id)
//            (cardModel as? AudioCardEntity)?.updateFromDict(dict: cardDict, special: cardSpecial)
//            cardModel?.setRequiredPropertyExplicit(isEmpty: (cardModel as? AudioCardEntity)?.fileUrl?.isEmpty)
//        case .photo:
//            cardModel = PhotoCardEntity.createOrReuseEntity(id: id)
//            (cardModel as? PhotoCardEntity)?.updateFromDict(dict: cardDict)
//            cardModel?.setRequiredPropertyExplicit(isEmpty: cardModel?.images?.isEmpty)
//        case .test:
//            cardModel = TestCardEntity.createOrReuseEntity(id: id)
//            (cardModel as? TestCardEntity)?.updateFromDict(dict: cardDict, special: cardSpecial)
//            cardModel?.setRequiredProperty(by: (cardModel as? TestCardEntity)?.questions)
//        case .kase:
//            cardModel = CaseCardEntity.createOrReuseEntity(id: id)
//            (cardModel as? CaseCardEntity)?.updateFromDict(dict: cardDict, special: cardSpecial)
//            cardModel?.setRequiredProperty(by: (cardModel as? CaseCardEntity)?.blocks)
//        case .openquestion:
//            cardModel = OpenQuestionEntity.createOrReuseEntity(id: id)
//            (cardModel as? OpenQuestionEntity)?.updateFromDict(dict: cardDict, special: cardSpecial)
//            cardModel?.setRequiredPropertyExplicit(isEmpty: cardModel?.images?.isEmpty)
//        case .survey:
//            cardModel = SurveyEntity.createOrReuseEntity(id: id)
//            (cardModel as? SurveyEntity)?.updateFromDict(dict: cardDict, special: cardSpecial)
//            cardModel?.setRequiredPropertyExplicit(isEmpty: cardModel?.images?.isEmpty)
//        case .photoMark:
//            cardModel = PhotoMarkCardEntity.createOrReuseEntity(id: id)
//            (cardModel as? PhotoMarkCardEntity)?.updateFromDict(dict: cardDict, special: cardSpecial)
//            cardModel?.setRequiredProperty(by: (cardModel as? PhotoMarkCardEntity)?.special)
//        default:
//            break
//        }
        return cardModel
    }
}
