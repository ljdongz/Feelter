//
//  SocketIOProvider.swift
//  Feelter
//
//  Created by 이정동 on 8/17/25.
//

import Foundation

protocol SocketProvider {
    func connect(roomID: String, receiveMessage: @escaping ((ChatMessage) -> Void))
    func disconnect()
    
    func isConnected(roomID: String) -> Bool
}
