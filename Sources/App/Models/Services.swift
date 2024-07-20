//
//  File.swift
//  
//
//  Created by Alejandro Alberto Gavira García on 20/7/24.
//

import Vapor
import Fluent

final class Services: Model, Content, @unchecked Sendable {
    
    //MARK: - PROPERTIES
    static let schema = "services"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "category")
    var category: Category
    
    @Field(key: "note")
    var note: Float?
    
    @Field(key: "distance")
    var distance: Float?
    
    init() { }
    
    // MARK: Inits
    init(id: UUID? = nil, name: String, category: Category, note: Float? = nil, distance: Float? = nil) {
        self.id = id
        self.name = name
        self.category = category
        self.note = note
        self.distance = distance
    }
    
}

extension Services {
    
    //MARK: - Create
    struct Create: Content, Validatable {
        
        //MARK: - Properties
        let name : String
        let category: Category
        let note: Float
        let distance: Float
        
        static func validations(_ validations: inout Vapor.Validations) {
            validations.add("name", as: String.self, is: !.empty, required: true)
            validations.add("category", as: Category.self, is: !.empty, required: true)
            validations.add("note", as: Float.self, is: .valid, required: true)
            validations.add("distance", as: Float.self, is: .valid, required: true)
        }
        
    }
    
    
    
}
