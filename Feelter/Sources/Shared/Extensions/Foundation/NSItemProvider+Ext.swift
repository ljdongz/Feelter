//
//  NSItemProvider+Ext.swift
//  Feelter
//
//  Created by 이정동 on 9/2/25.
//

import Foundation
import UIKit

extension NSItemProvider {
    
    func loadUIImage() async throws -> UIImage? {
        guard canLoadObject(ofClass: UIImage.self) else { return nil }
        
        return try await withCheckedThrowingContinuation { continuation in
            loadObject(ofClass: UIImage.self) { object, error in
                if let error = error { continuation.resume(throwing: error) }
                else { continuation.resume(returning: object as? UIImage) }
            }
        }
    }
}
