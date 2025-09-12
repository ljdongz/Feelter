# Feel the Filter, Feelter

사진작가들이 자신만의 독창적인 필터를 제작하여 판매하고, 다른 사용자들이 이를 구매해 활용할 수 있는 플랫폼 서비스입니다.

## 💬 개요
- 팀 구성 : 3명 (iOS 1명, Backend 1명, Designer 1명)
- 개발 기간 : 2025.7.29 ~ ing
- 개발 환경 : Xcode 16.4, iOS 16.0, Swift 5.10

## 🛠️ 기술 스택
- UI : UIKit, SnapKit, WebKit
- Reactive : RxSwift, RxCocoa
- Architecture : MVVM(Input/Output Pattern), Repository Pattern
- Auth : AutheticationServices, KakaoSDK
- Network : URLSession, SocketIO, FCM, PushNotification
- DB : Realm, Keychain, UserDefaults
- Image : CoreImage, Kingfisher
- PG Payment : iamport

## 📚 핵심 기능
- 회원 관리 (이메일, 애플, 카카오 로그인 / JWT 토큰 관리)
- 필터 피드 CRUD
- 나만의 필터 생성 (CoreImage를 활용하여 사진에 필터 입히기)
- 채팅 (푸시 알림, 읽지 않은 개수, 이미지 전송)
- PG 결제 (필터 구매)
