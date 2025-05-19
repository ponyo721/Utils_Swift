//
//  XPCClientUtil.swift
//  XPCClientWithSwift
//
//  Created by byeongho park on 1/9/25.
//

import Foundation

protocol XPCClientUtilDelegate {
    func recvXPCDisconnectEvent()
}

class XPCClientUtil: NSObject {
    //MARK: - Public Variables
    var listener: NSXPCListener?
    var connection: NSXPCConnection?
    
    var clientReciver:XPCClientImpl = XPCClientImpl()
    
    //MARK: - Public Methods
    
    /// Start a new XPC connection.
    func start() {
        NSLog("[XPCClientUtil] start.")
        
        connection = NSXPCConnection(
            machServiceName: "com.ponyo.macos.XPCServerWithSwift"
        )
        
        // 3. 내 Process가 Recv할 Func Protocol 지정
        connection!.exportedInterface = NSXPCInterface(
            with: XPCClientProtocol.self
        )
        
        // 4. 3번에서 지정한 func이 호출되면 실제 정의된 곳으로 전달해달 요청
        connection!.exportedObject = clientReciver
        
        // 연결된 다른 프로세스에게 보낼 프로토콜
        connection!.remoteObjectInterface = NSXPCInterface(
            with: XPCServerProtocol.self
        )
        
        // 6. XPC연결이 끊어졌을 때 호출될 함수 지정
        connection!.invalidationHandler = connectionInvalidationHandler
        connection!.interruptionHandler = connetionInterruptionHandler
        
        NSLog("[XPCClientUtil] resume")
        connection?.resume()
        
        clientReciver.server = connection?.remoteObjectProxy as? XPCServerProtocol
        clientReciver.server?.printHello()
    }
    
    func xpcDisconnect() {
        
    }
    
    //MARK: - XPC Disconnect callback -
    
    /// XPC session interruption handler
    private func connetionInterruptionHandler() {
        NSLog("[XPCClientUtil] \(type(of: self)): connection has been interrupted.")
        
    }
    
    /// XPC session invalidation handler
    private func connectionInvalidationHandler() {
        NSLog("[XPCClientUtil] \(type(of: self)): connection has been invalidated.")
    }
    
    //MARK: - XPC Commmon Private Func -
    
    //MARK: - XPC Commmon Public Func -
    
    func sendHello() {
        clientReciver.server?.printHello()
    }
}
