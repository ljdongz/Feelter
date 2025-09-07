//
//  FileData.swift
//  Feelter
//
//  Created by 이정동 on 9/6/25.
//

import Foundation
import UIKit
import UniformTypeIdentifiers

struct FileData {
    let data: Data
    let `extension`: FileExtension
}

struct ImageData {
    let image: UIImage
    let `extension`: FileExtension
}

enum FileExtension: CaseIterable {
    case jpg
    case jpeg
    case png
    case gif
    case pdf
    
    var `extension`: String {
        switch self {
        case .jpg, .jpeg: UTType.jpeg.identifier
        case .png: UTType.png.identifier
        case .gif: UTType.gif.identifier
        case .pdf: UTType.pdf.identifier
        }
    }
    
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
