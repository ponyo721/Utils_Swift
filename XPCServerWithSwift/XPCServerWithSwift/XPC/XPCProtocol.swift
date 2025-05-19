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
            // JSON 데이터를 Swift 객체로 디코딩
            let decoder = JSONDecoder()
            let receivedObject = try decoder.decode([String: String].self, from: jsonData)
            print("Received JSON:", receivedObject)
            
            // 응답으로 보낼 데이터 준비
            let responseObject = ["status": "success", "message": "Hello, \(receivedObject["name"] ?? "Guest")!"]
            let encoder = JSONEncoder()
            let responseData = try encoder.encode(responseObject)
            
            // 응답 전송
            reply(responseData)
        } catch {
            print("Error processing JSON:", error)
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
