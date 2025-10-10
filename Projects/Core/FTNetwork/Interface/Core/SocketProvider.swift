//
//  SocketIOProvider.swift
//  Feelter
//
//  Created by 이정동 on 8/17/25.
//

import Foundation

public protocol SocketProvider {
    func connect(roomID: String, receiveMessage: @escaping ((Data) -> Void))
    func disconnect()
    
    func isConnected(roomID: String) -> Bool
}
