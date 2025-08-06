//
//  WebViewController.swift
//  Feelter
//
//  Created by 이정동 on 8/6/25.
//

import UIKit
import WebKit

import RxSwift
import SnapKit

final class WebViewController: UIViewController {
    
    private let webView = WKWebView()
    private let disposeBag = DisposeBag()
    private let urlString: String
    
    // MARK: - UI Components
    
    private let navigationBar: UIView = {
        let view = UIView()
        view.backgroundColor = .gray0
        return view
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.xmark, for: .normal)
        button.tintColor = .gray100
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .gray100
        label.text = "출석이벤트"
        return label
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Initializer
    
    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .coverVertical
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        setupActions()
        loadURL()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        webView.navigationDelegate = self
        
        view.addSubviews([
            navigationBar,
            webView,
            loadingIndicator
        ])
        
        navigationBar.addSubviews([
            closeButton,
            titleLabel
        ])
    }
    
    private func setupConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(56)
        }
        
        closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        webView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalTo(webView)
        }
    }
    
    private func setupActions() {
        closeButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func loadURL() {
        guard let url = URL(string: urlString) else {
            showErrorAndDismiss("잘못된 URL입니다.")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(
            AppConfiguration.apiKey,
            forHTTPHeaderField: "SeSACKey"
        )
        
        webView.load(request)
        loadingIndicator.startAnimating()
    }
    
    private func showErrorAndDismiss(_ message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            self.dismiss(animated: true)
        })
        present(alert, animated: true)
    }
}

// MARK: - WKNavigationDelegate

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadingIndicator.stopAnimating()
        showErrorAndDismiss("페이지를 불러올 수 없습니다.\n\(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        loadingIndicator.stopAnimating()
        showErrorAndDismiss("페이지를 불러올 수 없습니다.\n\(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // 필요시 특정 URL 차단이나 외부 앱 연동 처리
        decisionHandler(.allow)
    }
}
