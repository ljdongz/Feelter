//
//  OrderRepository.swift
//  Feelter
//
//  Created by 이정동 on 8/21/25.
//

import Foundation

protocol OrderRepository {
    func createOrder(_ order: CreateOrder) async throws -> String
    func fetchOrders() async throws -> [DetailOrder]
}
