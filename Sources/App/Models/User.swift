//
//  User.swift
//
//
//  Created by Jose Bueno Cruz on 10/7/24.
//

import Vapor
import Fluent

// MARK: - User
final class User: Model, Content, @unchecked Sendable {
    
    // MARK: Properties
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Timestamp(key: "created_at", on: .create, format: .iso8601)
    var createdAt: Date?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "first_surname")
    var firstSurname: String
    
    @Field(key: "second_surname")
    var secondSurname: String?
    
    @Field(key: "mobile")
    var mobile: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password")
    var password: String

    
    // MARK: Inits
    init() { }
    
    init(id: UUID? = nil, name: String, firstSurname: String,
         secondSurname: String? = nil, mobile: String, email: String, password: String) {
        self.id = id
        self.name = name
        self.firstSurname = firstSurname
        self.secondSurname = secondSurname
        self.mobile = mobile
        self.email = email
        self.password = password
    }
    
}

// MARK: - Extension User DTOs
extension User {
    
    // MARK: Create
    struct Create: Content, Validatable {
        
        // MARK: Properties
        let name: String
        let firstSurname: String
        let secondSurname: String
        let mobile: String
        let email: String
        let password: String
        
        // MARK: Validations
        static func validations(_ validations: inout Vapor.Validations) {
            validations.add("name", as: String.self, is: !.empty, required: true)
            
            validations.add("firstSurname", as: String.self, is: !.empty, required: true)
            
            validations.add("secondSurname", as: String.self)
            
            validations.add("mobile", as: String.self, is: !.empty, required: true)
            
            validations.add("email", as: String.self, is: .email, required: true)
            
            validations.add("password", as: String.self, is: .count(8...), required: true)
        }
        
    }
    
    // MARK: Public
    struct Public: Content {
        
        // MARK: Properties
        let id: String
        let name: String
        let firstSurname: String
        let secondSurname: String
        let mobile: String
        let email: String
        
    }
    
}


// MARK: - Authenticable
extension User: ModelAuthenticatable {
    
    static var usernameKey = \User.$email
    static var passwordHashKey = \User.$password
    
    func verify(password: String) throws -> Bool {
        
        try Bcrypt.verify(password, created: self.password)
        
    }
    
}
