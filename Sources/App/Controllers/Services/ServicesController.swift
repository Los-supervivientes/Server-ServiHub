//
//  ServicesController.swift
//
//
//  Created by Alejandro Alberto Gavira García on 20/7/24.
//

import Vapor

// MARK: - ServicesController
struct ServicesController: RouteCollection {
    
    // MARK: Override
    func boot(routes: RoutesBuilder) throws {
        
        
        routes.group(JWTToken.authenticator(), JWTToken.guardMiddleware()) { builder in
            
            builder.get("services", use: getAllServices)
            
        }
        
    }
    
    // MARK: - Get All Services
    @Sendable
    func getAllServices(req: Request) throws -> EventLoopFuture<[Service]> {
        
        Service.query(on: req.db).all()
        
    }
    
}

