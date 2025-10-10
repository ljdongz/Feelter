//
//  AppConfiguration.swift
//  Feelter
//
//  Created by 이정동 on 7/28/25.
//

import Foundation

import FTUtility

struct AppConfiguration: EnvironmentProviding {
    
    var apiKey: String { value(forKey: "ApiHeaderKey") }
    var baseURL: String { value(forKey: "BaseUrl") }
    var kakaoApiKey: String { value(forKey: "KakaoApiKey") }
    var iamportUserCode: String { value(forKey: "IamportUserCode") }
    
    private func value(forKey: String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: forKey) as? String else {
            fatalError("\(forKey) not set")
        }
        return value
    }
}
