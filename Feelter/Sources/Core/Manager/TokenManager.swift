//
//  TokenManager.swift
//  Feelter
//
//  Created by 이정동 on 8/5/25.
//

import Foundation

// MARK: - Actor 다시 고민해보기
final class TokenManager {
    private(set) var accessToken: String?
    private(set) var refreshToken: String?
    
    private(set) var userID: String?
    
    private let keychainStorage: KeychainStorage
    private let userDefaults: UserDefaults
    
    init(
        keychainStorage: KeychainStorage,
        userDefaults: UserDefaults = .standard
    ) {
        self.keychainStorage = keychainStorage
        self.userDefaults = userDefaults
        
        self.accessToken = try? keychainStorage.load(forKey: .accessToken)
        self.refreshToken = try? keychainStorage.load(forKey: .refreshToken)
        self.userID = userDefaults.string(forKey: "userID")
        
        print("Access Token: \(accessToken ?? "-")")
        print("Refresh Token: \(refreshToken ?? "-")")
    }
    
    func updateToken(
        access: String? = nil,
        refresh: String? = nil,
        userID: String? = nil
    ) {
        if let access {
            accessToken = access
            try? keychainStorage.save(access, forKey: .accessToken)
            print("Access Token Updated: \(access)")
        }
        
        if let refresh {
            refreshToken = refresh
            try? keychainStorage.save(refresh, forKey: .refreshToken)
            print("Refresh Token Updated: \(refresh)")
        }
        
        if let userID {
            self.userID = userID
            userDefaults.set(userID, forKey: "userID")
            print("UserID Updated: \(userID)")
        }
    }
    
    func clearToken() {
        accessToken = nil
        refreshToken = nil
        userID = nil
        try? keychainStorage.delete(forKey: .accessToken)
        try? keychainStorage.delete(forKey: .refreshToken)
        userDefaults.removeObject(forKey: "userID")
    }
}
