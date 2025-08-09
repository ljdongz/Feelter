//
//  OrderSectionItem.swift
//  Feelter
//
//  Created by 이정동 on 8/9/25.
//

import Foundation

struct OrderSectionItem: Hashable {
    let id = UUID()
    let order: FilterOrder
    let isSelected: Bool
    
    init(order: FilterOrder, isSelected: Bool = false) {
        self.order = order
        self.isSelected = isSelected
    }
    
    static let `default`: [Self] = [
        .init(order: .latest, isSelected: true),
        .init(order: .purchase),
        .init(order: .popularity)
    ]
}
