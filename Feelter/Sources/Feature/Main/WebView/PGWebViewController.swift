//
//  PGWebViewController.swift
//  Feelter
//
//  Created by 이정동 on 8/21/25.
//

import UIKit
import WebKit

import iamport_ios
import RxCocoa
import RxSwift
import SnapKit

final class PGWebViewController: RxBaseViewController {
    
    struct PaymentAlertStatus {
        let title: String
        let message: String
        let isSuccess: Bool
        
        static let success = PaymentAlertStatus(title: "결제가 완료되었습니다.", message: "", isSuccess: true)
        static let failure = PaymentAlertStatus(title: "결제가 실패되었습니다.", message: "", isSuccess: false)
    }

    private lazy var webView: WKWebView = {
        var view = WKWebView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let viewModel = PGWebViewModel()
    private let paymentInfo: PaymentInfo
    
    private let paymentResultTrigger = PublishRelay<String>()
    private let alertTrigger = PublishRelay<PaymentAlertStatus>()
    
    var successPaymentCompletion: (() -> Void)?
    
    init(paymentInfo: PaymentInfo) {
        self.paymentInfo = paymentInfo
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .coverVertical
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestPayment(paymentInfo: paymentInfo)
    }
    
    override func setupView() {
        view.backgroundColor = .white
    }
    
    override func setupSubviews() {
        view.addSubview(webView)
    }
    
    override func setupConstraints() {
        
        webView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func bind() {
        let input = PGWebViewModel.Input(
            validPayment: paymentResultTrigger.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.validationResult
            .subscribe(with: self) { owner, result in
                switch result {
                case .success:
                    owner.alertTrigger.accept(.success)
                case .failure:
                    owner.alertTrigger.accept(.failure)
                }
            }
            .disposed(by: disposeBag)
        
        alertTrigger
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, status in
                
                let alertController = UIAlertController(
                    title: status.title,
                    message: status.message,
                    preferredStyle: .alert
                )
                let action = UIAlertAction(title: "확인", style: .default) { _ in
                    if status.isSuccess { owner.successPaymentCompletion?() }
                    owner.dismiss(animated: true)
                }
                alertController.addAction(action)
                owner.present(alertController, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

extension PGWebViewController {
    private func requestPayment(paymentInfo: PaymentInfo) {
        let userCode = AppConfiguration.iamportUserCode
        let payment = createPaymentData(
            orderCode: paymentInfo.orderCode,
            filterName: paymentInfo.filterName,
            price: paymentInfo.price
        )
        
        Iamport.shared.paymentWebView(
            webViewMode: webView,
            userCode: userCode,
            payment: payment
        ) { [weak self] response in
            print("Iamport Payment response: \(String(describing: response))")
            
            guard let self = self,
                  let isSuccess = response?.success,
                  let impUID = response?.imp_uid else {
                Task { @MainActor in
                    self?.dismiss(animated: true)
                }
                return
            }
            
            if isSuccess {
                self.paymentResultTrigger.accept(impUID)
            } else {
                self.alertTrigger.accept(.failure)
            }
        }
    }
    
    private func createPaymentData(
        orderCode: String,
        filterName: String,
        price: Int
    ) -> IamportPayment {
        let display = CardQuota()
        display.card_quota = []
        
        return IamportPayment(
            pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
            merchant_uid: orderCode,
            amount: "\(price)"
        ).then {
            $0.pay_method = PayMethod.card.rawValue
            $0.name = filterName
            $0.buyer_name = "사용자 이름"
            $0.app_scheme = "feelter"
        }
    }
}
