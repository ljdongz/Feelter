import ProjectDescription

let project = Project(
    name: "FTNetwork",
    targets: [
        .target(
            name: "FTNetworkInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "kr.co.ios.swift.apple.FTNetworkInterface",
            deploymentTargets: .iOS("16.0"),
            sources: ["Interface/**"],
            dependencies: []
        ),
        .target(
            name: "FTNetwork",
            destinations: .iOS,
            product: .framework,
            bundleId: "kr.co.ios.swift.apple.FTNetwork",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/**"],
            dependencies: [
                .target(name: "FTNetworkInterface"),

                .project(target: "FTStorageInterface", path: .relativeToRoot("Projects/Core/FTStorage")),
                .project(target: "FTDependencies", path: .relativeToRoot("Projects/Shared/FTDependencies")),
                .project(target: "FTUtility", path: .relativeToRoot("Projects/Shared/FTUtility")),

                .external(name: "SocketIO")
            ]
        ),
        .target(
            name: "FTNetworkTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "kr.co.ios.swift.apple.FTNetworkTests",
            deploymentTargets: .iOS("16.0"),
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "FTNetwork")
            ]
        )
    ]
)
