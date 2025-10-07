import ProjectDescription

let project = Project(
    name: "FTUtility",
    targets: [
        .target(
            name: "FTUtility",
            destinations: .iOS,
            product: .framework,
            bundleId: "kr.co.ios.swift.apple.FTUtility",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/**"],
            dependencies: [
                .external(name: "RxSwift"),
                .external(name: "RxCocoa")
            ]
        )
    ]
)
