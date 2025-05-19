//
//  XPCServerUtil.swift
//  XPCServerWithSwift
//
//  Created by byeongho park on 1/9/25.
//

import Foundation

protocol XPCServerUtilDelegate {
    func recvXPCDisconnectEvent()
}

class XPCServerUtil: NSObject, NSXPCListenerDelegate {
    var listener: NSXPCListener?
    var connection: NSXPCConnection?
    
    var serverReciver:XPCServerImpl = XPCServerImpl()
    
    internal func start() {
        NSLog("[XPCServerUtil] start.")
        
        listener = NSXPCListener(
            machServiceName: "com.ponyo.macos.XPCServerWithSwift"
        )
        listener?.delegate = self
        
        NSLog("[XPCServerUtil] resume")
        listener?.resume()
    }
    
    // NSXPCConnection interruptionHandler
    private func connetionInterruptionHandler() {
        NSLog("[XPCServerUtil] The session has interrupted.")
    }
    
    // NSXPCConnection invalidationHandler
    private func connectionInvalidationHandler() {
        NSLog("[XPCServerUtil] The session has invalidated.")
    }
    
    //MARK: - NSXPCListenerDelegate -
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        NSLog("[XPCServerUtil] listener.")
        
        newConnection.exportedInterface = NSXPCInterface(
            with: XPCServerProtocol.self
        )
        newConnection.exportedObject = serverReciver
        
        
        newConnection.remoteObjectInterface = NSXPCInterface(
            with: XPCClientProtocol.self
        )
        
        newConnection.interruptionHandler = connetionInterruptionHandler
        newConnection.invalidationHandler = connectionInvalidationHandler
        
        newConnection.resume()
        
        serverReciver.client = newConnection.remoteObjectProxy as? XPCClientProtocol
        
        self.connection = newConnection
        
        return true
    }
    
    //MARK: - public func -
    
    func sendHello() {
        serverReciver.client?.printClientHello()
    }
    
    func sendJSON() {
        do {
            let user = User(id: 1, name: "John Doe", email: "john@example.com")
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted // 보기 좋게 포맷팅
            let jsonData = try encoder.encode(user)
            
            // JSON 데이터 출력
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("JSON String:\n\(jsonString)")
            }
            
            // 원격 객체 호출
            
            serverReciver.client?.sendJSONData(jsonData) { responseData in
                guard let responseData = responseData else {
                    print("No response from XPC")
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let responseUser = try decoder.decode(User.self, from: responseData)
                    print("Received User from XPC:")
                    print("ID: \(responseUser.id), Name: \(responseUser.name), Email: \(responseUser.email)")
                } catch {
                    print("Failed to decode response:", error)
                }
            }
        } catch {
            print("Failed to encode user to JSON:", error)
        }
    }
}
