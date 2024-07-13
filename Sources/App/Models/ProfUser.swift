//
//  File.swift
//  
//
//  Created by Jose Bueno Cruz on 12/7/24.
//

import Vapor
import Fluent

// MARK: - Prof User Model
final class ProfUser: Model, Content, @unchecked Sendable {
    
    // MARK: Properties
    static let schema = "profusers"
    
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
    
    @Field(key: "street")
    var street: String

    @Field(key: "city")
    var city: String
    
    @Field(key: "state")
    var state: String

    @Field(key: "postal_code")
    var postalCode: String

    @Field(key: "country")
    var country: String
    
    @Field(key: "category_business")
    var categoryBusiness: String
    
    @Field(key: "company_name")
    var companyName: String

    @Field(key: "nif")
    var nif: String
    
    // MARK: Inits
    init() { }
    
    init(id: UUID? = nil, name: String, firstSurname: String,
         secondSurname: String? = nil, mobile: String, email: String, password: String,
         street: String, city: String, state: String, postalCode: String, country: String,
         categoryBusiness: String, companyName: String, nif: String) {
        self.id = id
        self.name = name
        self.firstSurname = firstSurname
        self.secondSurname = secondSurname
        self.mobile = mobile
        self.email = email
        self.password = password
        self.street = street
        self.city = city
        self.state = state
        self.postalCode = postalCode
        self.country = country
        self.categoryBusiness = categoryBusiness
        self.companyName = companyName
        self.nif = nif
    }
    
}

// MARK: - Extension ProfUser DTOs
extension ProfUser {
    
    // MARK: Create
    struct Create: Content, Validatable {
        
        // MARK: Properties
        let name: String
        let firstSurname: String
        let secondSurname: String
        let mobile: String
        let email: String
        let password: String
        let street: String
        let city: String
        let state: String
        let postalCode: String
        let country: String
        let categoryBusiness: String
        let companyName: String
        let nif: String
        
        
        // MARK: Validations
        static func validations(_ validations: inout Vapor.Validations) {
            validations.add("name", as: String.self, is: !.empty, required: true)
            validations.add("firstSurname", as: String.self, is: !.empty, required: true)
            validations.add("secondSurname", as: String.self)
            validations.add("mobile", as: String.self, is: !.empty, required: true)
            validations.add("email", as: String.self, is: .email, required: true)
            validations.add("password", as: String.self, is: .count(8...), required: true)
            validations.add("street", as: String.self, is: !.empty, required: true)
            validations.add("city", as: String.self, is: !.empty, required: true)
            validations.add("state", as: String.self, is: !.empty, required: true)
            validations.add("postalCode", as: String.self, is: !.empty, required: true)
            validations.add("country", as: String.self, is: !.empty, required: true)
            validations.add("categoryBusiness", as: String.self, is: !.empty, required: true)
            validations.add("companyName", as: String.self, is: !.empty, required: true)
            validations.add("nif", as: String.self, is: !.empty, required: true)
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
        let street: String
        let city: String
        let state: String
        let postalCode: String
        let country: String
        let categoryBusiness: String
        let companyName: String
        let nif: String
        
    }
    
}


// MARK: - Authenticable
extension ProfUser: ModelAuthenticatable {
    
    static var usernameKey = \ProfUser.$email
    static var passwordHashKey = \ProfUser.$password
    
    func verify(password: String) throws -> Bool {
        
        try Bcrypt.verify(password, created: self.password)
        
    }
    
}









