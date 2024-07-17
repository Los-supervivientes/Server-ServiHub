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
                
                builder.get("getuser", ":userID", use: getUserByID)
                builder.put("updateuser", ":userID", use: updateUser)
                builder.get("getallusers", use: getAllUsers)
                
            }
            
        }
        
    }
    
    // MARK: Get User by ID
    @Sendable
    func getUserByID(req: Request) async throws -> User.Public {
        
        // Unpack userid parameter
        let userID = req.parameters.get("userID", as: UUID.self)
        
        // Search the user in the database by ID
        guard let user = try await User.find(userID, on: req.db) else {
            throw Abort(.notFound)
        }
        
        // Return the public data of the found user
        return User.Public(id: user.id!.uuidString, name: user.name, firstSurname: user.firstSurname,
                           secondSurname: user.secondSurname ?? "", mobile: user.mobile, email: user.email)
    }
    
    // MARK: Put Update User
    @Sendable
    func updateUser(req: Request) throws -> EventLoopFuture<User.Public> {
        let updateData = try req.content.decode(User.Update.self)
        try User.Update.validate(content: req)
        
        return User.find(req.parameters.get("userID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { user in
                user.name = updateData.name
                user.firstSurname = updateData.firstSurname
                user.secondSurname = updateData.secondSurname
                user.mobile = updateData.mobile
                return user.save(on: req.db).map {
                    User.Public(
                        id: user.id?.uuidString ?? "",
                        name: user.name,
                        firstSurname: user.firstSurname,
                        secondSurname: user.secondSurname ?? "",
                        mobile: user.mobile,
                        email: user.email
                    )
                }
            }
    }
    
    // MARK: Get All Users
    @Sendable
    func getAllUsers(req: Request) async throws -> [User.Public] {
        
        let users = try await User.self.query(on: req.db)
            .all()
        
        return users.map { user in
            User.Public(id: user.id!.uuidString, name: user.name, firstSurname: user.firstSurname,
                            secondSurname: user.secondSurname ?? "", mobile: user.mobile, email: user.email)
                        
        }
        
    }
    
    
}

