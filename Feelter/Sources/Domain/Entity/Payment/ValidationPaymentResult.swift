//
//  ValidationPaymentResult.swift
//  Feelter
//
//  Created by 이정동 on 8/21/25.
//

import Foundation

struct ValidationPaymentResult {
    let paymentID: String
    let orderItem: ValidationPaymentOrder
    let createdAt: Date
    let updatedAt: Date
}

struct ValidationPaymentOrder {
    let orderID: String
    let orderCode: String
}
