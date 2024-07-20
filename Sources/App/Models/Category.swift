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
    var items: [String] = []
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
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

extension Category: Collection {
    typealias Index = Int
        typealias Element = String // Assuming your elements are strings

        var startIndex: Index { return items.startIndex }
        var endIndex: Index { return items.endIndex }

        func index(after i: Index) -> Index {
            return items.index(after: i)
        }

        subscript(position: Index) -> Element {
            return items[position]
        }

        static var empty: Category {
            return Category()
        }
    
}
