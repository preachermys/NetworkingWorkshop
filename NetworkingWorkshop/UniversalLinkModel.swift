//
//  UniversalLinkModel.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 31.03.2021.
//

import UIKit

enum ErrorDescription {
    case cardBlocked, trainingBlocked, duelBlocked
    case invalidData, notFound, unknown, unavailable
    case cardAlreadyBlocked, trainingAlreadyBlocked, duelAlreadyBlocked
    case cardNotPublished, trainingNotPublished, duelNotPublished
    case categoryBlocked, categoryUnavailable
    
    init(string: String) {
        switch string {
        case "card_blocked":
            self = .cardBlocked
        case "training_blocked":
            self = .trainingBlocked
        case "duel_blocked":
            self = .duelBlocked
        case "invalid_data":
            self = .invalidData
        case "not_found":
            self = .notFound
        case "card_unavailable", "training_unavailable", "duel_unavailable":
            self = .unavailable
        case "card_already_blocked":
            self = .cardAlreadyBlocked
        case "training_already_blocked":
            self = .trainingAlreadyBlocked
        case "duel_already_blocked":
            self = .duelAlreadyBlocked
        case "unknown":
            self = .unknown
        case "card_not_published":
            self = .cardNotPublished
        case "training_not_published":
            self = .trainingNotPublished
        case "duel_not_published":
            self = .duelNotPublished
        case "category_already_blocked":
            self = .categoryBlocked
        case "category_unavailable":
            self = .categoryUnavailable
        default:
            self = .unknown
        }
    }
}

struct LinkError {
    let statusCode: Int
    let type: ErrorDescription
    
    func errorDescription() -> String {
        switch type {
        case .duelBlocked, .duelAlreadyBlocked:
            return "share_error_duel"
        case .cardBlocked, .cardAlreadyBlocked:
            return "share_error_card"
        case .trainingBlocked, .trainingAlreadyBlocked:
            return "share_error_training"
        case .unknown, .categoryUnavailable:
            return "link_no_access"
        case .invalidData:
            return "link_incorrect"
        case .notFound:
            return "link_incorrect"
        case .unavailable:
            return "link_no_access"
        case .cardNotPublished:
            return "link_unpublished_card"
        case .trainingNotPublished:
            return "link_unpublished_exercise"
        case .duelNotPublished:
            return "link_unpublished_duel"
        case .categoryBlocked:
            return "link_administrator_blocked"
        }
    }
    
    func imageForError() -> UIImage? {
        switch type {
        case .duelBlocked, .cardBlocked, .trainingBlocked,
             .cardAlreadyBlocked, .trainingAlreadyBlocked, .duelAlreadyBlocked:
            return UIImage(named: "no_access")
        case .unknown:
            return UIImage(named: "no_access")
        case .invalidData:
            return UIImage(named: "incorrect")
        case .notFound:
            return UIImage(named: "incorrect")
        case .unavailable:
            return UIImage(named: "no_access")
        case .cardNotPublished:
            return UIImage(named: "unpublished_card")
        case .trainingNotPublished:
            return UIImage(named: "unpublished_training")
        case .duelNotPublished:
            return UIImage(named: "unpublished_duel")
        case .categoryUnavailable:
            return UIImage(named: "no_access")
        case .categoryBlocked:
            return UIImage(named: "unavailable")
        }
    }
}

enum UniversalType: String {
    case training
    case post
    case duel
    case category
    
    init(string: String) {
        switch string {
        case "training":
            self = .training
        case "post":
            self = .post
        case "duel":
            self = .duel
        case "category":
            self = .category
        default:
            self = .post
        }
    }
}

final class UniversalLinkModel {
    var id: String = ""
    var type: UniversalType = .post
    
    init(dict: [String: Any]) {
        guard let id = dict["id"] as? String,
            let type = dict["type"] as? String else { return }
        self.id = id
        self.type = UniversalType(string: type)
    }
}

