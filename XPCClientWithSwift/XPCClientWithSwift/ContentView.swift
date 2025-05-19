//
//  ContentView.swift
//  XPCClientWithSwift
//
//  Created by byeongho park on 1/9/25.
//

import SwiftUI

struct ContentView: View {
    let xpcClient:XPCClientUtil = XPCClientUtil()
    
    var body: some View {
        VStack {
            Text("Hello, XPC Client World!")
            Button(action: {
                xpcClient.start()
            }, label: {
                Text("start")
            })
            
            Button(action: {
                xpcClient.sendHello()
            }, label: {
                Text("send Hello")
            })
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
