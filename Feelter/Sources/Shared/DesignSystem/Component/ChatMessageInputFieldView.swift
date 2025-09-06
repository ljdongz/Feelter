//
//  ChatMessageInputField.swift
//  Feelter
//
//  Created by 이정동 on 8/13/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class ChatMessageInputFieldView: RxBaseView {
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<Section, AnyHashable>

    enum Section: Int {
        case files
    }

    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .blackTurquoise
        return view
    }()

    private let inputFieldContainerView: UIView = {
        let view = UIView()
        return view
    }()

    let plusButton: UIView = {
        let view = UIView()
        view.backgroundColor = .deepTurquoise
        view.layer.cornerRadius = 15
        return view
    }()

    private let plusImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = .gray45
        view.image = .plus
        return view
    }()
    
    private let verticalStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 5
        view.alignment = .fill
        view.backgroundColor = .deepTurquoise
        view.layer.cornerRadius = 18
        return view
    }()
    
    lazy var messageInputTextView: UITextView = {
        let view = UITextView()
        view.textColor = .gray45
        view.font = .pretendard(size: 15, weight: .medium)
        view.textContainerInset = .init(top: 9, left: 11, bottom: 9, right: 11)
        view.textAlignment = .left
        view.backgroundColor = .deepTurquoise
        view.layer.cornerRadius = 18
        view.isScrollEnabled = false
        view.delegate = self
        return view
    }()
    
    lazy var filesCollectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewLayout()
        )
        view.contentInsetAdjustmentBehavior = .never
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.bounces = false
        view.isHidden = true
        view.isScrollEnabled = false
        return view
    }()

    let sendButton: UIView = {
        let view = UIView()
        view.backgroundColor = .deepTurquoise
        view.layer.cornerRadius = 15
        view.isUserInteractionEnabled = false
        view.alpha = 0.5
        return view
    }()

    private let sendImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = .gray45
        view.image = .message
        return view
    }()
    
    private var dataSource: DataSourceType!
    private var textViewHeightConstraint: Constraint?
    private let minHeight: CGFloat = 36
    private let maxHeight: CGFloat = 120
    
    private(set) var messageField = MessageField()
    
    override func setupView() {
        setupCollectionView()
    }
    
    override func setupSubviews() {
        addSubviews([
            divider,
            inputFieldContainerView
        ])
        
        inputFieldContainerView.addSubviews([
            plusButton,
            verticalStackView,
            sendButton
        ])
        
        verticalStackView.addArrangedSubviews([
            messageInputTextView,
            filesCollectionView
        ])
        
        plusButton.addSubview(plusImageView)
        sendButton.addSubview(sendImageView)
    }
    
    override func setupConstraints() {
        // 구분선
        divider.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.bottom.equalTo(inputFieldContainerView.snp.top)
            make.height.equalTo(1)
        }
        
        // 메시지 입력 필드 컨테이너
        inputFieldContainerView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalTo(divider.snp.bottom)
        }
        
        // 입력 필드 좌측 추가 버튼
        plusButton.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.leading.equalToSuperview().inset(10)
            make.bottom.equalTo(verticalStackView.snp.bottom).offset(-3)
        }
        
        // 추가 이미지
        plusImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(16)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.leading.equalTo(plusButton.snp.trailing).offset(10)
            make.trailing.equalTo(sendButton.snp.leading).offset(-10)
            make.bottom.equalToSuperview().inset(34)
        }
        
        // 입력 필드
        messageInputTextView.snp.makeConstraints { make in
            textViewHeightConstraint = make.height.equalTo(minHeight).constraint
        }
        
        filesCollectionView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        // 입력 필드 우측 전송 버튼
        sendButton.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(verticalStackView.snp.bottom).offset(-3)
        }
        
        // 전송 이미지
        sendImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-1)
            make.centerY.equalToSuperview().offset(1)
            make.size.equalTo(16)
        }
    }
    
    override func bind() {
        filesCollectionView.rx.itemSelected
            .map { $0.item }
            .subscribe(with: self) { owner, item in
                owner.messageField.files.remove(at: item)
                owner.configureDataSource()
                owner.updateSendButtonEnabled()
                owner.filesCollectionView.isHidden = owner.messageField.files.isEmpty
            }
            .disposed(by: disposeBag)
        
        messageInputTextView.rx.text.orEmpty
            .subscribe(with: self, onNext: { owner, text in
                owner.messageField.content = text
            })
            .disposed(by: disposeBag)
    }
    
    func appendFiles(_ images: [ImageData]) {
        messageField.files.append(contentsOf: images)
        configureDataSource()
        updateSendButtonEnabled()
        filesCollectionView.isHidden = false
    }
    
    func sendButtonTapped() {
        messageField = MessageField()
        messageInputTextView.text = ""
        updateTextViewHeightConstraint()
        configureDataSource()
        updateSendButtonEnabled()
        filesCollectionView.isHidden = true
    }
}

