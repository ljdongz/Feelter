//
//  BaseViewController.swift
//  Feelter
//
//  Created by 이정동 on 7/28/25.
//

import UIKit

class BaseViewController: UIViewController {
    
    private var keyboardObserver: KeyboardObserver?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupView()
        setupSubviews()
        setupConstraints()
        setupActions()
        setupNavigationBarStyle()
        setupNavigationBarBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupKeyboardAdjustmentIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        keyboardObserver = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    deinit {
        keyboardObserver = nil
    }
    
    func setupView() {}
    func setupSubviews() {}
    func setupConstraints() {}
    func setupActions() {}
    func setupKeyboardObserver() -> KeyboardObserver.Configuration? {
        return nil
    }
}

// MARK: - Configure NaivgationBar
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
        guard let _ = navigationController else { return }
        
        navigationItem.hidesBackButton = true
    
        guard !isRootViewController() else { return }
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(.chevron, for: .normal)
        backButton.tintColor = .gray15
        backButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    /// 현재 뷰컨트롤러가 루트 뷰컨트롤러인지 판별
    private func isRootViewController() -> Bool {
        guard let navigationController = navigationController else { return true }
        
        // 1. TabBar의 루트 뷰컨트롤러인 경우
        if let tabBarController = tabBarController,
           tabBarController.selectedViewController == navigationController,
           navigationController.viewControllers.first == self {
            return true
        }
        
        // 2. 네비게이션 스택의 첫 번째 뷰컨트롤러인 경우 (일반적인 루트)
        if navigationController.viewControllers.first == self {
            return true
        }
        
        // 3. 네비게이션 스택에 뷰컨트롤러가 1개뿐인 경우
        if navigationController.viewControllers.count == 1 {
            return true
        }
        
        return false
    }
    
    func setupKeyboardAdjustmentIfNeeded() {
        guard let configuration = setupKeyboardObserver() else { return }
        
        keyboardObserver = KeyboardObserver(
            viewController: self,
            configuration: configuration
        )
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension BaseViewController {
    func showTabBar() {
        NotificationCenter.default.post(name: .ShowTabBar, object: nil)
    }
    
    func hideTabBar() {
        NotificationCenter.default.post(name: .HideTabBar, object: nil)
    }
}
