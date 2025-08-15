//
//  Notification+Ext.swift
//  Feelter
//
//  Created by 이정동 on 8/15/25.
//

import UIKit

extension Notification {
    var keyboardAnimationDurationUserInfoKey: Double? {
        self.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
    }
    
    var keyboardFrameEndUserInfoKey: NSValue? {
        self.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
    }
}
