//
//  RealmStorage.swift
//  Feelter
//
//  Created by 이정동 on 8/18/25.
//

import Foundation

import RealmSwift

@MainActor
final class RealmStorage {
    static let shared = RealmStorage()
    
    // @MainActor 클래스 내부에서 Realm 객체를 생성하므로,
    // Realm의 생성자 파라미터로 Actor를 전달하지 않아도
    // @MainActor에 격리된 Realm 인스턴스가 생성됨.
    // @MainActor 컨텍스트에서 Realm을 생성하므로 메인 스레드에 바인딩됨.
    // 이 Realm 인스턴스는 반드시 메인 스레드에서만 사용해야 함.
    private(set) var realm: Realm = try! Realm()
    
    private init() { }
}
