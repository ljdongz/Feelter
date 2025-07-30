//
//  HashTagCollectionViewCell.swift
//  Feelter
//
//  Created by 이정동 on 7/30/25.
//

import UIKit

import RxSwift
import SnapKit

final class HashTagCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "HashTagCollectionViewCell"
    
    private let hashTagButton: HashTagButton = {
        let button = HashTagButton()
        return button
    }()
    
    var onXmarkTap: (() -> Void)?
    
    private var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        onXmarkTap = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        contentView.addSubview(hashTagButton)
        
        hashTagButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(30)
        }
        
        hashTagButton.rx.tap
        .subscribe(onNext: { [weak self] in
            self?.onXmarkTap?()
        })
        .disposed(by: disposeBag)
    }
    
    func configure(with text: String, showXmark: Bool = true) {
        hashTagButton.setTitle(text)
        hashTagButton.xmarkImageView.isHidden = !showXmark
    }
}
