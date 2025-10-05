//
//  BannerResponseDTO.swift
//  Feelter
//
//  Created by 이정동 on 8/6/25.
//

import Foundation

struct BannerListResponseDTO: Decodable {
    let banners: [BannerResponseDTO]
    
    enum CodingKeys: String, CodingKey {
        case banners = "data"
    }
}

struct BannerResponseDTO: Decodable {
    let name: String
    let imageURL: String
    let payload: BannerPayloadResponseDTO
    
    enum CodingKeys: String, CodingKey {
        case name
        case imageURL = "imageUrl"
        case payload
    }
    
    func toDomain() -> Banner {
        return .init(
            name: name,
            imageURL: imageURL,
            payload: payload.toDomain()
        )
    }
}

struct BannerPayloadResponseDTO: Decodable {
    let type: String
    let value: String
    
    func toDomain() -> BannerPayload {
        return .init(type: type, value: value)
    }
}
