//
//  FileData.swift
//  Feelter
//
//  Created by 이정동 on 9/6/25.
//

import Foundation
import UIKit
import UniformTypeIdentifiers

public struct FileData {
    public let data: Data
    public let `extension`: FileExtension
    
    public init(data: Data, `extension`: FileExtension) {
        self.data = data
        self.extension = `extension`
    }
}

public struct ImageData {
    public let image: UIImage
    public let `extension`: FileExtension
    
    public init(image: UIImage, `extension`: FileExtension) {
        self.image = image
        self.extension = `extension`
    }
}

public enum FileExtension: CaseIterable {
    case jpg
    case jpeg
    case png
    case gif
    case pdf
    
    public var `extension`: String {
        switch self {
        case .jpg, .jpeg: UTType.jpeg.identifier
        case .png: UTType.png.identifier
        case .gif: UTType.gif.identifier
        case .pdf: UTType.pdf.identifier
        }
    }
    
    public var mimeType: String {
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
