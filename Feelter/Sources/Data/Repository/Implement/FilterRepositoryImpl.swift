//
//  FilterRepositoryImpl.swift
//  Feelter
//
//  Created by 이정동 on 8/6/25.
//

import Foundation

struct FilterRepositoryImpl: FilterRepository {
    private let networkProvider: NetworkProvider
    
    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }
    
    func fetchHotTrendFilters() async throws -> [Filter] {
        let response = try await networkProvider.request(
            endpoint: FilterAPI.hotTrend,
            type: HotTrendFilterResponseDTO.self
        )
        
        return response.data.map { $0.toDomain() }
    }
    
    func fetchTodayFilter() async throws -> Filter {
        let response = try await networkProvider.request(
            endpoint: FilterAPI.todayFilter,
            type: TodayFilterResponseDTO.self
        )
        
        return response.toDomain()
    }
}
