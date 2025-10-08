//
//  DIContainer.swift
//  Feelter
//
//  Created by 이정동 on 7/31/25.
//

import Foundation

public final class DIContainer {
    public static let shared = DIContainer()
    private var dependencies: [String: Any] = [:]

    private init() {}

    public func register<T, U>(_ dependency: T, type: U.Type) {
        let key = String(describing: U.self)
        dependencies[key] = dependency
    }

    public func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        let dependency = dependencies[key]

        guard let dependency = dependency as? T else {
            fatalError("\(key)는 register되지 않았어어요. resolve 부르기전에 register 해주세요")
        }

        return dependency
    }
}


