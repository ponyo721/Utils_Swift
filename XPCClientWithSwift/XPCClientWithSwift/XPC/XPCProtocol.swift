//
//  XPCProtocol.swift
//  XPCClientWithSwift
//
//  Created by byeongho park on 1/9/25.
//

import Foundation

//MARK: - XPCClientProtocol -
// target process가 내 process로 보내는 요청
@objc(XPCClientProtocol)
protocol XPCClientProtocol {
    func printClientHello()
    func sendJSONData(_ jsonData: Data, withReply reply: @escaping (Data?) -> Void)
}

//MARK: - XPC Recv Func Implementation -
class XPCClientImpl:NSObject, XPCClientProtocol {
    var server:XPCServerProtocol? = nil
    
    func printClientHello() {
        print("Server Hello")
    }
    
    
    func sendJSONData(_ jsonData: Data, withReply reply: @escaping (Data?) -> Void) {
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(User.self, from: jsonData)
            print("Received User Object:")
            print("ID: \(user.id), Name: \(user.name), Email: \(user.email)")
            
            // 응답으로 새로운 User 객체를 전송
            let responseUser = User(id: user.id + 1, name: "Reply to \(user.name)", email: user.email)
            let encoder = JSONEncoder()
            let responseData = try encoder.encode(responseUser)
            reply(responseData)
        } catch {
            print("Failed to process JSON data:", error)
            reply(nil)
        }
    }
}


//MARK: - XPCServerProtocol -
@objc(XPCServerProtocol)
protocol XPCServerProtocol {
    func printHello()
}

//MARK: - XPC Recv Func Implementation -
class XPCServerImpl:NSObject, XPCServerProtocol {
    var client:XPCClientProtocol? = nil
    
    func printHello() {
        print("Client Hello")
    }
}
