//
//  Reactive+Ext.swift
//  Feelter
//
//  Created by 이정동 on 7/28/25.
//

import UIKit

import RxCocoa
import RxSwift

extension Reactive where Base: UIViewController {
    var viewWillAppear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear(_:))).map { _ in }
        return ControlEvent(events: source)
    }
    
    var viewWillDisappear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillDisappear(_:))).map { _ in }
        return ControlEvent(events: source)
    }
}

extension Reactive where Base: UIView {
    var tap: ControlEvent<Void> {
        let tapGesture = UITapGestureRecognizer()
        base.addGestureRecognizer(tapGesture)
        base.isUserInteractionEnabled = true
        
        return ControlEvent(events: tapGesture.rx.event.map { _ in })
    }
}
