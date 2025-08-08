//
//  UICollectionViewCell+Ext.swift
//  Feelter
//
//  Created by 이정동 on 8/8/25.
//

import UIKit

extension UICollectionViewCell {
    func animateTouchDown() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }

    func animateTouchUp() {
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
        }
    }
}
