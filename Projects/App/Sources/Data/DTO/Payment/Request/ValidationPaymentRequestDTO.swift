//
//  ValidationPaymentsRequestDTO.swift
//  Feelter
//
//  Created by 이정동 on 8/21/25.
//

import Foundation

struct ValidationPaymentRequestDTO: Encodable {
    let impUID: String
    
    enum CodingKeys: String, CodingKey {
        case impUID = "imp_uid"
    }
}
