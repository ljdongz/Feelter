//
//  APNs.swift
//  Feelter
//
//  Created by 이정동 on 8/19/25.
//

import Foundation

struct APNsPayload: Decodable {
    let aps: APS
    let roomID: String?
    
    enum CodingKeys: String, CodingKey {
        case aps
        case roomID = "room_id"
    }
}

struct APS: Decodable {
    let alert: APNsAlert
}

struct APNsAlert: Decodable {
    let title: String?
    let subtitle: String?
    let body: String?
}
