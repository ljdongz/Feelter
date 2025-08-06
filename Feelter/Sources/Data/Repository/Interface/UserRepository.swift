//
//  UserRepository.swift
//  Feelter
//
//  Created by 이정동 on 8/6/25.
//

import Foundation

protocol UserRepository {
    func fetchTodayAuthor() async throws -> TodayAuthor
}
