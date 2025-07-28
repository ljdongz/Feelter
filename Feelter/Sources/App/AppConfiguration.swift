//
//  AppConfiguration.swift
//  Feelter
//
//  Created by 이정동 on 7/28/25.
//

import Foundation

struct AppConfiguration {
    enum AppURL: String {
        case baseURL = "BaseUrl"
    }
    
    enum AppKey: String {
        case apiHeaderKey = "ApiHeaderKey"
    }
    
    static func key(_ key: Self.AppKey) -> String {
        return Self.value(forKey: key.rawValue)
    }
    
    static func url(_ url: Self.AppURL) -> String {
        return Self.value(forKey: url.rawValue)
    }
    
    private static func value(forKey: String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: forKey) as? String else {
            fatalError("\(forKey) not set")
        }
        return value
    }
}
