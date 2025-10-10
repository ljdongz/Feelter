//
//  ValidationPaymentsResponseDTO.swift
//  Feelter
//
//  Created by 이정동 on 8/21/25.
//

import Foundation

import FTUtility

struct ValidationPaymentResponseDTO: Decodable {
    let paymentID: String
    let orderItem: ValidationPaymentOrderResponseDTO
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case paymentID = "payment_id"
        case orderItem = "order_item"
        case createdAt
        case updatedAt
    }
    
    func toDomain() -> ValidationPaymentResult {
        .init(
            paymentID: paymentID,
            orderItem: orderItem.toDomain(),
            createdAt: UTCDateFormatter.shared.date(from: createdAt) ?? .distantPast,
            updatedAt: UTCDateFormatter.shared.date(from: updatedAt) ?? .distantPast
        )
    }
}

struct ValidationPaymentOrderResponseDTO: Decodable {
    let orderID: String
    let orderCode: String
    
    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case orderCode = "order_code"
    }
    
    func toDomain() -> ValidationPaymentOrder {
        .init(orderID: orderID, orderCode: orderCode)
    }
}
