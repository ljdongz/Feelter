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
    @Dependency private var keychainStorage: KeychainStorage
    
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
        
        if let _ = try? keychainStorage.load(forKey: .accessToken) {
            Task {
                do {
                    async let sleep: Void = Task.sleep(nanoseconds: 1_000_000_000)
                    async let response = networkProvider.request(
                        endpoint: AuthAPI.refresh,
                        type: AuthTokenResponseDTO.self
                    )
                    
                    let (token, _) = try await (response, sleep)
                    
                    await MainActor.run {
                        try? keychainStorage.save(token.accessToken, forKey: .accessToken)
                        try? keychainStorage.save(token.refreshToken, forKey: .refreshToken)
                        
                        changeRootView(to: .main)
                    }
                    
                } catch {
                    // FIXME: 각 에러상황 별 화면 분기 처리 고민
                    await MainActor.run {
                        changeRootView(to: .signIn)
                    }
                }
            }
        } else {
            changeRootView(to: .signIn)
        }
    }
}
