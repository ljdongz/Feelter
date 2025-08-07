//
//  BaseViewController.swift
//  Feelter
//
//  Created by 이정동 on 7/28/25.
//

import UIKit

enum RightBarButtonType {
    case none
    case text(String, Selector)
    case image(UIImage, Selector)
    case custom(UIBarButtonItem)
}

class BaseViewController: UIViewController {
    
    private var keyboardHelper: KeyboardObserver?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupView()
        setupSubviews()
        setupConstraints()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBarStyle()
        setupNavigationBarBackButton()
        setupKeyboardAdjustmentIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        keyboardHelper = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    deinit {
        keyboardHelper = nil
    }
    
    func setupView() {}
    func setupSubviews() {}
    func setupConstraints() {}
    func setupActions() {}
    
    
    func setupKeyboardObserver() -> KeyboardObserver.Configuration? {
        return nil
    }
    
    func setupNavigationBarRightButton(type: RightBarButtonType) {
        guard navigationController != nil else { return }
        
        switch type {
        case .none:
            navigationItem.rightBarButtonItem = nil
        case .text(let title, let action):
            let button = UIButton(type: .custom)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.gray15, for: .normal)
            button.titleLabel?.font = .pretendard(size: 16, weight: .medium)
            button.addTarget(self, action: action, for: .touchUpInside)
            button.sizeToFit()
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        case .image(let image, let action):
            let button = UIButton(type: .custom)
            button.setImage(image, for: .normal)
            button.tintColor = .gray15
            button.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            button.addTarget(self, action: action, for: .touchUpInside)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        case .custom(let barButtonItem):
            navigationItem.rightBarButtonItem = barButtonItem
        }
    }
}

// MARK: - Private
private extension BaseViewController {
    func setupNavigationBarStyle() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.gray15,
            .font: UIFont.hakgyoansimMulgyeol(size: 20, weight: .bold)
        ]
        
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithDefaultBackground()
        standardAppearance.backgroundColor = UIColor.gray100.withAlphaComponent(0.9)
        standardAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.gray15,
            .font: UIFont.hakgyoansimMulgyeol(size: 20, weight: .bold)
        ]
        
        navigationController?.navigationBar.standardAppearance = standardAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
//        navigationController?.navigationBar.compactAppearance = appearance
    }
    
    func setupNavigationBarBackButton() {
        guard navigationController != nil else { return }
        
        navigationItem.hidesBackButton = true
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(.chevron, for: .normal)
        backButton.tintColor = .gray15
        backButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    func setupKeyboardAdjustmentIfNeeded() {
        guard let configuration = setupKeyboardObserver() else { return }
        
        keyboardHelper = KeyboardObserver(
            viewController: self,
            configuration: configuration
        )
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
