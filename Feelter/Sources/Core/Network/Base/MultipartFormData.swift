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

struct UploadFileData {
    let data: Data
    let `extension`: FileExtensionType
}

enum FileExtensionType: String {
    case png = "png"
    case jpg = "jpg"
    case jpeg = "jpeg"
    case gif = "gif"
    case pdf = "pdf"
    
    var mimeType: String {
        switch self {
        case .png:
            "image/png"
        case .jpg, .jpeg:
            "image/jpg"
        case .gif:
            "image/gif"
        case .pdf:
            "application/pdf"
        }
    }
}
