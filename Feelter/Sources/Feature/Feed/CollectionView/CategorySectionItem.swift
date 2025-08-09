//
//  CategorySectionItem.swift
//  Feelter
//
//  Created by 이정동 on 8/8/25.
//

import Foundation

struct CategorySectionItem: Hashable {
    let id = UUID()
    let category: FilterCategory
    let isSelected: Bool
    
    init(category: FilterCategory, isSelected: Bool = false) {
        self.category = category
        self.isSelected = isSelected
    }
    
    static let `default`: [Self] = [
        .init(category: .food),
        .init(category: .character),
        .init(category: .scenery),
        .init(category: .night),
        .init(category: .star)
    ]
}
