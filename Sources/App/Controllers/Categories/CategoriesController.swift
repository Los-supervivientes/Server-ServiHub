//
//  CategoriesController.swift
//
//
//  Created by Jose Bueno Cruz on 16/7/24.
//

import Vapor
import Fluent

// MARK: - CategoriesController
struct CategoryController: RouteCollection {
    
    // MARK: Route Registration
    // Registers routes for category-related operations.
    func boot(routes: RoutesBuilder) throws {
        
        routes.group("categories") { builder in
            
            builder.get(use: getAllCategories)
            builder.get(":categoryID", use: getCategoryByID)
                
            }
        
    }
    
    // MARK: Get All Categories
    // Retrieves all categories from the database.
    @Sendable
    func getAllCategories(req: Request) throws -> EventLoopFuture<[Category]> {
        
        // Query the database to get all categories
        Category.query(on: req.db).all()
        
    }

    // MARK: Get Category By ID
    // Retrieves a specific category by its ID from the database.
    @Sendable
    func getCategoryByID(req: Request) throws -> EventLoopFuture<Category> {
        
        // Find the category by its ID and return it
        Category.find(req.parameters.get("categoryID"), on: req.db)
            .unwrap(or: Abort(.notFound))
        
    }
    
}
