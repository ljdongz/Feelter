//
//  UIStackView+Ext.swift
//  Feelter
//
//  Created by 이정동 on 8/5/25.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }
}
