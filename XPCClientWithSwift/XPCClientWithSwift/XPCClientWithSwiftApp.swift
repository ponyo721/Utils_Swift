//
//  XPCClientWithSwiftApp.swift
//  XPCClientWithSwift
//
//  Created by byeongho park on 1/9/25.
//

import SwiftUI

@main
struct XPCClientWithSwiftApp: App {
    let xpcClient:XPCClientUtil = XPCClientUtil()
    
    init() {
        print("XPCClientWithSwiftApp")
//        xpcClient.start()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
