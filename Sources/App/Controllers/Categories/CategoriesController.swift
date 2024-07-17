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
    func boot(routes: RoutesBuilder) throws {
        
        routes.group("categories") { builder in
            
            builder.group(JWTToken.authenticator(), JWTToken.guardMiddleware()) { builder in
                
                builder.get(use: getAllCategories)
                builder.get(":categoryID", use: getCategoryByID)
                
            }
            
        }
        
    }
    
    @Sendable
    func getAllCategories(req: Request) throws -> EventLoopFuture<[Category]> {
        
        Category.query(on: req.db).with(\.$children).all()
        
    }


    @Sendable
    func getCategoryByID(req: Request) throws -> EventLoopFuture<Category> {
        
        Category.find(req.parameters.get("categoryID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { category in
                category.$children.load(on: req.db).map { category }
            }
        
    }
    
}
