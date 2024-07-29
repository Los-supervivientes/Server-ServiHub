//
//  ModelsMigration_v0.swift
//
//
//  Created by Jose Bueno Cruz on 11/7/24.
//

import Vapor
import Fluent

// MARK: - ModelMigration V0
struct ModelsMigration_v0: AsyncMigration {
    
    // MARK: Prepare
    // Prepares the database schema by creating tables and defining their structure.
    func prepare(on database: any Database) async throws {
        
        // Create the 'users' table
        try await database
            .schema(User.schema)
            .id()
            .field("created_at", .string)
            .field("name", .string, .required)
            .field("first_surname", .string, .required)
            .field("second_surname", .string)
            .field("mobile", .string, .required)
            .field("email", .string, .required)
            .field("password", .string, .required)
            .unique(on: "email")
            .create()
        
        // Create the 'profusers' table
        try await database
            .schema(ProfUser.schema)
            .id()
            .field("created_at", .string)
            .field("name", .string, .required)
            .field("first_surname", .string, .required)
            .field("second_surname", .string)
            .field("mobile", .string, .required)
            .field("email", .string, .required)
            .field("password", .string, .required)
            .field("street", .string, .required)
            .field("city", .string, .required)
            .field("state", .string, .required)
            .field("postal_code", .string, .required)
            .field("country", .string, .required)
            .field("category_business", .string, .required)
            .field("company_name", .string, .required)
            .field("nif", .string, .required)
            .unique(on: "email")
            .unique(on: "nif")
            .create()
        
        // Create the 'categories' table
        try await database
            .schema(Category.schema)
            .id()
            .field("created_at", .string)
            .field("name", .string, .required)
            .unique(on: "name")
            .create()
        
        // Create the 'services' table
        try await database
            .schema(Service.schema)
            .id()
            .field("created_at", .string)
            .field("name", .string, .required)
            .field("note", .float)
            .field("distance", .float)
            .field("categoryID", .uuid, .required, .references("categories", "id", onDelete: .cascade))
            .field("profUserID", .uuid, .required, .references("profusers", "id", onDelete: .cascade))
            .create()
        
    }
    
    // MARK: Revert
    // Reverts the database schema changes by deleting the tables.
    func revert(on database: any Database) async throws {
        
        // Delete tables
        try await database.schema(User.schema).delete()
        try await database.schema(ProfUser.schema).delete()
        try await database.schema(Category.schema).delete()
        try await database.schema(Service.schema).delete()
        
    }
    
}



