//
//  KeychainStorage.swift
//  Feelter
//
//  Created by 이정동 on 8/4/25.
//

import Foundation
import Security

enum KeychainError: Error {
    case encodingFailed
    case decodingFailed
    case unexpectedStatus(OSStatus)
}

enum KeychainKey: String {
    case accessToken = "feelter-accessToken"
    case refreshToken = "feelter-refreshToken"
}

protocol KeychainStorage {
    func save<T: Codable>(_ value: T, forKey key: KeychainKey) throws
    func load<T: Codable>(forKey key: KeychainKey) throws -> T?
    func delete(forKey key: KeychainKey) throws
}
