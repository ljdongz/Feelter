//
//  URLRequest+Dummy.swift
//  FTNetworkTests
//
//  Created by 이정동 on 10/10/25.
//

import Foundation

extension URLRequest {
    static var dummy: URLRequest {
        URLRequest(url: URL(string: "https://test.com/api")!)
    }
}
