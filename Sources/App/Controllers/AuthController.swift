//
//  AuthController.swift
//
//
//  Created by Jose Bueno Cruz on 10/7/24.
//

import Vapor

// MARK: - AuthController
struct AuthController: RouteCollection {
    
    // MARK: Override
    func boot(routes: any Vapor.RoutesBuilder) throws {
        routes.group("auth") { builder in
            builder.post("signup", use: signUp)
        }
    }
    
    // MARK: Routes
    @Sendable
    func signUp(req: Request) async throws -> String {
        
        
        return "Sign up"
    }
    
    
}
