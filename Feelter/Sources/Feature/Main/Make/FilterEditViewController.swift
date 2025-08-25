//
//  FilterEditViewController.swift
//  Feelter
//
//  Created by 이정동 on 8/25/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class FilterEditViewController: RxBaseViewController {
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<Section, AnyHashable>
    
    enum Section: Int {
        case filterAttributes
    }
    
    private let navigationLeftBarButton: UIButton = {
        let view = UIButton()
        view.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        view.setImage(.xmark, for: .normal)
        view.tintColor = .gray15
        return view
    }()
    
    private let navigationRightBarButton: UIButton = {
        let view = UIButton()
        view.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        view.setImage(.save, for: .normal)
        view.tintColor = .gray15
        return view
    }()
    
    private let filterImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = .sample
        return view
    }()

    private let undoButton: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(.undo.resized(to: .init(width: 24, height: 24)), for: .normal)
        view.backgroundColor = .gray75.withAlphaComponent(0.5)
        view.tintColor = .gray60
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray75.cgColor
        return view
    }()
    
    private let redoButton: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(.redo.resized(to: .init(width: 24, height: 24)), for: .normal)
        view.backgroundColor = .gray75.withAlphaComponent(0.5)
        view.tintColor = .gray75
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray75.cgColor
        return view
    }()

    private let compareButton: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(.compare.resized(to: .init(width: 24, height: 24)), for: .normal)
        view.backgroundColor = .gray75.withAlphaComponent(0.5)
        view.tintColor = .gray60
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray75.cgColor
        return view
    }()

    private lazy var attributesCollectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewLayout()
        )
        view.contentInsetAdjustmentBehavior = .never
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        return view
    }()
    
    private var dataSource: DataSourceType!
    private var selectedFilterAttribute: FilterAttributeType = FilterAttributeType.allCases.first ?? .brightness
    
    override func setupView() {
        setupCollectionView()
        initializeSnapShot()
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationItem.leftBarButtonItem = .init(customView: navigationLeftBarButton)
        navigationItem.rightBarButtonItem = .init(customView: navigationRightBarButton)
        title = "Edit"
        
        view.backgroundColor = .black
    }
    
    override func setupSubviews() {
        view.addSubviews([
            filterImageView,
            attributesCollectionView
        ])
        
        filterImageView.addSubviews([
            undoButton,
            redoButton,
            compareButton
        ])
    }
    
    override func setupConstraints() {
        
        filterImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(attributesCollectionView.snp.top)
        }
        
        undoButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(16)
            make.width.equalTo(40)
            make.height.equalTo(32)
        }
        
        redoButton.snp.makeConstraints { make in
            make.top.equalTo(undoButton.snp.top)
            make.leading.equalTo(undoButton.snp.trailing).offset(8)
            make.width.equalTo(40)
            make.height.equalTo(32)
        }
        
        compareButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(16)
            make.width.equalTo(40)
            make.height.equalTo(32)
        }

        attributesCollectionView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(80)
        }
    }
    
    override func bind() {
        
        attributesCollectionView.rx.itemSelected
            .subscribe(with: self) { owner, indexPath in
                owner.attributesCollectionView.scrollToItem(
                    at: indexPath,
                    at: .centeredHorizontally,
                    animated: true
                )
            }
            .disposed(by: disposeBag)
        
        navigationLeftBarButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let alertVC = UIAlertController(
                    title: "필터 편집을 그만두시겠습니까?",
                    message: "지금까지 적용한 편집 정보가 사라집니다.",
                    preferredStyle: .alert
                )
                let okAction = UIAlertAction(
                    title: "나가기",
                    style: .destructive
                ) { _ in
                    owner.navigationController?.popViewController(animated: true)
                }
                let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                alertVC.addAction(okAction)
                alertVC.addAction(cancelAction)
                owner.present(alertVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        navigationRightBarButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let alertVC = UIAlertController(
                    title: "저장하시겠습니까?",
                    message: nil,
                    preferredStyle: .alert
                )
                let okAction = UIAlertAction(
                    title: "확인",
                    style: .default
                ) { _ in
                    owner.navigationController?.popViewController(animated: true)
                }
                let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                alertVC.addAction(okAction)
                alertVC.addAction(cancelAction)
                owner.present(alertVC, animated: true)
            }
            .disposed(by: disposeBag)
    }

}

// MARK: - CollectionView Configuration

extension FilterEditViewController {
    func setupCollectionView() {
        // 1) Compositional Layout 설정
        configureCompositionalLayout()
        
        // 2) 셀 등록
        registerCollectionViewCells()
        
        // 3) DiffableDataSource 설정
        configureDiffableDataSource()
    }
    
    func configureCompositionalLayout() {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            let section = Section(rawValue: sectionIndex)!
            switch section {
            case .filterAttributes:
                return FilterAttributeCollectionViewCell.layoutSection { [weak self] items, point, environment in
                    self?.selectCenterItem()
                }
            }
        }
        
        attributesCollectionView.collectionViewLayout = layout
    }
    
    func registerCollectionViewCells() {
        
        attributesCollectionView.register(
            FilterAttributeCollectionViewCell.self,
            forCellWithReuseIdentifier: FilterAttributeCollectionViewCell.identifier
        )
    }
    
    func configureDiffableDataSource() {
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: attributesCollectionView,
            cellProvider: { [weak self] collectionView, indexPath, item in
                
                guard let self else { return .init() }
                
                switch Section(rawValue: indexPath.section) {
                case .filterAttributes:
                    guard let item = item as? FilterAttributeType,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: FilterAttributeCollectionViewCell.identifier,
                            for: indexPath
                          ) as? FilterAttributeCollectionViewCell else {
                        return .init()
                    }
                    cell.configureCell(item: item)
                    cell.isSelected = item == self.selectedFilterAttribute
            
                    return cell
                
                default:
                    return .init()
                }
            }
        )
    }
}

// MARK: - Private Method

extension FilterEditViewController {
    private func initializeSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapShot.appendSections([.filterAttributes])
        snapShot.appendItems(FilterAttributeType.allCases, toSection: .filterAttributes)
        dataSource.apply(snapShot, animatingDifferences: false)
        
        // 첫 번째 아이템 선택
        let firstIndexPath = IndexPath(item: 0, section: 0)
        self.attributesCollectionView.selectItem(
            at: firstIndexPath,
            animated: false,
            scrollPosition: []
        )
    }
    
    private func selectCenterItem() {
        let centerPoint = CGPoint(
            x: attributesCollectionView.contentOffset.x + attributesCollectionView.bounds.width / 2,
            y: attributesCollectionView.bounds.height / 2
        )
        
        guard let centerIndexPath = attributesCollectionView.indexPathForItem(at: centerPoint) else { return }
        
        let selectedItem = FilterAttributeType.allCases[centerIndexPath.item]
        
        // 이미 선택된 아이템과 같다면 리턴
        if selectedFilterAttribute == selectedItem { return }
        
        selectedFilterAttribute = selectedItem
        self.attributesCollectionView.selectItem(
            at: centerIndexPath,
            animated: false,
            scrollPosition: []
        )
    }
}



#if DEBUG
import SwiftUI
@available(iOS 17.0, *)
#Preview {
    UINavigationController(rootViewController: FilterEditViewController())
}
#endif
