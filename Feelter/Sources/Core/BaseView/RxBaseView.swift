//
//  RxBaseView.swift
//  Feelter
//
//  Created by 이정동 on 8/12/25.
//

import Foundation

import RxSwift

class RxBaseView: BaseView {
    
    private(set) var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bind()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() {}
}
