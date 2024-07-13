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
        
        routes.group("profauth") { builder in
            
            builder.post("profsignup", use: profSignUp)
            
            builder.group(ProfUser.authenticator(), ProfUser.guardMiddleware()) { builder in
                
                builder.get("profsignin", use: profSignIn)
                
            }
            
            builder.group(JWTToken.authenticator(), JWTToken.guardMiddleware()) { builder in
                
                builder.get("refresh", use: refresh)
                
            }
            
        }
        
    }
    
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
        
        
        // JWT Tokens
        let tokens = JWTToken.generateTokens(user: profUser.id!)
        let accesSigned = try req.jwt.sign(tokens.access)
        let refreshSigned = try req.jwt.sign(tokens.refresh)
        
        return JWTToken.Public(accessToken: accesSigned, refreshToken: refreshSigned)
    }
    
    @Sendable
    func profSignIn(req: Request) async throws -> JWTToken.Public {
        
        let user = try req.auth.require(ProfUser.self)
        
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

