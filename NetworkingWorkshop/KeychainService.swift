//
//  KeychainService.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 31.03.2021.
//

import Foundation

final class KeychainService {
    enum Keys: String {
        case deviceId
        case token
        case refreshToken
    }
    
    static let shared = KeychainService()
    private init() { }
    
    func save(string: String, with key: Keys) {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: string.data(using: .utf8) ?? Data()
        ] as [String: Any]

        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    func load(with key: Keys) -> String {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ] as [String: Any]

        var dataTypeRef: AnyObject? = nil

        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        return status == noErr
            ? String(data: dataTypeRef as! Data, encoding: .utf8) ?? ""
            : ""
    }
    
    func deleteItem(for key: Keys) {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key.rawValue
        ] as [String: Any]

        SecItemDelete(query as CFDictionary)
    }
}

