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

    override func setupView() {
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .coverVertical
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
}

extension PGWebViewController {
    private func requestPayment() {
        let userCode = AppConfiguration.iamportUserCode
        let payment = createPaymentData()
        
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
    
    private func createPaymentData() -> IamportPayment {
        let display = CardQuota()
        display.card_quota = []
        
        let orderCode = "-"
        
        return IamportPayment(
            pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
            merchant_uid: orderCode,
            amount: "1000"
        ).then {
            $0.pay_method = PayMethod.card.rawValue
            $0.name = "상품 이름"
            $0.buyer_name = "사용자 이름"
            $0.app_scheme = "feelter"
        }
    }
}
