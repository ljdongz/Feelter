//
//  FilterRepository.swift
//  Feelter
//
//  Created by 이정동 on 8/6/25.
//

import Foundation

protocol FilterRepository {
    func fetchHotTrendFilters() async throws -> [Filter]
    func fetchTodayFilter() async throws -> Filter
    func fetchFilters(query: FilterQuery) async throws -> FilterFeed
    func fetchDetailFilter(filterID: String) async throws -> FilterDetail
    func updateLikeStatus(filterID: String, isLiked: Bool) async throws
}
