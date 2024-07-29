//
//  Service.swift
//
//
//  Created by Alejandro Alberto Gavira García on 20/7/24.
//

import Vapor
import Fluent

// MARK: - Services
final class Service: Model, Content, @unchecked Sendable {
    
    //MARK: Properties
    static let schema = "services"
    
    @ID(key: .id)
    var id: UUID?
    
    @Timestamp(key: "created_at", on: .create, format: .iso8601)
    var createdAt: Date?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "note")
    var note: Float?
    
    @Field(key: "distance")
    var distance: Float?
    
    @Parent(key: "categoryID")
    var category: Category
    
    @Parent(key: "profUserID")
    var profUser: ProfUser
    
    // MARK: Inits
    init() { }
    
    init(id: UUID? = nil, name: String, note: Float? = nil, distance: Float? = nil,
         categoryID: UUID, profUserID: UUID) {
        self.id = id
        self.name = name
        self.note = note
        self.distance = distance
        self.$category.id = categoryID
        self.$profUser.id = profUserID
    }
    
}

// MARK: - Extension Services DTOs
extension Service {
    
    //MARK: - Create Validate
    struct CreateUpdate: Content, Validatable {
        
        //MARK: Properties
        let name : String
        let note: Float
        let distance: Float
        let categoryID: UUID
        let profUserID: UUID

        
        // MARK: Validations
        // Validate fields for creating or updating a service
        static func validations(_ validations: inout Vapor.Validations) {
            
            validations.add("name", as: String.self, is: !.empty, required: true)
            validations.add("note", as: Float.self, is: .valid)
            validations.add("distance", as: Float.self, is: .valid)
            validations.add("categoryID", as: UUID.self, is: .valid, required: true)
            validations.add("profUserID", as: UUID.self, is: .valid, required: true)
            
        }
        
    }
    
}

