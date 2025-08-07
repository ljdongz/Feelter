//
//  FilterFeedView.swift
//  Feelter
//
//  Created by 이정동 on 8/7/25.
//

import UIKit

import SnapKit

final class FilterFeedView: BaseView {
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()


    
    override func setupSubviews() {
        addSubview(backgroundView)
    }
    
    override func setupConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
}
