//
//  InquiryPaymentResult.swift
//  Feelter
//
//  Created by 이정동 on 8/21/25.
//

import Foundation

struct InquiryPaymentResult {
    let impUid: String
    let merchantUid: String
    let payMethod: String?
    let channel: String?
    let pgProvider: String?
    let embPGProvider: String?
    let pgTid: String?
    let pgID: String?
    let escrow: Bool?
    let applyNum: String?
    let bankCode: String?
    let bankName: String?
    let cardCode: String?
    let cardName: String?
    let cardIssuerCode: String?
    let cardIssuerName: String?
    let cardPublisherCode: String?
    let cardPublisherName: String?
    let cardQuota: Int?
    let cardNumber: String?
    let cardType: Int?
    let vbankCode: String?
    let vbankName: String?
    let vbankNum: String?
    let vbankHolder: String?
    let vbankDate: Int?
    let vbankIssuedAt: Int?
    let name: String?
    let amount: Int
    let currency: String
    let buyerName: String?
    let buyerEmail: String?
    let buyerTel: String?
    let buyerAddr: String?
    let buyerPostcode: String?
    let customData: String?
    let userAgent: String?
    let status: String
    let startedAt: String?
    let paidAt: String?
    let receiptURL: String?
    let createdAt: String?
    let updatedAt: String?
}
