//
//  NotificationName+Ext.swift
//  Feelter
//
//  Created by 이정동 on 8/19/25.
//

import UIKit

extension Notification.Name {
    static let KeyboardWillShow = UIResponder.keyboardWillShowNotification
    static let KeyboardWillHide = UIResponder.keyboardWillHideNotification
    static let ReceiveRemotePush = Notification.Name("ReceiveRemotePush")
}
