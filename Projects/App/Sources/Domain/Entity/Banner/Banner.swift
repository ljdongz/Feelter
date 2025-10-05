//
//  Banner.swift
//  Feelter
//
//  Created by 이정동 on 8/6/25.
//

import Foundation

struct Banner: Hashable {
    let name: String
    let imageURL: String
    let payload: BannerPayload
}

struct BannerPayload: Hashable {
    let type: String
    let value: String
}
