//
//  Category.swift
//
//
//  Created by Jose Bueno Cruz on 16/7/24.
//

import Vapor
import Fluent

final class Category: Model, Content, @unchecked Sendable {
    
    // MARK: Properties
    static let schema = "categories"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Children(for: \.$category)
    var services: [Service]
    
    // MARK: Inits
    init() { }
    
    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
    
}

// MARK: - Extension Categories DTOs
extension Category {
    
    // MARK: Create
    struct Create: Content, Validatable {

        // MARK: Properties
        let name: String
        
        // MARK: Validations
        static func validations(_ validations: inout Vapor.Validations) {
            validations.add("name", as: String.self, is: !.empty, required: true)
        }
        
    }
    
}
