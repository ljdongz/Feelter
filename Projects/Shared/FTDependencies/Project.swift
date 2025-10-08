import ProjectDescription

let project = Project(
    name: "FTDependencies",
    targets: [
        .target(
            name: "FTDependencies",
            destinations: .iOS,
            product: .framework,
            bundleId: "kr.co.ios.swift.apple.FTDependencies",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/**"],
            dependencies: []
        )
    ]
)
