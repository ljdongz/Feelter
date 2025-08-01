//
//  AppConfiguration.swift
//  Feelter
//
//  Created by 이정동 on 7/28/25.
//

import Foundation

enum AppConfiguration {
    
    static let apiKey = Self.value(forKey: "ApiHeaderKey")
    static let baseURL = Self.value(forKey: "BaseUrl")
    static let kakaoApiKey = Self.value(forKey: "KakaoApiKey")
    
    private static func value(forKey: String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: forKey) as? String else {
            fatalError("\(forKey) not set")
        }
        return value
    }
}
