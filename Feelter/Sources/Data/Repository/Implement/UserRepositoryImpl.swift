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
    
    func fetchTodayAuthor() async throws -> Profile {
        let response = try await networkProvider.request(
            endpoint: UserAPI.todayAuthor,
            type: TodayAuthorResponseDTO.self
        )
        
        return response.author.toDomain()
    }
}
