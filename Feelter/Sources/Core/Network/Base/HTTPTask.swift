//
//  HTTPTask.swift
//  Feelter
//
//  Created by 이정동 on 7/31/25.
//

import Foundation

enum HTTPTask {
    case requestPlain
    case requestQueryParameters(parameters: [String: Any])
    case requestJSONEncodable(Encodable)
}
