//
//  TokenManager.swift
//  Feelter
//
//  Created by 이정동 on 8/5/25.
//

import Foundation

// MARK: - TokenManaging Protocol
public protocol TokenManager {
    var accessToken: String? { get }
    var refreshToken: String? { get }
    var deviceToken: String? { get }
    var userID: String? { get }

    func updateAuthToken(accessToken: String, refreshToken: String)
    func updateUserID(_ userID: String)
    func updateDeviceToken(_ deviceToken: String)
    func clearToken()
}

