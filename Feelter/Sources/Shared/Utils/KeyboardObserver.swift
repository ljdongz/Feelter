//
//  KeyboardAdjustmentHelper.swift
//  Feelter
//
//  Created by Claude on 8/2/25.
//

import UIKit

final class KeyboardObserver {
    
    struct CustomSpacing {
        let view: UIView
        let spacing: CGFloat
        
        init(view: UIView, spacing: CGFloat) {
            self.view = view
            self.spacing = spacing
        }
    }
    
    struct Configuration {
        let defaultSpacing: CGFloat
        let customSpacings: [CustomSpacing]
        
        static let `default` = Configuration(defaultSpacing: 0)
        
        init(defaultSpacing: CGFloat, customSpacings: [CustomSpacing] = []) {
            self.defaultSpacing = defaultSpacing
            self.customSpacings = customSpacings
        }
        
        func spacingFor(view: UIView) -> CGFloat {
            return customSpacings.first { $0.view === view }?.spacing ?? defaultSpacing
        }
    }
    
    private weak var viewController: UIViewController?
    private let configuration: Configuration
    
    init(viewController: UIViewController, configuration: Configuration) {
        self.viewController = viewController
        self.configuration = configuration
        setupKeyboardObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

private extension KeyboardObserver {
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let viewController = viewController,
              let keyboardFrame = notification.keyboardFrameEndUserInfoKey,
              let duration = notification.keyboardAnimationDurationUserInfoKey else {
            return
        }
        
        // 현재 포커스된 입력 뷰 자동 감지 (UITextField 또는 UITextView)
        guard let activeInputView = findActiveInputView(in: viewController.view) else {
            return
        }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        
        // 활성 입력 뷰의 화면상 위치 계산
        let inputViewFrame = activeInputView.convert(activeInputView.bounds, to: nil)
        let inputViewBottom = inputViewFrame.maxY
        
        // 키보드 상단 위치
        let keyboardTop = viewController.view.frame.height - keyboardHeight
        
        // 해당 뷰에 맞는 간격 가져오기
        let minimumSpacing = configuration.spacingFor(view: activeInputView)
        
        // 필요한 이동 거리 계산
        let requiredSpace = inputViewBottom + minimumSpacing
        let availableSpace = keyboardTop
        
        if requiredSpace > availableSpace {
            let moveDistance = requiredSpace - availableSpace
            animateViewTransform(yOffset: -moveDistance, duration: duration)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        guard let duration = notification.keyboardAnimationDurationUserInfoKey else {
            return
        }
        
        animateViewTransform(yOffset: 0, duration: duration)
    }
    
    func findActiveInputView(in view: UIView) -> UIView? {
        if let textField = view as? UITextField, textField.isFirstResponder {
            return textField
        }
        
        if let textView = view as? UITextView, textView.isFirstResponder {
            return textView
        }
        
        for subview in view.subviews {
            if let activeView = findActiveInputView(in: subview) {
                return activeView
            }
        }
        
        return nil
    }
    
    func animateViewTransform(yOffset: CGFloat, duration: TimeInterval) {
        guard let viewController = viewController else { return }
        
        UIView.animate(withDuration: duration) {
            viewController.view.transform = CGAffineTransform(translationX: 0, y: yOffset)
        }
    }
}
