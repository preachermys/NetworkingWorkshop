//
//  TeamsModel.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 31.03.2021.
//

import Foundation

public struct TeamsModel: Codable {
    
    let name: String?
    let logo: String?
    let domain: String?
    let namespace: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case logo
        case domain
        case namespace
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        logo = try values.decodeIfPresent(String.self, forKey: .logo)
        domain = try values.decodeIfPresent(String.self, forKey: .domain)
        namespace = try values.decodeIfPresent(String.self, forKey: .namespace)
    }
    
    public init(name: String?, logo: String?, domain: String?, namespace: String?) {
        self.name = name
        self.logo = logo
        self.domain = domain
        self.namespace = namespace
    }
}
