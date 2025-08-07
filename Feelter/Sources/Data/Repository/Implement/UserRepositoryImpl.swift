//
//  UserRepository.swift
//  Feelter
//
//  Created by 이정동 on 8/6/25.
//

import Foundation

struct UserRepositoryImpl: UserRepository {
    private let networkProvider: NetworkProvider
    
    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }
    
    func fetchTodayAuthor() async throws -> TodayAuthor {
        let response = try await networkProvider.request(
            endpoint: UserAPI.todayAuthor,
            type: TodayAuthorResponseDTO.self
        )
        
        let profile = response.author.toDomain()
        let filters = response.filters.map { $0.toDomain() }
        
        return .init(profile: profile, filters: filters)
    }
}
