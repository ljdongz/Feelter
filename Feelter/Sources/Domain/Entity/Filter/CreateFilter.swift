//
//  CreateFilter.swift
//  Feelter
//
//  Created by 이정동 on 8/28/25.
//

import Foundation

struct CreateFilter {
    var title: String = ""
    var category: String = FilterCategory.food.rawValue
    var description: String = ""
    var price: Int = -1
    var imageComparison: ImageComparison?
    var fileURLs: [String] = []
    var filterAttribute: FilterAttribute = .zero
}
