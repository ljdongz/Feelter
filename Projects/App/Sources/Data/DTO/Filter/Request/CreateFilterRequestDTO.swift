//
//  CreateFilterRequestDTO.swift
//  Feelter
//
//  Created by 이정동 on 8/29/25.
//

import Foundation

struct CreateFilterRequestDTO: Encodable {
    let title: String
    let category: String
    let price: Int
    let description: String
    let files: [String]
    let photoMetadata: PhotoMetadataDTO?
    let filterAttributes: FilterAttributeDTO
    
    enum CodingKeys: String, CodingKey {
        case title
        case category
        case price
        case description
        case files
        case photoMetadata = "photo_metadata"
        case filterAttributes = "filter_values"
    }
    
    static func create(from filter: CreateFilter) -> Self {
        CreateFilterRequestDTO(
            title: filter.title,
            category: filter.category,
            price: filter.price,
            description: filter.description,
            files: filter.fileURLs,
            photoMetadata: nil,
            filterAttributes: .init(
                brightness: filter.filterAttribute.brightness,
                exposure: filter.filterAttribute.exposure,
                contrast: filter.filterAttribute.contrast,
                saturation: filter.filterAttribute.saturation,
                sharpness: filter.filterAttribute.sharpness,
                blur: filter.filterAttribute.blur,
                vignette: filter.filterAttribute.vignette,
                noiseReduction: filter.filterAttribute.noiseReduction,
                highlights: filter.filterAttribute.highlights,
                shadows: filter.filterAttribute.shadows,
                temperature: filter.filterAttribute.temperature,
                blackPoint: filter.filterAttribute.blackPoint
            )
        )
    }
}
