//
//  Environment+Internal.swift
//  Feelter
//
//  Created by 이정동 on 10/9/25.
//  Copyright © 2025 kr.co.ios.swift.apple. All rights reserved.
//

import Foundation

import FTDependencies
import FTUtility

private var environment = DIContainer.shared.resolve(EnvironmentProviding.self)

internal let ftBaseURL = environment.baseURL
internal let ftApiKey = environment.apiKey
