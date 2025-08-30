//
//  MultipartFormData.swift
//  Feelter
//
//  Created by 이정동 on 8/28/25.
//

import Foundation

struct MultipartFormData {
    let data: Data
    let name: String
    let fileName: String?
    let mimeType: String?
    
    init(
        data: Data,
        name: String,
        fileName: String? = nil,
        mimeType: String? = nil
    ) {
        self.data = data
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
    }
}
