//
//  TokenManager.swift
//  Feelter
//
//  Created by 이정동 on 8/5/25.
//

import Foundation

actor TokenManager {
    private(set) var accessToken: String?
    private(set) var refreshToken: String?
    
    private let keychainStorage: KeychainStorage
    
    init(keychainStorage: KeychainStorage) {
        self.keychainStorage = keychainStorage
        self.accessToken = try? keychainStorage.load(forKey: .accessToken)
        self.refreshToken = try? keychainStorage.load(forKey: .refreshToken)
    }
    
    func updateToken(access: String? = nil, refresh: String? = nil) {
        if let access {
            accessToken = access
            try? keychainStorage.save(access, forKey: .accessToken)
        }
        
        if let refresh {
            refreshToken = refresh
            try? keychainStorage.save(refresh, forKey: .refreshToken)
        }
    }
    
    func clearToken() {
        accessToken = nil
        refreshToken = nil
        try? keychainStorage.delete(forKey: .accessToken)
        try? keychainStorage.delete(forKey: .refreshToken)
    }
}
