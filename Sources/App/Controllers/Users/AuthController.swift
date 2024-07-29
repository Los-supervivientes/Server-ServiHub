//
//  AuthController.swift
//
//
//  Created by Jose Bueno Cruz on 10/7/24.
//

import Vapor

// MARK: - AuthController
struct AuthController: RouteCollection {
    
    // MARK: Route Registration
    // Registers routes for authentication operations.
    func boot(routes: any Vapor.RoutesBuilder) throws {
        
        routes.group("auth") { builder in
            
            builder.post("signup", use: signUp)
            
            // Routes requiring user authentication
            builder.group(User.authenticator(), User.guardMiddleware()) { Builder in
                
                Builder.get("signin", use: signIn)
                
            }
            
            // Routes requiring JWT token authentication
            builder.group(JWTToken.authenticator(), JWTToken.guardMiddleware()) { builder in
                
                builder.get("refresh", use: refresh)
                
            }
            
        }
        
    }
    
    // MARK: SignUp
    // Handles user signup by validating input, creating a new user, and generating tokens.
    @Sendable
    func signUp(req: Request) async throws -> JWTToken.Public {
        
        // Validate user creation data
        try User.Create.validate(content: req)
        
        // Decode user creation data from request body
        let userCreate = try req.content.decode(User.Create.self)
        let hashed = try req.password.hash(userCreate.password)
    
        // Create and save the new user in the database
        let user = User(name: userCreate.name, firstSurname: userCreate.firstSurname,
                        secondSurname: userCreate.secondSurname, mobile: userCreate.mobile,
                        email: userCreate.email, password: hashed)
        try await user.create(on: req.db)
        
        // Generate and return JWT tokens
        return try generateTokens(req: req, user: user)
        
    }
    
    // MARK: SignIn
    // Handles token refresh by verifying the provided refresh token and generating new tokens.
    @Sendable
    func signIn(req: Request) async throws -> JWTToken.Public {
        
        // Get authenticated user
        let user = try req.auth.require(User.self)
        
        // Generate and return JWT tokens
        return try generateTokens(req: req, user: user)
        
    }
    
    
    
    // MARK: Refresh
    // Handles token refresh by verifying the provided refresh token and generating new tokens.
    @Sendable
    func refresh(req: Request) async throws -> JWTToken.Public {
        
        // Get the refresh token from the request
        let token = try req.auth.require(JWTToken.self)
        
        // Ensure the token is a refresh token
        guard token.type == .refresh else {
            throw Abort(.methodNotAllowed, reason: "Token type is invalid. You need a refresh token.")
        }
        
        // Retrieve the user associated with the token
        let userID = UUID(token.sub.value)
        guard let user = try await User.find(userID, on: req.db) else {
            throw Abort(.unauthorized)
        }
        
        // Generate and return new JWT tokens
        return try generateTokens(req: req, user: user)
        
    }
    
}

// MARK: - Extension AuthController
extension AuthController {
    
    // MARK: GenerateTokens
    // Generates JWT tokens for a given user.
    func generateTokens(req: Request, user: User) throws -> JWTToken.Public {
        
        // Generate JWT tokens
        let tokens = JWTToken.generateTokens(user: user.id!)
        let accesSigned = try req.jwt.sign(tokens.access)
        let refreshSigned = try req.jwt.sign(tokens.refresh)
        
        // Return signed tokens and user ID
        return JWTToken.Public(accessToken: accesSigned, refreshToken: refreshSigned, userID: user.id)
        
    }
    
}




