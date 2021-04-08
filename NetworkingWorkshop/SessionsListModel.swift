//
//  SessionsListModel.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 31.03.2021.
//

import Foundation

struct SessionsListModel: Codable {
    let data: [DeviceInfo]
}

public struct DeviceInfo: Codable {
    let sessionId: String?
    let description: SessionDescription
    let time: String?
    
    enum CodingKeys: String, CodingKey {
        case sessionId = "id"
        case description
        case time = "created_at"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sessionId = try values.decodeIfPresent(String.self, forKey: .sessionId)
        description = try values.decode(SessionDescription.self, forKey: .description)
        time = try values.decodeIfPresent(String.self, forKey: .time)
    }
}

public struct SessionDescription: Codable {
    let name: String?
    let operationSystem: String?
    let ipAdress: String?
    let country: String?
    let city: String?
    let type: String?
    let appVersion: String?
    let browser: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case operationSystem = "os"
        case ipAdress = "ip"
        case country
        case city
        case type
        case appVersion = "app_version"
        case browser
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        operationSystem = try values.decodeIfPresent(String.self, forKey: .operationSystem)
        ipAdress = try values.decodeIfPresent(String.self, forKey: .ipAdress)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        appVersion = try values.decodeIfPresent(String.self, forKey: .appVersion)
        browser = try values.decodeIfPresent(String.self, forKey: .browser)
    }

}
