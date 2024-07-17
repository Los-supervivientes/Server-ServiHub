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
        
        // Validate content
        try User.Create.validate(content: req)
        
        // Decode body data
        let userCreate = try req.content.decode(User.Create.self)
        let hashed = try req.password.hash(userCreate.password)
    
        // Save user to DB
        let user = User(name: userCreate.name, firstSurname: userCreate.firstSurname,
                        secondSurname: userCreate.secondSurname, mobile: userCreate.mobile,
                        email: userCreate.email, password: hashed)
        try await user.create(on: req.db)
        
        return try generateTokens(req: req, user: user)
        
    }
    
    // MARK: SignIn
    @Sendable
    func signIn(req: Request) async throws -> JWTToken.Public {
        
        let user = try req.auth.require(User.self)
        
        return try generateTokens(req: req, user: user)
        
    }
    
    // MARK: Refresh
    @Sendable
    func refresh(req: Request) async throws -> JWTToken.Public {
        
        // Get token
        let token = try req.auth.require(JWTToken.self)
        
        // Verify token type
        guard token.type == .refresh else {
            throw Abort(.methodNotAllowed, reason: "Token type is invalid. You need a refresh token.")
        }
        
        let userID = UUID(token.sub.value)
        guard let user = try await User.find(userID, on: req.db) else {
            throw Abort(.unauthorized)
        }
        
        return try generateTokens(req: req, user: user)
        
    }
    
}

// MARK: - Extension AuthController
extension AuthController {
    
    // MARK: GenerateTokens
    func generateTokens(req: Request, user: User) throws -> JWTToken.Public {
        
        // JWT Tokens
        let tokens = JWTToken.generateTokens(user: user.id!)
        let accesSigned = try req.jwt.sign(tokens.access)
        let refreshSigned = try req.jwt.sign(tokens.refresh)
        
        return JWTToken.Public(accessToken: accesSigned, refreshToken: refreshSigned, userID: user.id)
        
    }
}

