//
//  Users.swift
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
    
    @Field(key: "firstsurname")
    var firstSurname: String
    
    @Field(key: "secondsurname")
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
            // No este vacio
            validations.add("name", as: String.self, is: !.empty, required: true)
            // No este vacio
            validations.add("firstSurname", as: String.self, is: !.empty, required: true)
            // No este vacio
            validations.add("mobile", as: String.self, is: !.empty, required: true)
            // Formato email
            validations.add("email", as: String.self, is: .email, required: true)
            // Longitud mínima de 8 caracteres
            validations.add("password", as: String.self, is: .count(8...), required: true)
            // Al menos un carácter especial
            validations.add("password", as: String.self, is: .characterSet(.symbols + .punctuationCharacters), required: true)
            // Al menos un número
            validations.add("password", as: String.self, is: .characterSet(.decimalDigits), required: true)
            // Al menos una letra mayúscula
            validations.add("password", as: String.self, is: .characterSet(.uppercaseLetters), required: true)
            // Al menos una letra minúscula
            validations.add("password", as: String.self, is: .characterSet(.lowercaseLetters), required: true)
            
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
