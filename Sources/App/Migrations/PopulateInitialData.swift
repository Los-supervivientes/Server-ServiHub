//
//  PopulateInitialData.swift
//
//
//  Created by Jose Bueno Cruz on 16/7/24.
//

import Vapor
import Fluent

struct InsertCategories: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        // Define las categorías
        let categories = [
            Category(name: "Electricista"),
            Category(name: "Educador"),
            Category(name: "Fontanero"),
            Category(name: "Carpintero"),
            Category(name: "Jardinero"),
            Category(name: "Limpieza"),
            Category(name: "Pintor"),
            Category(name: "Reparación"),
            Category(name: "Cerrajero"),
            Category(name: "Nutricionista"),
            Category(name: "Fisio"),
            Category(name: "Psicologo"),
            Category(name: "Restaurante"),
            Category(name: "Abogados")
        ]
        
        // Insertar las categorías
        let categoryInsertions = categories.map { category in
            category.save(on: database)
        }
        
        return EventLoopFuture.andAllSucceed(categoryInsertions, on: database.eventLoop)
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("categories").delete()
    }
}

