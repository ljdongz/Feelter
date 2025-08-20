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
    
    private(set) var deviceToken: String?
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
        self.deviceToken = userDefaults.string(forKey: "deviceToken")
        
        print("Access Token: \(accessToken ?? "-")")
        print("Refresh Token: \(refreshToken ?? "-")")
        print("Device Token: \(deviceToken ?? "-")")
    }
    
    func updateAuthToken(accessToken: String, refreshToken: String) {
        try? keychainStorage.save(accessToken, forKey: .accessToken)
        try? keychainStorage.save(refreshToken, forKey: .refreshToken)
        
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        
        print("Access Token Updated: \(accessToken)")
        print("Refresh Token Updated: \(refreshToken)")
    }
    
    func updateUserID(_ userID: String) {
        userDefaults.set(userID, forKey: "userID")
        self.userID = userID
        print("UserID Updated: \(userID)")
    }
    
    func updateDeviceToken(_ deviceToken: String) {
        userDefaults.set(deviceToken, forKey: "deviceToken")
        self.deviceToken = deviceToken
        print("Device Token Updated: \(deviceToken)")
    }
    
    func clearToken() {
        accessToken = nil
        refreshToken = nil
        userID = nil
        deviceToken = nil
        
        try? keychainStorage.delete(forKey: .accessToken)
        try? keychainStorage.delete(forKey: .refreshToken)
        userDefaults.removeObject(forKey: "userID")
        userDefaults.removeObject(forKey: "deviceToken")
    }
}
