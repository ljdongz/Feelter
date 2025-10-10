//
//  FilterAPI.swift
//  Feelter
//
//  Created by 이정동 on 8/6/25.
//

import Foundation

public enum FilterAPI {
    case create(Encodable)
    case hotTrend
    case todayFilter
    case queryFilters(
        next: String?,
        limit: String?,
        category: String?,
        order: String?
    )
    case detail(filterID: String)
    case like(filterID: String, body: Encodable)
    case uploadFiles(
        originalImage: Data,
        filteredImage: Data
    )
}
