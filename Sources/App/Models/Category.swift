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
    
    @OptionalField(key: "description")
    var description: String?
    
    @OptionalField(key: "imageURL")
    var imageURL: String?
    
    @OptionalParent(key: "parent_id")
    var parent: Category?
    
    @Children(for: \.$parent)
    var children: [Category]
    
    // MARK: Inits
    init() { }
    
    init(id: UUID? = nil, name: String, description: String? = nil, imageURL: String? = nil, parentID: UUID? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.imageURL = imageURL
        self.$parent.id = parentID
    }
    
}

// MARK: - Extension Categories DTOs
extension Category {
    
    // MARK: Create
    struct Create: Content, Validatable {

        // MARK: Properties
        let name: String
        let description: String?
        let imageURL: String?
        
        // MARK: Validations
        static func validations(_ validations: inout Vapor.Validations) {
            validations.add("name", as: String.self, is: !.empty, required: true)
            validations.add("description", as: String.self)
            validations.add("imageURL", as: String.self)
        }
        
    }
    
}
