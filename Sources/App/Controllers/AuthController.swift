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
    func signUp(req: Request) async throws -> User.Public {
        
        // Validate user
        try User.Create.validate(content: req)
        
        // Decode body data
        let userCreate = try req.content.decode(User.Create.self)
        let hashed = try req.password.hash(userCreate.password)
    
        // Save user to DB
        let user = User(name: userCreate.name, firstSurname: userCreate.firstSurname,
                        secondSurname: userCreate.secondSurname, mobile: userCreate.mobile,
                        email: userCreate.email, password: hashed)
        try await user.create(on: req.db)
        
        
        return User.Public(id: user.id?.uuidString ?? "", name: user.name, firstSurname: user.firstSurname,
                           secondSurname: user.secondSurname ?? "", mobile: user.mobile, email: user.email)
    }
    
}
