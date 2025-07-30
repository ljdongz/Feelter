//
//  BaseViewController.swift
//  Feelter
//
//  Created by 이정동 on 7/28/25.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupView()
        setupSubviews()
        setupConstraints()
        setupActions()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func setupView() {}
    func setupSubviews() {}
    func setupConstraints() {}
    func setupActions() {}
}
