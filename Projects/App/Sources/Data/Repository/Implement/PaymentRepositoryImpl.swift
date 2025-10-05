//
//  PaymentRepositoryImpl.swift
//  Feelter
//
//  Created by 이정동 on 8/21/25.
//

import Foundation

struct PaymentRepositoryImpl: PaymentRepository {
    
    private let networkProvider: NetworkProvider
    
    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }
    
    func validatePayment(impID: String) async throws -> ValidationPaymentResult {
        let request = ValidationPaymentRequestDTO(impUID: impID)
        
        let response = try await networkProvider.request(
            endpoint: PaymentAPI.validation(request),
            type: ValidationPaymentResponseDTO.self
        )
        
        return response.toDomain()
    }
    
    func inquiryPayment(orderCode: String) async throws -> InquiryPaymentResult {
        let response = try await networkProvider.request(
            endpoint: PaymentAPI.inquiry(orderCode: orderCode),
            type: InquiryPaymentResponseDTO.self
        )
        
        return response.toDomain()
    }
}
