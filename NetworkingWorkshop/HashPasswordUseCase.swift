//
//  HashPasswordUseCase.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 31.03.2021.
//

import CryptoSwift

protocol HashPasswordUseCase {
    func hash(password: String) -> (String, Bool)
}

class HashPasswordUseCaseImplementation: HashPasswordUseCase {
    func hash(password: String) -> (String, Bool) {
        guard let path = Bundle.main.path(forResource: GlobalConstants.Cipher.plistName,
                                          ofType: GlobalConstants.Cipher.plistFormat),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            let plist = try? PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil),
            let dataFromPlist = plist as? [String: String],
            let key = dataFromPlist[GlobalConstants.Cipher.key],
            let initVector = dataFromPlist[GlobalConstants.Cipher.initVector] else { return (password, false) }
        
        do {
            let encrypted = try AES(key: key.bytes,
                                    blockMode: CBC(iv: initVector.bytes),
                                    padding: .pkcs5).encrypt(password.bytes)
            let decrypted = try AES(key: key.bytes,
                                    blockMode: CBC(iv: initVector.bytes),
                                    padding: .pkcs5).decrypt(encrypted)
               
            if password.bytes == decrypted, let encryptedPassword = encrypted.toBase64() {
                return (encryptedPassword, true)
            } else {
                 return (password, false)
            }
        } catch {
            return (password, false)
        }
    }
}
