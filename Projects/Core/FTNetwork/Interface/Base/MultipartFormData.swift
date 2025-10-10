//
//  MultipartFormData.swift
//  Feelter
//
//  Created by 이정동 on 8/28/25.
//

import Foundation

public struct MultipartFormData {
    public let data: Data
    public let name: String
    public let fileName: String?
    public let mimeType: String?
    
    public init(
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

public struct UploadFileData {
    public let data: Data
    public let `extension`: String
    public let mimeType: String
    
    public init(
        data: Data,
        `extension`: String,
        mimeType: String
    ) {
        self.data = data
        self.extension = `extension`
        self.mimeType = mimeType
    }
}
