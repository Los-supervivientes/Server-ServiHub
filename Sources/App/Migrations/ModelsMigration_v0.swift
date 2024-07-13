//
//  ModelsMigration_v0.swift
//
//
//  Created by Jose Bueno Cruz on 11/7/24.
//

import Vapor
import Fluent

// MARK: ModelMigration V0
struct ModelsMigration_v0: AsyncMigration {
    
    // MARK: Revert
    func prepare(on database: any Database) async throws {
        
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
            .unique(on: "email", "nif")
            .create()
        
    }
    
    // MARK: Prepare
    func revert(on database: any Database) async throws {
        
        try await database.schema(User.schema).delete()
        try await database.schema(ProfUser.schema).delete()
        
    }
    
}



