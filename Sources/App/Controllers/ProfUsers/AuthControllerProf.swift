//
//  AuthControllerProf.swift
//
//
//  Created by Jose Bueno Cruz on 13/7/24.
//

import Vapor

// MARK: - AuthController
struct AuthControllerProf: RouteCollection {
    
    // MARK: Route Registration
    // Registers routes for professional user authentication operations.
    func boot(routes: any Vapor.RoutesBuilder) throws {
        
        routes.group("auth") { builder in
            
            builder.post("profsignup", use: profSignUp)
            
            // Routes requiring professional user authentication
            builder.group(ProfUser.authenticator(), ProfUser.guardMiddleware()) { builder in
                
                builder.get("profsignin", use: profSignIn)
                
            }
            
            // Routes requiring JWT token authentication
            builder.group(JWTToken.authenticator(), JWTToken.guardMiddleware()) { builder in
                
                builder.get("profrefresh", use: profRefresh)
                
            }
            
        }
        
    }
    
    // MARK: Professional User SignUp
    // Signs up a new professional user by validating input, creating a new user, and generating JWT tokens.
    @Sendable
    func profSignUp(req: Request) async throws -> JWTToken.Public {
        
        // Validate the content of the request
        try ProfUser.Create.validate(content: req)
        
        // Decode the body data to extract user details
        let userCreate = try req.content.decode(ProfUser.Create.self)
        let hashed = try req.password.hash(userCreate.password)
    
        // Create a new professional user instance and save to the database
        let profUser = ProfUser(name: userCreate.name, firstSurname: userCreate.firstSurname,
                                mobile: userCreate.mobile, email: userCreate.email, password: hashed,
                                street: userCreate.street, city: userCreate.city, state: userCreate.state,
                                postalCode: userCreate.postalCode, country: userCreate.country,
                                categoryBusiness: userCreate.categoryBusiness,
                                companyName: userCreate.companyName, nif: userCreate.nif)
        try await profUser.create(on: req.db)
        
        // Generate and return JWT tokens for the new professional user
        return try generateTokens(req: req, user: profUser)
        
    }
    
    // MARK: Professional User SignIn
    // Signs in an existing professional user by validating authentication and generating JWT tokens.
    @Sendable
    func profSignIn(req: Request) async throws -> JWTToken.Public {
        
        // Authenticate and retrieve the current professional user
        let profUser = try req.auth.require(ProfUser.self)
        
        // Generate and return JWT tokens for the authenticated professional user
        return try generateTokens(req: req, user: profUser)
        
    }
    
    // MARK: Refresh Tokens
    // Refreshes JWT tokens for an authenticated professional user using a refresh token.
    @Sendable
    func profRefresh(req: Request) async throws -> JWTToken.Public {
        
        // Retrieve the current JWT token from the request
        let token = try req.auth.require(JWTToken.self)
        
        // Verify that the token is a refresh token
        guard token.type == .refresh else {
            throw Abort(.methodNotAllowed, reason: "Token type is invalid. You need a refresh token.")
        }
        
        // Find the professional user associated with the refresh token
        let userID = UUID(token.sub.value)
        guard let profUser = try await ProfUser.find(userID, on: req.db) else {
            throw Abort(.unauthorized)
        }
        
        // Generate and return new JWT tokens for the professional user
        return try generateTokens(req: req, user: profUser)
        
    }
    
}

// MARK: - Extension AuthControllerProf
extension AuthControllerProf {
    
    // MARK: Generate JWT Tokens
    // Generates JWT tokens (access and refresh) for a professional user.
    func generateTokens(req: Request, user: ProfUser) throws -> JWTToken.Public {
        
        // Generate JWT tokens
        let tokens = JWTToken.generateTokens(user: user.id!)
        let accesSigned = try req.jwt.sign(tokens.access)
        let refreshSigned = try req.jwt.sign(tokens.refresh)
        
        // Return the signed tokens in a public JWTToken object
        return JWTToken.Public(accessToken: accesSigned, refreshToken: refreshSigned, userID: user.id)
        
    }
    
}

