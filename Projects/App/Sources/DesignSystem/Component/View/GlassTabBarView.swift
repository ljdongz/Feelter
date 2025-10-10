//
//  GlassTabBar.swift
//  Feelter
//
//  Created by 이정동 on 8/20/25.
//

import UIKit

import SnapKit

// MARK: - 탭바 아이템 열거형
enum TabBarItem: Int, CaseIterable {
    case home = 0
    case feed = 1
    case filter = 2
//    case search = 3
    case profile = 3
    
    var iconName: String {
        switch self {
        case .home: return "house"
        case .feed: return "rectangle.grid.2x2"
        case .filter: return "camera.filters"
//        case .search: return "magnifyingglass"
        case .profile: return "person"
        }
    }
    
    var selectedIcon: UIImage {
        switch self {
        case .home: .homeFill
        case .feed: .feedFill
        case .filter: .filterFill
//        case .search: .searchFill
        case .profile: .profileFill
        }
    }
    
    var deselectedIcon: UIImage {
        switch self {
        case .home: .homeEmpty
        case .feed: .feedEmpty
        case .filter: .filterEmpty
//        case .search: .searchEmpty
        case .profile: .profileEmpty
        }
    }
}

// MARK: - 델리게이트 프로토콜
protocol GlassTabBarDelegate: AnyObject {
    func tabBarDidSelectItem(at index: Int)
}

// MARK: - 글래스 탭바 뷰
final class GlassTabBarView: BaseView {
    
    // MARK: - Properties
    weak var delegate: GlassTabBarDelegate?
    private var selectedIndex: Int = 0
    private var tabButtons: [UIButton] = []
    
    // MARK: - UI Components
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.layer.cornerRadius = 34
        return effectView
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        return stack
    }()
    
    private lazy var highlightView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    private var highlightViewCenterXConstraint: Constraint?
    
    // MARK: - Setup
    override func setupView() {
        backgroundColor = .clear
        layer.cornerRadius = 34
        layer.masksToBounds = true
        
        // 그림자 효과
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.25
        layer.masksToBounds = false
        
        // 테두리
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
        clipsToBounds = true
        
        setupTabButtons()
    }
    
    override func setupSubviews() {
        addSubviews([
            blurEffectView,
            stackView,
            highlightView
        ])
    }
    
    override func setupConstraints() {
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(19)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(32)
        }
        
        highlightView.snp.makeConstraints { make in
            make.width.equalTo(32)
            make.height.equalTo(3)
            make.top.equalTo(blurEffectView.snp.top)
            highlightViewCenterXConstraint = make.centerX.equalTo(stackView.snp.centerX).constraint
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 레이아웃이 완료된 후 하이라이트뷰 위치 조정
        if !tabButtons.isEmpty {
            moveHighlightView(to: selectedIndex, animated: false)
        }
    }
    
    private func setupTabButtons() {
        TabBarItem.allCases.forEach { item in
            let button = UIButton()
            button.tag = item.rawValue
            
            button.setImage(item.deselectedIcon, for: .normal)
            button.setImage(item.selectedIcon, for: .selected)
            
            button.tintColor = UIColor.white.withAlphaComponent(0.6)
            button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
            
            tabButtons.append(button)
            stackView.addArrangedSubview(button)
        }
        
        // 첫 번째 탭을 선택된 상태로 설정
        updateSelectedTab(index: 0, animated: false)
    }
}

extension GlassTabBarView {
    func setSelectedIndex(_ index: Int, animated: Bool = true) {
        guard index >= 0 && index < tabButtons.count else { return }
        updateSelectedTab(index: index, animated: animated)
    }
}

// MARK: - Private Method

extension GlassTabBarView {
    private func updateSelectedTab(index: Int, animated: Bool) {
        let previousIndex = selectedIndex
        selectedIndex = index
        
        // 버튼 상태 업데이트
        tabButtons.enumerated().forEach { buttonIndex, button in
            let isSelected = buttonIndex == index
            button.isSelected = isSelected
            button.tintColor = isSelected ? .white : UIColor.white.withAlphaComponent(0.6)
        }
        
        // 하이라이트 뷰를 선택된 버튼 위치로 이동
        moveHighlightView(to: index, animated: animated)
        
        // 선택된 버튼에 임팩트 피드백
        if animated && index != previousIndex {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        }
    }
    
    private func moveHighlightView(to index: Int, animated: Bool) {
        guard index >= 0 && index < tabButtons.count else { return }
        
        let selectedButton = tabButtons[index]
        
        // stackView 내에서 선택된 버튼의 위치 계산
        let buttonFrame = selectedButton.frame
        let stackViewFrame = stackView.frame
        
        // stackView의 centerX를 기준으로 한 offset 계산
        let stackViewCenterX = stackViewFrame.width / 2
        let buttonCenterX = buttonFrame.midX
        let offset = buttonCenterX - stackViewCenterX
        
        if animated {
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: [.curveEaseInOut],
                animations: {
                    self.highlightViewCenterXConstraint?.update(offset: offset)
                    self.layoutIfNeeded()
                }
            )
        } else {
            highlightViewCenterXConstraint?.update(offset: offset)
        }
    }
    
    @objc private func tabButtonTapped(_ sender: UIButton) {
        let newIndex = sender.tag
        if newIndex != selectedIndex {
            updateSelectedTab(index: newIndex, animated: true)
            delegate?.tabBarDidSelectItem(at: newIndex)
        }
    }
}
