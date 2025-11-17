//
//  WebViewController.swift
//  Feelter
//
//  Created by 이정동 on 8/6/25.
//

import UIKit
import WebKit

import RxCocoa
import RxSwift
import SnapKit

import FTDependencies
import FTStorageInterface
import FTUtility

final class BannerWebViewController: UIViewController {
    
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
    
    private lazy var webView: WKWebView = {
        let controller = WKUserContentController()
        controller.add(self, name: "click_attendance_button")
        controller.add(self, name: "complete_attendance")
        let config = WKWebViewConfiguration()
        config.userContentController = controller
        let view = WKWebView(frame: .zero, configuration: config)
        view.navigationDelegate = self
        return view
    }()
    
    @Dependency private var tokenManager: TokenManager
    @Dependency private var environment: EnvironmentProviding
    
    private let disposeBag = DisposeBag()
    private let path: String
    
    // MARK: - Initializer
    
    init(path: String) {
        self.path = path
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
        
        view.backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
        setupActions()
        loadURL()
    }
    
    // MARK: - Setup
    
    private func setupSubviews() {
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
        guard let url = URL(string: environment.baseURL + path) else {
            presentAlert(title: "잘못된 URL입니다.")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(
            environment.apiKey,
            forHTTPHeaderField: "SeSACKey"
        )
        
        webView.load(request)
        loadingIndicator.startAnimating()
    }
    
    private func presentAlert(title: String, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            self.dismiss(animated: true)
        })
        present(alert, animated: true)
    }
}

// MARK: - WKNavigationDelegate

extension BannerWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadingIndicator.stopAnimating()
        presentAlert(title: "페이지를 불러올 수 없습니다.", message: error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        loadingIndicator.stopAnimating()
        presentAlert(title: "페이지를 불러올 수 없습니다.", message: error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // 필요시 특정 URL 차단이나 외부 앱 연동 처리
        decisionHandler(.allow)
    }
}

extension BannerWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        guard let sourceURL = message.frameInfo.request.url,
              let host = sourceURL.host(),
              host == environment.baseURL else {
            print("URL을 확인할 수 없음")
            return
        }
        
        switch message.name {
            
        case "click_attendance_button":
            guard let accessToken = tokenManager.accessToken else {
                return
            }
            let jsonData = try! JSONEncoder().encode(accessToken)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            webView.evaluateJavaScript("requestAttendance('\(jsonString)')")
            
        case "complete_attendance":
            var alertMessage: String?
            if let count = message.body as? Int {
                alertMessage = "\(count)번째 출석 완료하셨습니다."
            }
            presentAlert(title: "출석 성공!", message: alertMessage)
        default:
            break
        }
    }
}
