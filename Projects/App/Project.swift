import ProjectDescription

let project = Project(
    name: "Feelter",
    organizationName: "kr.co.ios.swift.apple",
    settings: .settings(
        base: [
            "DEVELOPMENT_TEAM": "5DFZR8RCQR",
            "IPHONEOS_DEPLOYMENT_TARGET": "16.0",
            "SWIFT_VERSION": "5.0",
            "MARKETING_VERSION": "1.0",
            "CURRENT_PROJECT_VERSION": "1",
            "INFOPLIST_KEY_UIUserInterfaceStyle": "Dark",
            "INFOPLIST_KEY_UISupportedInterfaceOrientations": "UIInterfaceOrientationPortrait",
            "SUPPORTED_PLATFORMS": "iphoneos iphonesimulator",
            "SUPPORTS_MACCATALYST": "NO",
            "SUPPORTS_MAC_DESIGNED_FOR_IPHONE_IPAD": "NO",
            "SUPPORTS_XR_DESIGNED_FOR_IPHONE_IPAD": "NO",
            "TARGETED_DEVICE_FAMILY": "1"
        ],
        configurations: [
            .debug(
                name: "Debug",
                xcconfig: "../../Feelter/Resources/Config/Config.xcconfig"
            ),
            .release(
                name: "Release",
                xcconfig: "../../Feelter/Resources/Config/Config.xcconfig"
            )
        ]
    ),
    targets: [
        .target(
            name: "Feelter",
            destinations: .iOS,
            product: .app,
            bundleId: "kr.co.ios.swift.apple.Feelter",
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": "Feelter",
                "UIUserInterfaceStyle": "Dark",
                "IamportUserCode": "$(IAMPORT_USER_CODE)",
                "FirebaseAppDelegateProxyEnabled": false,
                "ApiHeaderKey": "$(API_HEADER_KEY)",
                "BaseUrl": "$(BASE_URL)",
                "KakaoApiKey": "$(KAKAO_API_KEY)",
                "CFBundleURLTypes": [
                    [
                        "CFBundleTypeRole": "Editor",
                        "CFBundleURLName": "feelter.example",
                        "CFBundleURLSchemes": ["feelter"]
                    ],
                    [
                        "CFBundleTypeRole": "Editor",
                        "CFBundleURLName": "",
                        "CFBundleURLSchemes": ["kakao$(KAKAO_API_KEY)"]
                    ]
                ],
                "LSApplicationQueriesSchemes": [
                    "kakaokompassauth", "kakaolink", "kakaoplus", "kakaotalk",
                    "kftc-bankpay", "ispmobile", "itms-apps",
                    "hdcardappcardansimclick", "smhyundaiansimclick",
                    "shinhan-sr-ansimclick", "smshinhanansimclick",
                    "kb-acp", "kb-auth", "kb-screen", "kbbank",
                    "liivbank", "newliiv", "mpocket.online.ansimclick",
                    "ansimclickscard", "ansimclickipcollect", "vguardstart",
                    "samsungpay", "scardcertiapp", "lottesmartpay", "lotteappcard",
                    "cloudpay", "nhappcardansimclick", "nonghyupcardansimclick",
                    "citispay", "citicardappkr", "citimobileapp",
                    "payco", "chaipayment", "hyundaicardappcardid",
                    "com.wooricard.wcard", "lmslpay", "lguthepay-xpay",
                    "supertoss", "newsmartpib", "kakaobank"
                ],
                "NSAppTransportSecurity": [
                    "NSAllowsArbitraryLoads": true
                ],
                "UIAppFonts": [
                    "HakgyoansimMulgyeolB.ttf", "HakgyoansimMulgyeolR.ttf",
                    "Pretendard-Black.ttf", "Pretendard-Bold.ttf",
                    "Pretendard-ExtraBold.ttf", "Pretendard-ExtraLight.ttf",
                    "Pretendard-Light.ttf", "Pretendard-Medium.ttf",
                    "Pretendard-Regular.ttf", "Pretendard-SemiBold.ttf",
                    "Pretendard-Thin.ttf"
                ],
                "UIApplicationSceneManifest": [
                    "UIApplicationSupportsMultipleScenes": false,
                    "UISceneConfigurations": [
                        "UIWindowSceneSessionRoleApplication": [
                            [
                                "UISceneConfigurationName": "Default Configuration",
                                "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                            ]
                        ]
                    ]
                ],
                "UIBackgroundModes": ["remote-notification"],
                "NSPhotoLibraryUsageDescription": "앨범에서 사진 선택",
                "UILaunchStoryboardName": "LaunchScreen"
            ]),
            sources: [
                "../../Feelter/Sources/**"
            ],
            resources: [
                .glob(pattern: "../../Feelter/Resources/**")
            ],
            entitlements: .file(path: "../../Feelter/Resources/Config/Feelter.entitlements"),
            dependencies: [
                .project(target: "FTUtility", path: "../FTUtility"),
                .external(name: "SnapKit"),
                .external(name: "RxSwift"),
                .external(name: "RxCocoa"),
                .external(name: "KakaoSDKAuth"),
                .external(name: "KakaoSDKCommon"),
                .external(name: "KakaoSDKUser"),
                .external(name: "Kingfisher"),
                .external(name: "SocketIO"),
                .external(name: "RealmSwift"),
                .external(name: "Realm"),
                .external(name: "FirebaseCore"),
                .external(name: "FirebaseMessaging"),
                .external(name: "iamport-ios")
            ]
        )
    ]
)
