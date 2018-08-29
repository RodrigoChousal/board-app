//
//  KeychainManager.swift
//  BoardApp
//
//  Created by Rodrigo Chousal on 8/28/18.
//  Copyright © 2018 Rodrigo Chousal. All rights reserved.
//

import Foundation

class KeychainManager {
    
    static let server = "board-app-e5e79.firebaseapp.com"
    
    enum KeychainError: Error {
        case noPassword
        case unexpectedPasswordData
        case unhandledError(status: OSStatus)
    }
    
    static func storeCredentials(credentials: Credentials) {
        
        let account = credentials.email
        let password = credentials.password.data(using: String.Encoding.utf8)!
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrAccount as String: account,
                                    kSecAttrServer as String: server,
                                    kSecValueData as String: password]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess { print("Success") } else { print(status) }
    }
    
    static func fetchCredentials() -> Credentials {
        
        var email = ""
        var pass = ""
        
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: server,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status != errSecItemNotFound { print("No Password") }
        if status == errSecSuccess { print(status) }
        
        if let existingItem = item as? [String : Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8),
            let account = existingItem[kSecAttrAccount as String] as? String {
            print("Successful retrieval of credentials")
            email = account
            pass = password
        } else {
            print("Unexpected password data")
        }
        
        let credentials = Credentials(email: email, password: pass)
        return credentials
    }
    
    static func deleteCredentials(credentials: Credentials) throws {
        let account = credentials.email
        let password = credentials.password.data(using: String.Encoding.utf8)!
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrAccount as String: account,
                                    kSecAttrServer as String: KeychainManager.server,
                                    kSecValueData as String: password]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
    }
}
