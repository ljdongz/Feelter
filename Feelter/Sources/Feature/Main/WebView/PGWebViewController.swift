//
//  PGWebViewController.swift
//  Feelter
//
//  Created by 이정동 on 8/21/25.
//

import UIKit
import WebKit

import iamport_ios
import RxSwift
import SnapKit

final class PGWebViewController: BaseViewController {

    private lazy var webView: WKWebView = {
        var view = WKWebView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let paymentInfo: PaymentInfo
    
    init(paymentInfo: PaymentInfo) {
        self.paymentInfo = paymentInfo
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .coverVertical
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        requestPayment(paymentInfo: paymentInfo)
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
            print("------------------------------------------")
            print("결과 왔습니다~~")
            print("Iamport Payment response: \(String(describing: response))")
            print("------------------------------------------")
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
