//
//  ViewModel.swift
//  Feelter
//
//  Created by 이정동 on 7/28/25.
//

import Foundation

import RxSwift

protocol ViewModel: AnyObject {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get }
    
    func transform(input: Input) -> Output
}
