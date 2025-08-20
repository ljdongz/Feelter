//
//  CustomTabBarController.swift
//  Feelter
//
//  Created by 이정동 on 8/20/25.
//

import UIKit

import SnapKit

final class TabBarViewController: BaseViewController {
    
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
        let vc3 = UINavigationController(rootViewController: FilterMakeViewController())
        let vc4 = UIViewController()
        let vc5 = UIViewController()
        
        vc4.view.backgroundColor = .brightTurquoise
        vc5.view.backgroundColor = .deepTurquoise
        
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
}

// MARK: - GlassTabBarDelegate
extension TabBarViewController: GlassTabBarDelegate {
    func tabBarDidSelectItem(at index: Int) {
        showViewController(at: index)
    }
}
