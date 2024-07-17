//
//  AuthControllerProf.swift
//
//
//  Created by Jose Bueno Cruz on 13/7/24.
//

import Vapor

// MARK: - AuthController
struct AuthControllerProf: RouteCollection {
    
    // MARK: Override
    func boot(routes: any Vapor.RoutesBuilder) throws {
        
        routes.group("auth") { builder in
            
            builder.post("profsignup", use: profSignUp)
            
            builder.group(ProfUser.authenticator(), ProfUser.guardMiddleware()) { builder in
                
                builder.get("profsignin", use: profSignIn)
                
            }
            
            builder.group(JWTToken.authenticator(), JWTToken.guardMiddleware()) { builder in
                
                builder.get("profrefresh", use: profRefresh)
                
            }
            
        }
        
    }
    
    // MARK: ProfSignUp
    @Sendable
    func profSignUp(req: Request) async throws -> JWTToken.Public {
        
        // Validate user
        try ProfUser.Create.validate(content: req)
        
        // Decode body data
        let userCreate = try req.content.decode(ProfUser.Create.self)
        let hashed = try req.password.hash(userCreate.password)
    
        // Save user to DB
        let profUser = ProfUser(name: userCreate.name, firstSurname: userCreate.firstSurname,
                                mobile: userCreate.mobile, email: userCreate.email, password: hashed,
                                street: userCreate.street, city: userCreate.city, state: userCreate.state,
                                postalCode: userCreate.postalCode, country: userCreate.country,
                                categoryBusiness: userCreate.categoryBusiness,
                                companyName: userCreate.companyName, nif: userCreate.nif)
        try await profUser.create(on: req.db)
        
        return try generateTokens(req: req, user: profUser)
        
    }
    
    // MARK: ProfSignIn
    @Sendable
    func profSignIn(req: Request) async throws -> JWTToken.Public {
        
        let profUser = try req.auth.require(ProfUser.self)
        
        return try generateTokens(req: req, user: profUser)
        
    }
    
    // MARK: Refresh
    @Sendable
    func profRefresh(req: Request) async throws -> JWTToken.Public {
        
        // Get token
        let token = try req.auth.require(JWTToken.self)
        
        // Verify token type
        guard token.type == .refresh else {
            throw Abort(.methodNotAllowed, reason: "Token type is invalid. You need a refresh token.")
        }
        
        let userID = UUID(token.sub.value)
        guard let profUser = try await ProfUser.find(userID, on: req.db) else {
            throw Abort(.unauthorized)
        }
        
        return try generateTokens(req: req, user: profUser)
        
    }
    
}

// MARK: - Extension AuthControllerProf
extension AuthControllerProf {
    
    // MARK: GenerateTokens
    func generateTokens(req: Request, user: ProfUser) throws -> JWTToken.Public {
        
        // JWT Tokens
        let tokens = JWTToken.generateTokens(user: user.id!)
        let accesSigned = try req.jwt.sign(tokens.access)
        let refreshSigned = try req.jwt.sign(tokens.refresh)
        
        return JWTToken.Public(accessToken: accesSigned, refreshToken: refreshSigned, userID: user.id)
        
    }
}

