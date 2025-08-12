//
//  FilterMakeView.swift
//  Feelter
//
//  Created by 이정동 on 8/11/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class FilterMakeView: RxBaseView {
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<Section, AnyHashable>
    
    enum Section: Int {
        case title
        case category
        case introduction
        case createButton
    }
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewLayout()
        )
        view.contentInsetAdjustmentBehavior = .never
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        return view
    }()
    
    private var dataSource: DataSourceType!
    private var category: [CategorySectionItem] = CategorySectionItem.default
    
    weak var createButton: BaseButtonCollectionViewCell?
    
    let titleTextFieldRelay = BehaviorRelay<String>(value: "")
    let introductionTextFieldRelay = BehaviorRelay<String>(value: "")
    
    override func setupView() {
        setupCollectionView()
        
        dummyDataSource()
    }
    
    override func setupSubviews() {
        addSubview(collectionView)
    }
    
    override func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    override func bind() {
        Observable.combineLatest(
            titleTextFieldRelay.distinctUntilChanged(),
            introductionTextFieldRelay.distinctUntilChanged()
        )
        .map { !$0.isEmpty && !$1.isEmpty }
        .subscribe(with: self) { owner, isActive in
            owner.createButton?.isUserInteractionEnabled = isActive
            owner.createButton?.updateActiveState(isActive)
        }
        .disposed(by: disposeBag)
    }
    
    // TODO: 제거
    private func dummyDataSource() {
        var snapShot = dataSource.snapshot()
        snapShot.appendSections([.title, .category, .introduction, .createButton])
        snapShot.appendItems([UUID().uuidString], toSection: .title)
        snapShot.appendItems(category, toSection: .category)
        snapShot.appendItems([UUID().uuidString], toSection: .introduction)
        snapShot.appendItems([UUID().uuidString], toSection: .createButton)
        dataSource.apply(snapShot)
    }
}

extension FilterMakeView {
    
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
            switch Section(rawValue: sectionIndex) {
            case .title:
                return BaseTextFieldCollectionViewCell.layoutSection()
            case .category:
                return FilterCategoryCollectionViewCell.layoutSectionWithHeader()
            case .introduction:
                return BaseTextFieldCollectionViewCell.layoutSection()
            case .createButton:
                return BaseButtonCollectionViewCell.layoutSection()
            default:
                return FilterCategoryCollectionViewCell.layoutSection()
            }
        }
        
        collectionView.collectionViewLayout = layout
    }
    
    func registerCollectionViewCells() {
        
        // 헤더
        collectionView.register(
            BaseSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: BaseSectionHeaderView.identifier
        )
        
        // 필터 이름, 필터 소개
        collectionView.register(
            BaseTextFieldCollectionViewCell.self,
            forCellWithReuseIdentifier: BaseTextFieldCollectionViewCell.identifier
        )
        
        // 카테고리
        collectionView.register(
            FilterCategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: FilterCategoryCollectionViewCell.identifier
        )
        
        // 생성 버튼
        collectionView.register(
            BaseButtonCollectionViewCell.self,
            forCellWithReuseIdentifier: BaseButtonCollectionViewCell.identifier
        )
    }
    
    func configureDiffableDataSource() {
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
                guard let self else { return .init() }
                
                switch Section(rawValue: indexPath.section) {
                case .title:
                    guard let _ = itemIdentifier as? String,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: BaseTextFieldCollectionViewCell.identifier,
                            for: indexPath
                          ) as? BaseTextFieldCollectionViewCell else {
                        return .init()
                    }
                    
                    cell.configureCell(placeholder: "필터 이름을 입력해주세요.")
                    cell.textField.rx.text.orEmpty
                        .bind(to: self.titleTextFieldRelay)
                        .disposed(by: cell.disposeBag)
                    
                    return cell
                    
                case .category:
                    guard let item = itemIdentifier as? CategorySectionItem,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: FilterCategoryCollectionViewCell.identifier,
                            for: indexPath
                          ) as? FilterCategoryCollectionViewCell else {
                        return .init()
                    }
                    
                    cell.configureCell(item: item)
                    return cell
                    
                case .introduction:
                    guard let _ = itemIdentifier as? String,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: BaseTextFieldCollectionViewCell.identifier,
                            for: indexPath
                          ) as? BaseTextFieldCollectionViewCell else {
                        return .init()
                    }
                    
                    cell.configureCell(placeholder: "이 필터에 대해 간단하게 소개해주세요.")
                    cell.textField.rx.text.orEmpty
                        .bind(to: introductionTextFieldRelay)
                        .disposed(by: cell.disposeBag)
                    
                    return cell
                    
                case .createButton:
                    guard let _ = itemIdentifier as? String,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: BaseButtonCollectionViewCell.identifier,
                            for: indexPath
                          ) as? BaseButtonCollectionViewCell else {
                        return .init()
                    }
                    
                    self.createButton = cell
                    
                    cell.configureCell(title: "생성하기")
                    return cell
                 
                default:
                    return .init()
                }
            }
        )
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            
            if kind == UICollectionView.elementKindSectionHeader {
                guard let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: BaseSectionHeaderView.identifier,
                    for: indexPath
                ) as? BaseSectionHeaderView else { return nil }
                
                let section = Section(rawValue: indexPath.section)
                switch section {
                case .title:
                    headerView.configure(leading: "필터명")
                case .category:
                    headerView.configure(leading: "카테고리")
                case .introduction:
                    headerView.configure(leading: "필터 소개")
                default:
                    break
                }
                
                return headerView
            } else if kind == UICollectionView.elementKindSectionFooter {
                return nil
            } else {
                return nil
            }
        }
    }
}

#if DEBUG
import SwiftUI
@available(iOS 17.0, *)
#Preview {
    UINavigationController(rootViewController: FilterMakeViewController())
}
#endif
