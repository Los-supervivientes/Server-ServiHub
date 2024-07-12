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
    
    @Field(key: "categorybusiness")
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
