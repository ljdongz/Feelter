//
//  UINavigationController+Ext.swift
//  Feelter
//
//  Created by 이정동 on 7/28/25.
//

import SwiftUI

extension UINavigationController: @retroactive ObservableObject, @retroactive UIGestureRecognizerDelegate {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
