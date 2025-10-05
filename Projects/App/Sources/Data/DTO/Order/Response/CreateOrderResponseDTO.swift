//
//  CreateOrderResponseDTO.swift
//  Feelter
//
//  Created by 이정동 on 8/21/25.
//

import Foundation

struct CreateOrderResponseDTO: Decodable {
    let orderID: String
    let orderCode: String
    let totalPrice: Int
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case orderCode = "order_code"
        case totalPrice = "total_price"
        case createdAt
        case updatedAt
    }
}
