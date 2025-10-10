//
//  DIContainer+Wrapper.swift
//  FTDependencies
//
//  Created by 이정동 on 10/9/25.
//

import Foundation

@propertyWrapper
public struct Dependency<T> {
    public let wrappedValue: T

    public init() {
        self.wrappedValue = DIContainer.shared.resolve(T.self)
    }
}
