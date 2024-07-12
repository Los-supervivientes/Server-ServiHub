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
            builder.post("profsignup", use: profSignUp)
            
            
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
    
    @Sendable
    func profSignUp(req: Request) async throws -> ProfUser.Public {
        
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
        
        
        return ProfUser.Public(id: profUser.id?.uuidString ?? "", name: profUser.name, 
                               firstSurname: profUser.firstSurname, secondSurname: profUser.secondSurname ?? "",
                               mobile: profUser.mobile, email: profUser.email, street: profUser.street,
                               city: profUser.city, state: profUser.state, postalCode: profUser.postalCode,
                               country: profUser.country, categoryBusiness: profUser.categoryBusiness,
                               companyName: profUser.companyName, nif: profUser.nif)
    }
    
}
