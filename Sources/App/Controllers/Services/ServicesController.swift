//
//  File.swift
//  
//
//  Created by Alejandro Alberto Gavira García on 20/7/24.
//

import Vapor
import Fluent

// MARK: - ServicesController
struct ServicesController: RouteCollection {
    
    // MARK: Override
    func boot(routes: RoutesBuilder) throws {
        
        routes.group("services") { builder in
            
            builder.get(use: getAllServices)
//            builder.get(":categoryID", use: getCategoryByID)
                
            }
        
    }
    
    // MARK: - Get All Categories
    @Sendable
    func getAllServices(req: Request) throws -> EventLoopFuture<[Services]> {
        
        Services.query(on: req.db).all()
        
    }
    
}

