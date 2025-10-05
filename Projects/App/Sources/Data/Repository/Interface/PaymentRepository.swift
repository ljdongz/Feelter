//
//  PaymentRepository.swift
//  Feelter
//
//  Created by 이정동 on 8/21/25.
//

import Foundation

protocol PaymentRepository {
    func validatePayment(impID: String) async throws -> ValidationPaymentResult
    func inquiryPayment(orderCode: String) async throws -> InquiryPaymentResult
}
