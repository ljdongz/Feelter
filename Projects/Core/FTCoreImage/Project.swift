import ProjectDescription

let project = Project(
    name: "FTCoreImage",
    targets: [
        .target(
            name: "FTCoreImage",
            destinations: .iOS,
            product: .framework,
            bundleId: "kr.co.ios.swift.apple.FTCoreImage",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "FTUtility", path: .relativeToRoot("Projects/Shared/FTUtility")),
            ]
        )
    ]
)
