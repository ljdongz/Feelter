//
//  ToastView.swift
//  Feelter
//
//  Created by 이정동 on 8/2/25.
//

import UIKit

import SnapKit

// MARK: - Position
enum ToastPosition {
    case top
    case center
    case bottom
}

// MARK: - Type
enum ToastType {
    case success
    case error
    case warning
    case info
    case custom(UIColor)
    
    var backgroundColor: UIColor {
        switch self {
        case .success:
            return UIColor.systemGreen
        case .error:
            return UIColor.systemRed
        case .warning:
            return UIColor.systemOrange
        case .info:
            return UIColor.systemBlue
        case .custom(let color):
            return color
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .success:
            return UIImage(systemName: "checkmark.circle.fill")
        case .error:
            return UIImage(systemName: "xmark.circle.fill")
        case .warning:
            return UIImage(systemName: "exclamationmark.triangle.fill")
        case .info:
            return UIImage(systemName: "info.circle.fill")
        case .custom:
            return nil
        }
    }
}

// MARK: - Configuration
struct ToastConfiguration {
    let type: ToastType
    let position: ToastPosition
    let duration: TimeInterval
    let animationDuration: TimeInterval
    let cornerRadius: CGFloat
    let horizontalMargin: CGFloat
    let verticalMargin: CGFloat
    let maxWidth: CGFloat?
    let hapticFeedback: Bool
    
    static let `default` = ToastConfiguration(
        type: .info,
        position: .bottom,
        duration: 3.0,
        animationDuration: 0.3,
        cornerRadius: 12,
        horizontalMargin: 20,
        verticalMargin: 100,
        maxWidth: nil,
        hapticFeedback: true
    )
}

// MARK: - View
final class ToastView: UIView {
    
    private let iconImageView = UIImageView()
    private let messageLabel = UILabel()
    private let stackView = UIStackView()
    
    private var hideTimer: Timer?
    private var onDismiss: (() -> Void)?
    
    init(message: String, configuration: ToastConfiguration, onDismiss: (() -> Void)? = nil) {
        super.init(frame: .zero)
        
        self.onDismiss = onDismiss
        setupUI(message: message, configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        hideTimer?.invalidate()
    }
    
    private func setupUI(message: String, configuration: ToastConfiguration) {
        // Container setup
        backgroundColor = configuration.type.backgroundColor
        layer.cornerRadius = configuration.cornerRadius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.2
        
        // Icon setup
        if let icon = configuration.type.icon {
            iconImageView.image = icon
            iconImageView.tintColor = .white
            iconImageView.contentMode = .scaleAspectFit
        }
        
        // Message label setup
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .left
        
        // Stack view setup
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 12
        
        // Add subviews
        addSubview(stackView)
        
        if configuration.type.icon != nil {
            stackView.addArrangedSubview(iconImageView)
        }
        stackView.addArrangedSubview(messageLabel)
        
        // SnapKit Constraints
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview().inset(16)
        }
        
        if configuration.type.icon != nil {
            iconImageView.snp.makeConstraints { make in
                make.size.equalTo(24)
            }
        }
        
        // Tap gesture to dismiss
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
        
        // Pan gesture to dismiss
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(panGesture)
    }
    
    @objc private func handleTap() {
        dismiss()
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let velocity = gesture.velocity(in: self)
        
        switch gesture.state {
        case .changed:
            if abs(translation.y) > abs(translation.x) {
                transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
        case .ended:
            if abs(velocity.y) > 500 || abs(translation.y) > 100 {
                dismiss()
            } else {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut) {
                    self.transform = .identity
                }
            }
        default:
            break
        }
    }
}

// MARK: - Public Method

extension ToastView {
    
    func show(in view: UIView, configuration: ToastConfiguration) {
        view.addSubview(self)
        
        // SnapKit Constraints for positioning
        self.snp.makeConstraints { make in
            // Horizontal constraints
            make.leading.greaterThanOrEqualTo(view.safeAreaLayoutGuide).offset(configuration.horizontalMargin)
            make.trailing.lessThanOrEqualTo(view.safeAreaLayoutGuide).offset(-configuration.horizontalMargin)
            make.centerX.equalTo(view)
            
            // Width constraint if specified
            if let maxWidth = configuration.maxWidth {
                make.width.lessThanOrEqualTo(maxWidth)
            }
            
            // Vertical position
            switch configuration.position {
            case .top:
                make.top.equalTo(view.safeAreaLayoutGuide).offset(configuration.verticalMargin)
            case .center:
                make.centerY.equalTo(view)
            case .bottom:
                make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-configuration.verticalMargin)
            }
        }
        
        // Initial state for animation
        alpha = 0
        transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        // Animate in
        UIView.animate(withDuration: configuration.animationDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut) {
            self.alpha = 1
            self.transform = .identity
        }
        
        // Haptic feedback
        if configuration.hapticFeedback {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
        }
        
        // Auto dismiss
        if configuration.duration > 0 {
            hideTimer = Timer.scheduledTimer(withTimeInterval: configuration.duration, repeats: false) { _ in
                self.dismiss()
            }
        }
    }
    
    func dismiss() {
        hideTimer?.invalidate()
        hideTimer = nil
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut) {
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { _ in
            self.removeFromSuperview()
            self.onDismiss?()
        }
    }
    
    func dismissImediately() {
        hideTimer?.invalidate()
        hideTimer = nil
        
        alpha = 0
        transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        removeFromSuperview()
        onDismiss?()
    }
}
