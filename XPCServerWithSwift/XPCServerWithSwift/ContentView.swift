//
//  ContentView.swift
//  XPCServerWithSwift
//
//  Created by byeongho park on 1/9/25.
//

import SwiftUI

struct ContentView: View {
    let xpcServer:XPCServerUtil = XPCServerUtil()
    
    var body: some View {
        VStack {
            Text("Hello, XPC Server World!")
            Button(action: {
                xpcServer.start()
            }, label: {
                Text("start")
            })
            
            Button(action: {
                xpcServer.sendHello()
            }, label: {
                Text("send Hello")
            })
            
            Button(action: {
                xpcServer.sendJSON()
            }, label: {
                Text("send JSON")
            })
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
