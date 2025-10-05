//
//  OrderRepositoryImpl.swift
//  Feelter
//
//  Created by 이정동 on 8/21/25.
//

import Foundation

struct OrderRepositoryImpl: OrderRepository {
    
    private let networkProvider: NetworkProvider
    
    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }
    
    func createOrder(_ order: CreateOrder) async throws -> String {
        let request = CreateOrderRequestDTO(
            filterID: order.filterID,
            totalPrice: order.price
        )
        
        let response = try await networkProvider.request(
            endpoint: OrderAPI.create(request),
            type: CreateOrderResponseDTO.self
        )
        
        return response.orderCode
    }
    
    func fetchOrders() async throws -> [DetailOrder] {
        let response = try await networkProvider.request(
            endpoint: OrderAPI.inquiry,
            type: OrderDetailListResponseDTO.self
        )
        
        return response.orders.map { $0.toDomain() }
    }
}
