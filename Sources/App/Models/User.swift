//
//  User.swift
//
//
//  Created by Jose Bueno Cruz on 10/7/24.
//

import Vapor
import Fluent

final class User: Model, @unchecked Sendable {
    
    // Schema
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Timestamp(key: "create_at", on: .create, format: .iso8601)
    var createdAt: Date?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "surnames")
    var surnames: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password")
    var password: String
    
    // MARK: Inits
    init() {    }
    
    init(id: UUID? = nil, createdAt: Date? = nil, name: String, surnames: String, email: String, password: String) {
        self.id = id
        self.name = name
        self.surnames = surnames
        self.email = email
        self.password = password
    }
}

