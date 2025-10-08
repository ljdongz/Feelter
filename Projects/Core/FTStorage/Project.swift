import ProjectDescription

let project = Project(
    name: "FTStorage",
    targets: [
        .target(
            name: "FTStorageInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "kr.co.ios.swift.apple.FTStorageInterface",
            deploymentTargets: .iOS("16.0"),
            sources: ["Interface/**"],
            dependencies: []
        ),
        .target(
            name: "FTStorage",
            destinations: .iOS,
            product: .framework,
            bundleId: "kr.co.ios.swift.apple.FTStorage",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/**"],
            dependencies: [
                .target(name: "FTStorageInterface")
            ]
        )
    ]
)
