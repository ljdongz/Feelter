//
//  DetailOrder.swift
//  Feelter
//
//  Created by 이정동 on 8/21/25.
//

import Foundation

struct DetailOrder {
    let orderID: String
    let orderCode: String
    let filter: DetailOrderFilter
    let paidAt: String
    let createdAt: String
    let updatedAt: String
}

struct DetailOrderFilter {
    let filterID: String
    let category: String
    let title: String
    let description: String
    let files: [String]
    let price: Int
}
