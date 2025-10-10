//
//  EnvironmentProviding.swift
//  FTUtility
//
//  Created by 이정동 on 10/9/25.
//

import Foundation

public protocol EnvironmentProviding {
    var apiKey: String { get }
    var baseURL: String { get }
    var kakaoApiKey: String { get }
    var iamportUserCode: String { get }
}
