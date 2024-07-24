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
    
    //MARK: - PROPERTIES
    static let schema = "services"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "note")
    var note: Float?
    
    @Field(key: "distance")
    var distance: Float?
    
    @Parent(key: "categoryID")
    var category: Category
    
    init() { }
    
    // MARK: Inits
    init(id: UUID? = nil, name: String, note: Float? = nil, distance: Float? = nil, categoryID: UUID) {
        self.id = id
        self.name = name
        self.note = note
        self.distance = distance
        self.$category.id = categoryID
    }
    
}

// MARK: - Extension Services DTOs
extension Service {
    
    //MARK: - Create Validate
    struct Create: Content, Validatable {
        
        //MARK: - Properties
        let name : String
        let note: Float
        let distance: Float
        let categoryID: UUID

        
        // MARK: Validations
        static func validations(_ validations: inout Vapor.Validations) {
            validations.add("name", as: String.self, is: !.empty, required: true)
            validations.add("note", as: Float.self, is: .valid)
            validations.add("distance", as: Float.self, is: .valid)
            validations.add("categoryID", as: UUID.self, is: .valid, required: true)
        }
        
    }
    
}

