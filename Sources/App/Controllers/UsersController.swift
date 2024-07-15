//
//  UserUpdateController.swift
//
//
//  Created by Jose Bueno Cruz on 15/7/24.
//

import Vapor

// MARK: - UserUpdateController
struct UsersController: RouteCollection {
    
    // MARK: Override
    func boot(routes: any RoutesBuilder) throws {
        
        routes.group("users") { builder in
            
            builder.group(JWTToken.authenticator(), JWTToken.guardMiddleware()) { builder in
                
                builder.get("getallusers", use: getAllUsers)
                builder.get("getallprofusers", use: getAllUsersProf)
                builder.get("getuser", use: getUserByID)
                builder.get("getprofuser", use: getProfUserByID)

                
            }
            
        }
        
    }
    
    // MARK: GetAllUsers
    @Sendable
    func getAllUsers(req: Request) async throws -> [User.Public] {
        
        let users = try await User.self.query(on: req.db)
            .all()
        
        return users.map { user in
            User.Public(id: user.id!.uuidString, name: user.name, firstSurname: user.firstSurname,
                            secondSurname: user.secondSurname ?? "", mobile: user.mobile, email: user.email)
                        
        }
        
    }
    
    // MARK: GetAllProfUsers
    @Sendable
    func getAllUsersProf(req: Request) async throws -> [ProfUser.Public] {
        
        let users = try await ProfUser.query(on: req.db)
            .all()
        
        return users.map { user in
            ProfUser.Public(id: user.id!.uuidString, name: user.name, firstSurname: user.firstSurname, 
                            secondSurname: user.secondSurname ?? "", mobile: user.mobile, email: user.email,
                            street: user.street, city: user.city, state: user.state, postalCode: user.postalCode,
                            country: user.country, categoryBusiness: user.categoryBusiness,
                            companyName: user.companyName, nif: user.nif)
                        
        }
        
    }
    
    
    // MARK: Get User by ID
    @Sendable
    func getUserByID(req: Request) async throws -> User.Public {
        
        // Unpack userid parameter
        
        guard let userIDString: String = req.query["userID"],
              let userID = UUID(uuidString: userIDString) else {
            throw Abort(.badRequest)
        }
        
        // Search the user in the database by ID
        guard let user = try await User.find(userID, on: req.db) else {
            throw Abort(.notFound)
        }
        
        // Return the public data of the found user
        return User.Public(id: user.id!.uuidString, name: user.name, firstSurname: user.firstSurname,
                           secondSurname: user.secondSurname ?? "", mobile: user.mobile, email: user.email)
    }
    
    // MARK: Get ProfUser by ID
    @Sendable
    func getProfUserByID(req: Request) async throws -> ProfUser.Public {
        
        // Unpack userid parameter
        
        guard let userIDString: String = req.query["userID"],
              let userID = UUID(uuidString: userIDString) else {
            throw Abort(.badRequest)
        }
        
        // Search the user in the database by ID
        guard let user = try await ProfUser.find(userID, on: req.db) else {
            throw Abort(.notFound)
        }
        
        // Return the public data of the found user
        return ProfUser.Public(id: user.id!.uuidString, name: user.name, firstSurname: user.firstSurname,
                               secondSurname: user.secondSurname ?? "", mobile: user.mobile, email: user.email,
                               street: user.street, city: user.city, state: user.state, postalCode: user.postalCode,
                               country: user.country, categoryBusiness: user.categoryBusiness,
                               companyName: user.companyName, nif: user.nif)
    }
    
    
    @Sendable
    func updateUser(req: Request) async throws -> User {
        
        let user = try req.auth.require(User.self)
        let input = try req.content.decode(UserUpdateInput.self)

        user.name = input.name
        user.firstSurname = input.firstSurname
        user.secondSurname = input.secondSurname
        user.mobile = input.mobile
        user.email = input.email
        user.password = input.password

        try await user.save(on: req.db)

        return user
        
    }
    
}

struct UserUpdateInput: Content {
    var name: String
    var firstSurname: String
    var secondSurname: String?
    var mobile: String
    var email: String
    var password: String
}
