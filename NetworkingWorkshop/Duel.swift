//
//  Duel.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 06.04.2021.
//

import Foundation
struct Duel: Codable {
    let id: String?
    let isDeleted: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case isDeleted = "is_deleted"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        isDeleted = try values.decodeIfPresent(Bool.self, forKey: .isDeleted)
    }

}
