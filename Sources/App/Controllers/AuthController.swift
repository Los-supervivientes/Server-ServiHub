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
            
            builder.group(User.authenticator(), User.guardMiddleware()) { builder in
                
                builder.get("signin", use: signIn)
                
            }
            
            builder.group(JWTToken.authenticator(), JWTToken.guardMiddleware()) { builder in
                
                builder.get("refresh", use: refresh)
                
            }
            
        }
        
    }
    
    // MARK: Routes
    @Sendable
    func signUp(req: Request) async throws -> JWTToken.Public {
        
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
        
        // JWT Tokens
        let tokens = JWTToken.generateTokens(user: user.id!)
        let accesSigned = try req.jwt.sign(tokens.access)
        let refreshSigned = try req.jwt.sign(tokens.refresh)
        
        return JWTToken.Public(accessToken: accesSigned, refreshToken: refreshSigned)
        
    }
    
    @Sendable
    func signIn(req: Request) async throws -> JWTToken.Public {
        
        let user = try req.auth.require(User.self)
        
        // JWT Tokens
        let tokens = JWTToken.generateTokens(user: user.id!)
        let accesSigned = try req.jwt.sign(tokens.access)
        let refreshSigned = try req.jwt.sign(tokens.refresh)
        
        return JWTToken.Public(accessToken: accesSigned, refreshToken: refreshSigned)
        
    }
    
    @Sendable
    func refresh(req: Request) async throws -> JWTToken.Public {
        
        return JWTToken.Public(accessToken: "", refreshToken: "")
        
    }
    
}
