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
            
            // TODO: Only User Administrators
            builder.post(use: createCategory)
            builder.put(":categoryID", use: updateCategory)
            builder.delete(":categoryID", use: deleteCategory)
            
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
    
    // MARK: Create Category
     // Creates a new category in the database.
    @Sendable
     func createCategory(req: Request) throws -> EventLoopFuture<Category> {
         
         // Decode the category from the request body
         let categoryData = try req.content.decode(Category.CreateUpdate.self)
         
         // Create category from reques body
         let category = Category(name: categoryData.name)
         
         // Save the new category to the database
         return category.save(on: req.db).map { category }
         
     }
    
    // MARK: Update Category
    // Updates an existing category in the database.
    @Sendable
    func updateCategory(req: Request) throws -> EventLoopFuture<Category> {
        
        // Dedode updated category from reques body
        let updatedCategory = try req.content.decode(Category.CreateUpdate.self)

        // Find Category by ID, Update its fields, and save chages
        return Category.find(req.parameters.get("categoryID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { category in
                category.name = updatedCategory.name
                return category.save(on: req.db).map { category }
            }
        
    }
     
     // MARK: Delete Category
     // Deletes a category by its ID from the database.
    @Sendable
     func deleteCategory(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
         
         // Find and delete the category by its ID
         Category.find(req.parameters.get("categoryID"), on: req.db)
             .unwrap(or: Abort(.notFound))
             .flatMap { category in
                 // Check if there are any related services
                 return Service.query(on: req.db)
                     .filter(\.$category.$id == category.id!)
                     .first()
                     .flatMap { service in
                         if service != nil {
                             // If a related service is found, abort with a bad request error
                             return req.eventLoop.makeFailedFuture(Abort(.badRequest, reason: "Cannot delete category with related services."))
                         } else {
                             // Otherwise, delete the category
                             return category.delete(on: req.db).transform(to: .noContent)
                        }
                     }
             }
     }
    
}
