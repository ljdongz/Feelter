//
//  SplashViewController.swift
//  Feelter
//
//  Created by 이정동 on 8/4/25.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private let gradientLayer = CAGradientLayer()
    
    @Dependency private var networkProvider: NetworkProvider
    @Dependency private var tokenManager: TokenManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupRootView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradientLayer.frame = view.bounds
    }
}

private extension SplashViewController {
    func setupView() {
        gradientLayer.colors = [
            UIColor.brightTurquoise.cgColor,
            UIColor.gray100.cgColor
        ]
        gradientLayer.frame = view.frame
        self.view.layer.addSublayer(gradientLayer)
    }
    
    func setupRootView() {
        
        Task {
            if let _ = tokenManager.accessToken {
                
                do {
                    async let sleep: Void = Task.sleep(nanoseconds: 1_000_000_000)
                    async let response = networkProvider.request(
                        endpoint: AuthAPI.refresh,
                        type: AuthTokenResponseDTO.self
                    )
                    
                    let (token, _) = try await (response, sleep)
                    
                    tokenManager.updateToken(
                        access: token.accessToken,
                        refresh: token.refreshToken
                    )
                    
                    await MainActor.run {
                        RootViewSwitcher.shared.changeRootView(to: .main)
                    }
                    
                } catch {
                    // TODO: 각 에러상황 별 화면 분기 처리 고민
                    tokenManager.clearToken()
                    
                    await MainActor.run {
                        RootViewSwitcher.shared.changeRootView(to: .signIn)
                    }
                }
            }
            else {
                await MainActor.run {
                    RootViewSwitcher.shared.changeRootView(to: .signIn)
                }
            }
        }
    }
}
