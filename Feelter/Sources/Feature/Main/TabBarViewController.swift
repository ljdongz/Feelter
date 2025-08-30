//
//  CustomTabBarController.swift
//  Feelter
//
//  Created by 이정동 on 8/20/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class TabBarViewController: RxBaseViewController {
    
    // MARK: - UI Components
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var tabBarView: GlassTabBarView = {
        let tabBar = GlassTabBarView()
        tabBar.delegate = self
        return tabBar
    }()
    
    // MARK: - Properties
    private var viewControllers: [UIViewController] = []
    private var currentViewController: UIViewController?
    private var selectedIndex: Int = 0
    
    override func setupView() {
        view.backgroundColor = .black
        
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: FilterFeedViewController())
        let vc3 = UINavigationController(rootViewController: FilterMakeOnboardingViewController())
        let vc4 = UIViewController()
        let vc5 = UINavigationController(rootViewController: MyPageViewController())
        
        vc4.view.backgroundColor = .brightTurquoise
        
        setViewControllers([vc1, vc2, vc3, vc4, vc5])
    }
    
    // MARK: - Setup
    override func setupSubviews() {
        view.addSubviews([
            containerView,
            tabBarView
        ])
    }
    
    override func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tabBarView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    override func bind() {
        NotificationCenter.default.rx
            .notification(.ShowTabBar)
            .subscribe(with: self) { owner, _ in
                
                UIView.animate(
                    withDuration: 0.2,
                    delay: 0.1,
                    options: .curveEaseIn
                ) {
                    owner.tabBarView.alpha = 1.0
                    owner.tabBarView.transform = .identity
                }
            }
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(.HideTabBar)
            .subscribe(with: self) { owner, _ in
                
                UIView.animate(
                    withDuration: 0.2,
                    delay: 0,
                    options: .curveEaseOut
                ) {
                    owner.tabBarView.alpha = 0.0
                    owner.tabBarView.transform = CGAffineTransform(translationX: 0, y: 100)
                }
            }
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(.PushToChatViewController)
            .compactMap { $0.object as? APNsPayload }
            .subscribe(with: self) { owner, payload in
                owner.navigateToChatRoom(roomID: payload.roomID)
            }
            .disposed(by: disposeBag)
    }
}

extension TabBarViewController {
    func setViewControllers(_ viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        
        if !viewControllers.isEmpty {
            showViewController(at: 0)
        }
    }
    
    func setSelectedIndex(_ index: Int) {
        guard index >= 0 && index < viewControllers.count else { return }
        showViewController(at: index)
        tabBarView.setSelectedIndex(index)
    }
    
    private func showViewController(at index: Int) {
        guard index < viewControllers.count else { return }
        
        // 이전 뷰 컨트롤러 제거
        if let currentVC = currentViewController {
            currentVC.willMove(toParent: nil)
            currentVC.view.removeFromSuperview()
            currentVC.removeFromParent()
        }
        
        // 새 뷰 컨트롤러 추가
        let newViewController = viewControllers[index]
        addChild(newViewController)
        containerView.addSubview(newViewController.view)
        
        newViewController.view.snp.makeConstraints { make in
            make.edges.equalTo(containerView)
        }
        
        newViewController.didMove(toParent: self)
        currentViewController = newViewController
        selectedIndex = index
    }
    
    /// 푸시 알림을 통해 특정 채팅방으로 이동
    private func navigateToChatRoom(roomID: String) {
        
        // 현재 선택된 탭의 네비게이션 컨트롤러 가져오기
        guard let currentNavigationController = currentViewController as? UINavigationController else {
            print("❌ Current view controller is not a navigation controller")
            return
        }
        
        // ChatViewController 생성 및 push
        let chatViewModel = ChatViewModel(roomID: roomID)
        let chatViewController = ChatViewController(viewModel: chatViewModel)
        
        currentNavigationController.pushViewController(chatViewController, animated: true)
        print("✅ Navigated to chat room with ID: \(roomID)")
    }
}

// MARK: - GlassTabBarDelegate
extension TabBarViewController: GlassTabBarDelegate {
    func tabBarDidSelectItem(at index: Int) {
        showViewController(at: index)
    }
}
