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
        return view
    }()
    
    private let optionButtonContainerView: UIView = {
        let view = UIView()
        return view
    }()

    private let undoButton: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(.undo.resized(to: .init(width: 24, height: 24)), for: .normal)
        view.backgroundColor = .gray75.withAlphaComponent(0.5)
        view.tintColor = .gray30
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray75.withAlphaComponent(0.5).cgColor
        view.isEnabled = false
        return view
    }()
    
    private let redoButton: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(.redo.resized(to: .init(width: 24, height: 24)), for: .normal)
        view.backgroundColor = .gray75.withAlphaComponent(0.5)
        view.tintColor = .gray30
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray75.withAlphaComponent(0.5).cgColor
        view.isEnabled = false
        return view
    }()

    private let compareButton: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(.compare.resized(to: .init(width: 24, height: 24)), for: .normal)
        view.backgroundColor = .gray75.withAlphaComponent(0.5)
        view.tintColor = .gray30
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray75.withAlphaComponent(0.5).cgColor
        view.isEnabled = false
        return view
    }()
    
    private let slider: UISlider = {
        let view = UISlider()
        view.minimumValue = -0.25
        view.maximumValue = 0.25
        view.maximumTrackTintColor = .blackTurquoise
        view.minimumTrackTintColor = .brightTurquoise
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
        view.bounces = false
        view.addGestureRecognizer(self.collectionViewPanGesture)
        return view
    }()
    
    private lazy var collectionViewPanGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer()
        gesture.delegate = self
        return gesture
    }()
    
    private let coreImageManager: CoreImageManager
    private var dataSource: DataSourceType!
    private var selectedFilterAttribute: FilterAttributeType = .brightness
    
    private let filterAttributes = FilterAttributeType.allCases
    private let completionHandler: (ImageComparison, FilterAttribute) -> Void
    
    init(image: UIImage, completionHandler: @escaping (ImageComparison, FilterAttribute) -> Void) {
        self.coreImageManager = .init(originalImage: image)
        self.completionHandler = completionHandler
        
        self.filterImageView.image = image
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationItem.leftBarButtonItem = .init(customView: navigationLeftBarButton)
        navigationItem.rightBarButtonItem = .init(customView: navigationRightBarButton)
        title = "Edit"
        
        view.backgroundColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        showTabBar()
    }
    
    override func setupView() {
        setupCollectionView()
        initializeSnapShot()
    }
    
    override func setupSubviews() {
        view.addSubviews([
            filterImageView,
            optionButtonContainerView,
            slider,
            attributesCollectionView
        ])
        
        optionButtonContainerView.addSubviews([
            undoButton, redoButton, compareButton,
        ])
    }
    
    override func setupConstraints() {
        
        filterImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(optionButtonContainerView.snp.top).offset(-16)
        }
        
        optionButtonContainerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(slider.snp.top).offset(-16)
        }
        
        undoButton.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(32)
        }
        
        redoButton.snp.makeConstraints { make in
            make.leading.equalTo(undoButton.snp.trailing).offset(8)
            make.width.equalTo(40)
            make.height.equalTo(32)
            make.centerY.equalTo(undoButton.snp.centerY)
        }
        
        compareButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(32)
            make.centerY.equalTo(undoButton.snp.centerY)
        }
        
        slider.snp.makeConstraints { make in
            make.bottom.equalTo(attributesCollectionView.snp.top).offset(-16)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }

        attributesCollectionView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(80)
        }
    }
    
    override func bind() {
        
        Observable.merge(
            slider.rx.controlEvent(.touchUpOutside).asObservable(),
            slider.rx.controlEvent(.touchUpInside).asObservable()
        )
        .subscribe(with: self) { owner, _ in
            owner.coreImageManager.appendHistory(
                type: owner.selectedFilterAttribute,
                value: Double(owner.slider.value)
            )
            owner.updateOptionButtonActivityState()
        }
        .disposed(by: disposeBag)
        
        slider.rx.value
            .skip(1)
            .map {
                // TODO: 소수점 아래 n자리 잘라내기
                Double($0).formatByMagnitude()
            }
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                print(value)
                let image = owner.coreImageManager.applyFilter(
                    type: owner.selectedFilterAttribute,
                    value: value
                )
                owner.filterImageView.image = image
            }
            .disposed(by: disposeBag)
        
        undoButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.filterImageView.image = owner.coreImageManager.undo()
                owner.slider.value = Float(owner.coreImageManager.filterStateValue(for: owner.selectedFilterAttribute))
                owner.updateOptionButtonActivityState()
            }
            .disposed(by: disposeBag)
        
        redoButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.filterImageView.image = owner.coreImageManager.redo()
                owner.slider.value = Float(owner.coreImageManager.filterStateValue(for: owner.selectedFilterAttribute))
                owner.updateOptionButtonActivityState()
            }
            .disposed(by: disposeBag)
        
        Observable.merge(
            compareButton.rx.controlEvent(.touchUpOutside).asObservable(),
            compareButton.rx.controlEvent(.touchUpInside).asObservable()
        )
        .subscribe(with: self) { owner, _ in
            owner.filterImageView.image = owner.coreImageManager.imageComparison.filtered
        }
        .disposed(by: disposeBag)
        
        compareButton.rx.controlEvent(.touchDown)
            .asObservable()
            .subscribe(with: self) { owner, _ in
                owner.filterImageView.image = owner.coreImageManager.imageComparison.origin
            }
            .disposed(by: disposeBag)
        
        attributesCollectionView.rx.itemSelected
            .subscribe(with: self) { owner, indexPath in
                owner.selectItem(at: indexPath)
            }
            .disposed(by: disposeBag)
        
        collectionViewPanGesture.rx.event
            .subscribe(with: self) { owner, gesture in
                owner.handleScrollGesture(gesture.state)
                
                switch gesture.state {
                case .began:
                    owner.slider.isEnabled = false
                case .ended, .cancelled, .failed:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        owner.slider.isEnabled = true
                    }
                default:
                    break
                }
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
                    let filteredImage = owner.coreImageManager.imageComparison
                    let filterAttribute = owner.coreImageManager.currentFilterAttributeState
                    owner.completionHandler(filteredImage, filterAttribute)
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
                return FilterAttributeCollectionViewCell.layoutSection()
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
        snapShot.appendItems(filterAttributes, toSection: .filterAttributes)
        dataSource.apply(snapShot, animatingDifferences: false)
        
        // 첫 번째 아이템 선택
        let firstIndexPath = IndexPath(item: 0, section: 0)
        attributesCollectionView.selectItem(
            at: firstIndexPath,
            animated: false,
            scrollPosition: []
        )
    }
    
    private func handleScrollGesture(_ state: UIGestureRecognizer.State) {
        let centerPoint = CGPoint(
            x: attributesCollectionView.contentOffset.x + attributesCollectionView.bounds.width / 2,
            y: attributesCollectionView.bounds.height / 2
        )
        
        guard let centerIndexPath = attributesCollectionView.indexPathForItem(at: centerPoint) else { return }
        
        let selectedItem = filterAttributes[centerIndexPath.item]
        
        // 이미 선택된 아이템과 같다면 리턴
        if selectedFilterAttribute == selectedItem { return }
        
        let coreImageFilter = selectedItem.filter
        
        slider.minimumValue = Float(coreImageFilter.parameter.range.lowerBound)
        slider.maximumValue = Float(coreImageFilter.parameter.range.upperBound)
        slider.value = Float(coreImageManager.filterStateValue(for: selectedItem))
        
        selectedFilterAttribute = selectedItem
        
        attributesCollectionView.selectItem(
            at: centerIndexPath,
            animated: false,
            scrollPosition: []
        )
    }
    
    private func selectItem(at indexPath: IndexPath) {
        let selectedItem = filterAttributes[indexPath.item]
        
        if selectedFilterAttribute == selectedItem { return }
        
        let coreImageFilter = selectedItem.filter
        
        slider.minimumValue = Float(coreImageFilter.parameter.range.lowerBound)
        slider.maximumValue = Float(coreImageFilter.parameter.range.upperBound)
        slider.value = Float(coreImageManager.filterStateValue(for: selectedItem))
        
        selectedFilterAttribute = selectedItem
        
        slider.isEnabled = false
        
        attributesCollectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.slider.isEnabled = true
        }
    }
    
    func updateOptionButtonActivityState() {
        let isEnableUndoButton = !coreImageManager.undoStack.isEmpty
        let isEnableRedoButton = !coreImageManager.redoStack.isEmpty
        let isEnableCompareButton = !coreImageManager.undoStack.isEmpty
        
        undoButton.isEnabled = isEnableUndoButton
        redoButton.isEnabled = isEnableRedoButton
        compareButton.isEnabled = isEnableCompareButton
    }
}

// MARK: - UIGestureRecognizerDelegate

extension FilterEditViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}


#if DEBUG
import SwiftUI
@available(iOS 17.0, *)
#Preview {
    UINavigationController(rootViewController: FilterEditViewController(image: .sample) { _, _ in })
}
#endif
