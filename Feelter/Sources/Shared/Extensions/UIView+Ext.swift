//
//  UIView+Ext.swift
//  Feelter
//
//  Created by 이정동 on 8/5/25.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
}