// MARK: - CollectionView Configuration

extension ChatMessageInputFieldView {
    private func setupCollectionView() {
        // 1) Compositional Layout 설정
        configureCompositionalLayout()
        
        // 2) 셀 등록
        registerCollectionViewCells()
        
        // 3) DiffableDataSource 설정
        configureDiffableDataSource()
    }
    
    private func configureCompositionalLayout() {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            switch Section(rawValue: sectionIndex)! {
            case .files:
                return MessageInputFileCollectionViewCell.layoutSection()
            }
        }
        
        filesCollectionView.collectionViewLayout = layout
    }
    
    private func registerCollectionViewCells() {
        filesCollectionView.register(
            MessageInputFileCollectionViewCell.self,
            forCellWithReuseIdentifier: MessageInputFileCollectionViewCell.identifier
        )
    }
    
    private func configureDiffableDataSource() {
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: filesCollectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                switch Section(rawValue: indexPath.section)! {
                case .files:
                    guard let item = itemIdentifier as? MessageInputFileCellItem,
                          let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: MessageInputFileCollectionViewCell.identifier,
                            for: indexPath
                          ) as? MessageInputFileCollectionViewCell else {
                        return .init()
                    }
                    
                    cell.configureCell(image: item.image)
                    return cell
                }
            }
        )
    }
    
    private func configureDataSource() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapShot.appendSections([.files])
        snapShot.appendItems(messageField.files.map { MessageInputFileCellItem(image: $0.image) })
        dataSource.apply(snapShot, animatingDifferences: false)
    }
}

// MARK: - UITextViewDelegate
extension ChatMessageInputFieldView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {

        // 전송버튼 활성화 상태 업데이트
        updateSendButtonEnabled()
        
        // 텍스트 뷰 높이 동적 조절
        updateTextViewHeightConstraint()
    }
    
    private func updateSendButtonEnabled() {
        let isEnabled = !messageField.content.isEmpty || !messageField.files.isEmpty
        sendButton.isUserInteractionEnabled = isEnabled
        sendButton.alpha = isEnabled ? 1 : 0.5
    }
    
    private func updateTextViewHeightConstraint() {
        guard self.messageInputTextView.bounds.width > 0 else { return }
        
        // 현재 텍스트에 맞는 높이 계산
        let fixedWidth = messageInputTextView.bounds.width
        let estimatedSize = messageInputTextView.sizeThatFits(.init(width: fixedWidth, height: .greatestFiniteMagnitude))
        let newHeight = max(minHeight, min(estimatedSize.height, maxHeight))
        
        // 제약조건 업데이트
        textViewHeightConstraint?.layoutConstraints.first?.constant = newHeight
        
        messageInputTextView.isScrollEnabled = estimatedSize.height > maxHeight
        
        // 부모 뷰의 레이아웃 업데이트
        self.superview?.layoutIfNeeded()
    }
}


// MARK: - CollectionViewCell

fileprivate typealias MessageInputFileCellItem = MessageInputFileCollectionViewCell.Item

fileprivate final class MessageInputFileCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "MessageInputFileCollectionViewCell"
    
    struct Item: Hashable {
        let id = UUID()
        let image: UIImage
    }
    
    private lazy var contentImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.image = .sample
        view.layer.borderColor = UIColor.gray90.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private let xmarkImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 7.5
        view.clipsToBounds = true
        view.tintColor = .red
        view.image = .cancel
        view.backgroundColor = .gray30
        return view
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func setupSubviews() {
        contentView.addSubviews([
            contentImageView,
            xmarkImageView
        ])
    }
    
    override func setupConstraints() {
        contentImageView.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.center.equalToSuperview()
        }
        
        xmarkImageView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(2)
            make.size.equalTo(15)
        }
    }
    
    func configureCell(image: UIImage) {
        contentImageView.image = image
    }
}

extension MessageInputFileCollectionViewCell {
    static func layoutSection() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .absolute(50),
            heightDimension: .absolute(50)
        ))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(50)
            ),
            subitems: [item]
        )
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        return section
    }
}

#if DEBUG
import SwiftUI
@available(iOS 17.0, *)
#Preview {
    ChatMessageInputFieldView()
}
#endif
