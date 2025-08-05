//
//  RootViewManager.swift
//  Feelter
//
//  Created by Claude on 8/4/25.
//

import UIKit

struct RootViewSwitcher {
    
    enum RootViewType {
        case signIn
        case main
    }
    
    static let shared = RootViewSwitcher()
    
    private init() {}
    
    /// 루트 뷰컨트롤러를 변경합니다
    /// - Parameters:
    ///   - type: 변경할 루트뷰 타입
    ///   - animated: 애니메이션 여부 (기본값: true)
    func changeRootView(to type: RootViewType, animated: Bool = true) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate,
              let window = sceneDelegate.window else {
            print("❌ RootViewManager: Cannot find window")
            return
        }
        
        let viewController = createViewController(for: type)
        
        if animated {
            UIView.transition(
                with: window,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: {
                    window.rootViewController = viewController
                },
                completion: nil
            )
        } else {
            window.rootViewController = viewController
        }
        
        window.makeKeyAndVisible()
    }
}

private extension RootViewSwitcher {
    func createViewController(for type: RootViewType) -> UIViewController {
        switch type {
        case .signIn:
            let signInViewController = SignInViewController()
            return UINavigationController(rootViewController: signInViewController)
            
        case .main:
            // TODO: MainViewController 구현 후 변경
            let mainViewController = UIViewController()
            mainViewController.view.backgroundColor = .green
            return UINavigationController(rootViewController: mainViewController)
        }
    }
}
