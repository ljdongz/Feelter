//
//  BannerRepositoryImpl.swift
//  Feelter
//
//  Created by 이정동 on 8/6/25.
//

import Foundation

struct BannerRepositoryImpl: BannerRepository {
    
    private let networkProvider: NetworkProvider
    
    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }
    
    func fetchBanners() async throws -> [Banner] {
        let response = try await networkProvider.request(
            endpoint: BannerAPI.banners,
            type: BannerListResponseDTO.self
        )
        
        return response.banners.map { $0.toDomain() }
    }
}
