//
//  UIImage+Ext.swift
//  Feelter
//
//  Created by 이정동 on 8/25/25.
//

import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    // 비율 유지하면서 리사이즈 (옵션)
    func resized(toWidth width: CGFloat) -> UIImage? {
        let scale = width / self.size.width
        let height = self.size.height * scale
        return resized(to: CGSize(width: width, height: height))
    }
    
    func resized(toHeight height: CGFloat) -> UIImage? {
        let scale = height / self.size.height
        let width = self.size.width * scale
        return resized(to: CGSize(width: width, height: height))
    }
}
