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
    
    let hashTagButton: HashTagButton = {
        let button = HashTagButton()
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
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
    }
    
    func configure(text: String) {
        hashTagButton.textLabel.text = text
    }
}
