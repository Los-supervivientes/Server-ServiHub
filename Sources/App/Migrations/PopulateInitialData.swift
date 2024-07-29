//
//  PopulateInitialData.swift
//
//
//  Created by Jose Bueno Cruz on 16/7/24.
//

import Vapor
import Fluent

// MARK: - Insert Categories Migration
// This migration is responsible for inserting predefined categories into the database.
struct InsertCategories: Migration {

    // MARK: - Prepare
    // Inserts predefined categories into the database.
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        // Define the categories to be inserted
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
        
        // Create an array of future results for saving each category
        let categoryInsertions = categories.map { category in
            category.save(on: database)
        }
        
        // Wait for all insertions to complete and return a single future
        return EventLoopFuture.andAllSucceed(categoryInsertions, on: database.eventLoop)
    }

    // MARK: - Revert
    // Removes all categories from the database.
    func revert(on database: Database) -> EventLoopFuture<Void> {
        // Deletes all rows from the "categories" table
        return database.schema("categories").delete()
    }
}


