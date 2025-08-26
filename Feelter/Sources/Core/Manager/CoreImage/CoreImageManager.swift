//
//  CoreImageManager.swift
//  Feelter
//
//  Created by 이정동 on 8/26/25.
//

import CoreImage
import UIKit

final class CoreImageManager {
    static let context = CIContext()
    
    func applyFilter(_ image: UIImage, filter: CoreImageFilter, value: Float) -> UIImage? {
        guard let ciImage = CIImage(image: image),
              let ciFilter = CIFilter(name: filter.name) else { return nil }
        
        ciFilter.setValue(ciImage, forKey: kCIInputImageKey)
        ciFilter.setValue(value, forKey: filter.parameter.key)
        
        return createUIImage(from: ciFilter, originalExtent: ciImage.extent)
    }
    
    private func createUIImage(from filter: CIFilter, originalExtent: CGRect) -> UIImage? {
        guard let outputImage = filter.outputImage else { return nil }
        guard let cgImage = Self.context.createCGImage(
            outputImage,
            from: originalExtent
        ) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
}

