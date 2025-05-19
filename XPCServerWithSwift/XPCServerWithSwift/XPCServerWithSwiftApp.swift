//
//  XPCServerWithSwiftApp.swift
//  XPCServerWithSwift
//
//  Created by byeongho park on 1/9/25.
//

import SwiftUI

@main
struct XPCServerWithSwiftApp: App {
    let xpcServer:XPCServerUtil = XPCServerUtil()
    
    init() {
        print("XPCServerWithSwiftApp")
//        xpcServer.start()
    }
    
    var body: some Scene {
        WindowGroup {
            
            ContentView()
        }
    }
}
