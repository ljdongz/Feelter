//
//  OrderDetailResponseDTO.swift
//  Feelter
//
//  Created by 이정동 on 8/21/25.
//

import Foundation

import FTUtility

struct OrderDetailListResponseDTO: Decodable {
    let orders: [OrderDetailResponseDTO]
    
    enum CodingKeys: String, CodingKey {
        case orders = "data"
    }
}

struct OrderDetailResponseDTO: Decodable {
    let orderID: String
    let orderCode: String
    let filter: OrderDetailFilterDTO
    let paidAt: String
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case orderCode = "order_code"
        case filter
        case paidAt
        case createdAt
        case updatedAt
    }
    
    func toDomain() -> DetailOrder {
        .init(
            orderID: orderID,
            orderCode: orderCode,
            filter: filter.toDomain(),
            paidAt: paidAt,
            createdAt: UTCDateFormatter.shared.date(from: createdAt) ?? .distantPast,
            updatedAt: UTCDateFormatter.shared.date(from: updatedAt) ?? .distantPast
        )
    }
}

struct OrderDetailFilterDTO: Decodable {
    let filterID: String
    let category: String
    let title: String
    let description: String
    let files: [String]
    let price: Int
    
    enum CodingKeys: String, CodingKey {
        case filterID = "id"
        case category
        case title
        case description
        case files
        case price
    }
    
    func toDomain() -> DetailOrderFilter {
        .init(
            filterID: filterID,
            category: category,
            title: title,
            description: description,
            files: files,
            price: price
        )
    }
}
