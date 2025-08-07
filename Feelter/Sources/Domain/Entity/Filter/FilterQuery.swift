//
//  FilterQuery.swift
//  Feelter
//
//  Created by 이정동 on 8/7/25.
//

import Foundation

struct FilterQuery {
    let nextID: String?
    let limit: Int?
    let category: FilterCategory?
    let order: FilterOrder?
}

enum FilterCategory: String {
    case food = "푸드"
    case character = "인물"
    case scenery = "풍경"
    case night = "야경"
    case star = "별"
}

enum FilterOrder: String {
    case latest = "latest"
    case popularity = "popularity"
    case purchase = "purchase"
}
