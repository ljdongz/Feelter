//
//  ToastManager.swift
//  Feelter
//
//  Created by 이정동 on 8/2/25.
//

import UIKit

final class ToastManager {
    static let shared = ToastManager()
    
    private var activeToasts: [ToastView] = []
    private let maxToasts = 1
    
    private init() {}
    
    func show(
        message: String,
        type: ToastType = .info,
        position: ToastPosition = .top,
        duration: TimeInterval = 3.0,
        in viewController: UIViewController
    ) {
        let configuration = ToastConfiguration(
            type: type,
            position: position,
            duration: duration,
            animationDuration: 0.3,
            cornerRadius: 12,
            horizontalMargin: 20,
            verticalMargin: position == .top ? 20 : 100,
            maxWidth: nil,
            hapticFeedback: true
        )
        
        show(message: message, configuration: configuration, in: viewController)
    }
    
    func show(
        message: String,
        configuration: ToastConfiguration,
        in viewController: UIViewController
    ) {
        DispatchQueue.main.async {
            
            // Remove oldest toast if limit exceeded
            if self.activeToasts.count >= self.maxToasts {
                self.activeToasts.first?.dismissImediately()
                self.activeToasts.removeAll()
            }
            
            let toast = ToastView(message: message, configuration: configuration)
            
            self.activeToasts.append(toast)
            toast.show(in: viewController.view, configuration: configuration)
        }
    }
    
    func showSuccess(_ message: String, in viewController: UIViewController) {
        show(message: message, type: .success, in: viewController)
    }
    
    func showError(_ message: String, in viewController: UIViewController) {
        show(message: message, type: .error, in: viewController)
    }
    
    func showWarning(_ message: String, in viewController: UIViewController) {
        show(message: message, type: .warning, in: viewController)
    }
    
    func showInfo(_ message: String, in viewController: UIViewController) {
        show(message: message, type: .info, in: viewController)
    }
    
    func dismissAll() {
        DispatchQueue.main.async {
            self.activeToasts.forEach { $0.dismiss() }
        }
    }
    
    private func removeToast(_ toast: ToastView) {
        activeToasts.removeAll { $0 === toast }
    }
}
