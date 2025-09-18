# <img width="32" height="32" alt="appicon" src="https://github.com/user-attachments/assets/d20fb2ed-78aa-48ee-9225-528908f6f4d7" /> Feel the Filter, Feelter

사진작가들이 자신만의 독창적인 필터를 제작하여 판매하고, 다른 사용자들이 이를 구매해 활용할 수 있는 플랫폼 서비스입니다.

## 💬 개요
- 팀 구성 : 3명 (iOS 1명, Backend 1명, Design 1명)
- 개발 기간 : 2025.7.29 ~ 2025.9.7
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
- 필터 마켓 플레이스 (필터 생성, 목록 불러오기, 필터 상세보기)
- 나만의 필터 생성 (CoreImage를 활용하여 사진에 필터 입히기)
- 채팅 (푸시 알림, 읽지 않은 개수, 이미지 전송)
- PG 결제 (필터 구매)

## 🖼️ 스크린샷
| 홈 | 출석체크(웹뷰) | 피드 |
| :-------- | :------- | :------- | 
| <img width="200" alt="IMG_0220" src="https://github.com/user-attachments/assets/dae8d16d-851d-4e0a-a5d6-a62707300c4e" /> | <img width="200" alt="IMG_0237" src="https://github.com/user-attachments/assets/5a069239-491d-4ccd-9c12-cc61239a700f" /> | <img width="200" alt="IMG_0238" src="https://github.com/user-attachments/assets/7b3a69ba-9196-4627-a41f-d815873f3f47" /> |

| 필터 상세(결제 전) | 필터 상세(결제 후) | 결제 화면 |
| :-------- | :------- | :------- | 
| <img width="200" alt="IMG_0222" src="https://github.com/user-attachments/assets/5874422a-c2e3-4f87-a6ed-45f38536062b" /> | <img width="200" alt="IMG_0223" src="https://github.com/user-attachments/assets/28d443af-906e-41bb-9bee-0380a0382208" /> | <img width="200" alt="123" src="https://github.com/user-attachments/assets/8780742b-314a-42fe-bfeb-68af0be36a2d" /> |

| 필터 생성(온보딩) | 필터 생성 | 필터 편집 |
| :-------- | :------- | :------- | 
| <img width="200" alt="IMG_0224" src="https://github.com/user-attachments/assets/d6eb52dd-547b-47d6-b2c8-d89ddb5938b1" /> | <img width="200" alt="IMG_0239" src="https://github.com/user-attachments/assets/86f00d2c-c0c3-4477-9c4c-4e748bf1a61a" /> | <img width="200" alt="IMG_0225" src="https://github.com/user-attachments/assets/f4e8366b-c48c-4872-afb8-b4ffe1cebe80" /> |

| 채팅 목록 | 채팅방 |
| :-------- | :------- |
| <img width="200" alt="IMG_0230" src="https://github.com/user-attachments/assets/3abe6cdc-9eff-4b46-9d31-cad26fe03f35" /> | <img width="200" alt="IMG_0231" src="https://github.com/user-attachments/assets/0e0c4335-647d-422d-afea-0439e5641ce2" /> |
