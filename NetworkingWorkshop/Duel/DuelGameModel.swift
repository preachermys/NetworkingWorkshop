//
//  DuelGameModel.swift
//  NetworkingWorkshop
//
//  Created by Юлия Милованова on 05.04.2021.
//

import Foundation

struct DuelGameModel: Codable {
    let state: String?
    let duel: Duel?
//    let initiator: Initiator?
//    let winner: Players?
//    let players: [Players]?
    let expiredAt: String?
    let id: String?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {

        case state
        case duel
//        case initiator
//        case winner
//        case players
        case expiredAt = "expired_at"
        case id
        case createdAt = "created_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        duel = try values.decodeIfPresent(Duel.self, forKey: .duel)
//        initiator = try values.decodeIfPresent(Initiator.self, forKey: .initiator)
//        winner = try values.decodeIfPresent(Players.self, forKey: .winner)
//        players = try values.decodeIfPresent([Players].self, forKey: .players)
        expiredAt = try values.decodeIfPresent(String.self, forKey: .expiredAt)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
    }
}
