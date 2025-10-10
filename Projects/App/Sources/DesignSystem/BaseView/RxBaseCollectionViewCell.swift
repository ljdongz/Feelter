//
//  RxCollectionViewCell.swift
//  Feelter
//
//  Created by 이정동 on 8/25/25.
//

import Foundation

import RxCocoa
import RxSwift

class RxBaseCollectionViewCell: BaseCollectionViewCell {
    private(set) var disposeBag: DisposeBag = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bind()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    func bind() {}
}
