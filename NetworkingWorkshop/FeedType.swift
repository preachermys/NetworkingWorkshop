//
//  FeedType.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 31.03.2021.
//

import Foundation

enum FeedType: String {
    case timeline = "ТАЙМЛАЙН"
    case test = "ТЕСТ"
    case survey = "ОПРОС"
    case photo = "ФОТО"
    case video = "ВИДЕО"
    case audio = "АУДИО"
    case openquestion = "ОТКРЫТЫЙ ВОПРОС"
    case duel = "ДУЭЛЬ"
    case photoMark = "ФОТОМЕТКИ"
    case longread = "ЛОНГРИД"
    case kase = "КЕЙС"
    case training = ""
    case finish = "ФИНИШ"

    init(string: String) {
        switch string {
        case "timeline":
            self = .timeline
        case "test":
            self = .test
        case "photo":
            self = .photo
        case "video":
            self = .video
        case "audio":
            self = .audio
        case "openquestion":
            self = .openquestion
        case "survey":
            self = .survey
        case "duel":
            self = .duel
        case "photomark":
            self = .photoMark
        case "longread":
            self = .longread
        case "case":
            self = .kase
        case "training":
            self = .training
        case "kase":
            self = .kase
        case "finish":
            self = .finish

        default:
            self = .timeline
        }
    }

    func stringValue() -> String {
        switch self {
        case .timeline :
            return "timeline"
        case .test:
            return "test"
        case .photo:
            return "photo"
        case .video:
            return "video"
        case .audio:
            return "audio"
        case .openquestion:
            return "openquestion"
        case .survey:
            return "survey"
        case .duel:
            return "duel"
        case .photoMark:
            return "photomark"
        case .longread:
            return "longread"
        case .kase:
            return "kase"
        case .training:
            return "training"
        case .finish:
            return "finish"
        }
    }
}

enum FeedCardType: String, CaseIterable {
    case photo
    case audio
    case video
    case timeline
    case longread
    case test
    case `case`
    case survey
    case photomark
    case openquestion
}
