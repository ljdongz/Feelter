//
//  JoinView.swift
//  Feelter
//
//  Created by 이정동 on 7/30/25.
//

import UIKit

final class JoinView: BaseView {
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<Section, String>
    
    enum Section: CaseIterable {
        case main
    }
    
    struct HashTag: Identifiable {
        let id: UUID = UUID()
        let text: String
    }
    
    // MARK: - UI Properties
    let emailTextField: FloatingTitleTextField = {
        let view = FloatingTitleTextField()
        view.titleLabel.text = "이메일(필수)"
        view.trailingButtonType = .image(.check)
        view.textField.keyboardType = .emailAddress
        view.trailingButton.tintColor = .gray30
        return view
    }()
    
    let emailDescriptLabel: UILabel = {
        let view = UILabel()
        view.text = "이메일 유효성 검사가 필요합니다."
        view.textColor = .gray45
        view.font = .pretendard(size: 9, weight: .medium)
        return view
    }()
    
    let passwordTextField: FloatingTitleTextField = {
        let view = FloatingTitleTextField()
        view.titleLabel.text = "비밀번호(필수)"
        view.trailingButtonType = .passwordToggle
        view.trailingButton.tintColor = .gray30
        return view
    }()
    
    let passwordDescriptLabel: UILabel = {
        let view = UILabel()
        view.text = "8자 이상의 영문자, 숫자, 특수문자(@$!%*#?&)를 각각 1개 이상 포함해야 합니다."
        view.textColor = .gray45
        view.font = .pretendard(size: 9, weight: .medium)
        return view
    }()
    
    let nicknameTextField: FloatingTitleTextField = {
        let view = FloatingTitleTextField()
        view.titleLabel.text = "닉네임(필수)"
        view.trailingButtonType = .none
        return view
    }()
    
    private let nicknameDescriptLabel: UILabel = {
        let view = UILabel()
        view.text = "중복되는 닉네임의 경우, 뒷자리에 랜덤한 5자리 숫자가 붙을 수 있습니다."
        view.textColor = .gray45
        view.font = .pretendard(size: 9, weight: .medium)
        return view
    }()
    
    let nameTextField: FloatingTitleTextField = {
        let view = FloatingTitleTextField()
        view.titleLabel.text = "이름"
        view.trailingButtonType = .none
        return view
    }()
    
    let phoneTextField: FloatingTitleTextField = {
        let view = FloatingTitleTextField()
        view.titleLabel.text = "휴대폰 번호"
        view.trailingButtonType = .none
        view.textField.keyboardType = .numberPad
        return view
    }()
    
    let introduceTextView: FloatingTitleTextView = {
        let view = FloatingTitleTextView()
        view.titleLabel.text = "자기소개"
        return view
    }()
    
    let hashTagTextField: FloatingTitleTextField = {
        let view = FloatingTitleTextField()
        view.titleLabel.text = "해시태그"
        view.trailingButtonType = .image(.plusFill)
        view.trailingButton.tintColor = .gray30
        return view
    }()
    
    let hashTagCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.contentInset = .init(top: 0, left: 30, bottom: 0, right: 30)
        view.register(
            HashTagCollectionViewCell.self,
            forCellWithReuseIdentifier: HashTagCollectionViewCell.identifier
        )
        return view
    }()
    
    let joinButton: UIButton = {
        let view = UIButton()
        view.setTitle("회원가입", for: .normal)
        view.setTitleColor(.gray0, for: .normal)
        view.titleLabel?.font = .pretendard(size: 16, weight: .semiBold)
        view.backgroundColor = .lightTurquoise
        view.layer.cornerRadius = 12
        return view
    }()

    // MARK: - Properties
    private let gradientLayer = CAGradientLayer()
    
    var dataSource: DataSourceType!
    
    var isJoinButtonEnable: Bool = false {
        didSet {
            joinButton.isUserInteractionEnabled = isJoinButtonEnable
            
            let alpha = isJoinButtonEnable ? 1.0 : 0.2
            joinButton.backgroundColor = .lightTurquoise.withAlphaComponent(alpha)
        }
    }
    
    // MARK: - override
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    override func setupView() {
        gradientLayer.colors = [
            UIColor.brightTurquoise.cgColor,
            UIColor.gray100.cgColor
        ]
        self.layer.addSublayer(gradientLayer)
        
        self.dataSource = DataSourceType(
            collectionView: hashTagCollectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HashTagCollectionViewCell.identifier,
                    for: indexPath
                ) as? HashTagCollectionViewCell else { return UICollectionViewCell() }
                cell.configure(text: itemIdentifier)
                return cell
        })
    }
    
    override func setupSubviews() {
        [emailTextField, emailDescriptLabel,
         passwordTextField, passwordDescriptLabel,
         nicknameTextField, nicknameDescriptLabel,
         nameTextField, phoneTextField, introduceTextView,
         hashTagTextField, hashTagCollectionView,
        joinButton].forEach { addSubview($0) }
    }
    
    override func setupConstraints() {
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }
        
        emailDescriptLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(5)
            make.trailing.equalTo(emailTextField.snp.trailing).offset(-8)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailDescriptLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }
        
        passwordDescriptLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(5)
            make.trailing.equalTo(passwordTextField.snp.trailing).offset(-8)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordDescriptLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }
        
        nicknameDescriptLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(5)
            make.trailing.equalTo(nicknameTextField.snp.trailing).offset(-8)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameDescriptLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }
        
        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }
        
        introduceTextView.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(100)
        }
        
        hashTagTextField.snp.makeConstraints { make in
            make.top.equalTo(introduceTextView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }
        
        hashTagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(hashTagTextField.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(35)
        }
        
        joinButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-15)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(45)
        }
    }
}

// MARK: - Public Method
extension JoinView {
    func appendHashTag(_ hashTag: String) {
        var snapshot = dataSource.snapshot(for: .main)
        snapshot.append([hashTag])
        dataSource.apply(snapshot, to: .main)
    }
    
    func deleteHashTag(_ hashTag: String) {
        var snapshot = dataSource.snapshot(for: .main)
        snapshot.delete([hashTag])
        dataSource.apply(snapshot, to: .main)
    }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
    JoinViewController()
}
#endif
