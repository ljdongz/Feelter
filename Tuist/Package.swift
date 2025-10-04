// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        productTypes: [
            "Realm": .framework,
            "RealmSwift": .framework,
            "RxSwift": .framework,
            "RxCocoa": .framework,
            "RxCocoaRuntime": .framework,
            "RxRelay": .framework
        ]
    )
#endif

let package = Package(
    name: "Feelter",
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.7.1"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.8.0"),
        .package(url: "https://github.com/kakao/kakao-ios-sdk", from: "2.24.6"),
        .package(url: "https://github.com/onevcat/Kingfisher", from: "8.5.0"),
        .package(url: "https://github.com/socketio/socket.io-client-swift", from: "16.1.1"),
        .package(url: "https://github.com/realm/realm-swift", from: "20.0.3"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "12.1.0"),
        .package(url: "https://github.com/iamport/iamport-ios", from: "1.4.7")
    ]
)
