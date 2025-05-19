//
//  User.swift
//  XPCServerWithSwift
//
//  Created by byeongho park on 1/10/25.
//

import Foundation

// Codable을 채택한 데이터 클래스
class User: Codable {
    var id: Int
    var name: String
    var email: String

    init(id: Int, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }
}
