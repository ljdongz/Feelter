//
//  MockAppConfiguration.swift
//  FTNetworkTests
//
//  Created by 이정동 on 10/10/25.
//

import Foundation

import FTUtility

struct DummyAppConfiguration: EnvironmentProviding {
    var apiKey: String = "apikey"
    var kakaoApiKey: String = "kakaoapi"
    var iamportUserCode: String = "iamport"
    var baseURL: String = "baseurl"
}
