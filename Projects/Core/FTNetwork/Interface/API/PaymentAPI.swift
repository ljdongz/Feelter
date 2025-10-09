//
//  PaymentAPI.swift
//  Feelter
//
//  Created by 이정동 on 8/21/25.
//

import Foundation

public enum PaymentAPI {
    case validation(Encodable)
    case inquiry(orderCode: String)
}
