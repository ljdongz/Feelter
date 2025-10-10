//
//  CreateOrderRequestDTO.swift
//  Feelter
//
//  Created by 이정동 on 8/21/25.
//

import Foundation

struct CreateOrderRequestDTO: Encodable {
    let filterID: String
    let totalPrice: Int
    
    enum CodingKeys: String, CodingKey {
        case filterID = "filter_id"
        case totalPrice = "total_price"
    }
}
