//
//  ProfUsersController.swift
//  
//
//  Created by Jose Bueno Cruz on 17/7/24.
//

import Vapor

// MARK: - ProfUserUpdateController
struct ProfUsersController: RouteCollection {
    
    // MARK: Route Registration
    // Registers routes for professional user operations.
    func boot(routes: any RoutesBuilder) throws {
        
        routes.group("users") { builder in
            
            // Routes requiring JWT token authentication
            builder.group(JWTToken.authenticator(), JWTToken.guardMiddleware()) { builder in
                
                builder.get("getprofuser", ":userID", use: getProfUserByID)
                builder.put("updateprofuser", ":userID", use: updateProfUser)
                builder.get("getallprofusers", use: getAllUsersProf)
                builder.delete("deleteprofuser", ":userID", use: deleteProfUser)
                
            }
            
        }
        
    }
    
    // MARK: Get Professional User by ID
    // Retrieves a specific professional user by their ID.
    @Sendable
    func getProfUserByID(req: Request) async throws -> ProfUser.Public {
        
        // Extract userID parameter from the request
        let userID = req.parameters.get("userID", as: UUID.self)
        
        // Find professional user by ID
        guard let user = try await ProfUser.find(userID, on: req.db) else {
            throw Abort(.notFound)
        }
        
        // Return the public data of the found professional user
        return ProfUser.Public(id: user.id!.uuidString, name: user.name, firstSurname: user.firstSurname,
                               secondSurname: user.secondSurname ?? "", mobile: user.mobile, email: user.email,
                               street: user.street, city: user.city, state: user.state, postalCode: user.postalCode,
                               country: user.country, categoryBusiness: user.categoryBusiness,
                               companyName: user.companyName, nif: user.nif)
    }
    
    // MARK: Update Professional User
    // Updates an existing professional user's information and saves the changes to the database.
    @Sendable
    func updateProfUser(req: Request) throws -> EventLoopFuture<ProfUser.Public> {
        
        // Decode the updated user data from the request body
        let updateData = try req.content.decode(ProfUser.Update.self)
        try ProfUser.Update.validate(content: req)
        
        return ProfUser.find(req.parameters.get("userID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { user in
                // Update user properties with the new data
                user.name = updateData.name
                user.firstSurname = updateData.firstSurname
                user.secondSurname = updateData.secondSurname
                user.mobile = updateData.mobile
                user.street = updateData.street
                user.city = updateData.city
                user.state = updateData.state
                user.postalCode = updateData.postalCode
                user.country = updateData.country
                user.categoryBusiness = updateData.categoryBusiness
                user.companyName = updateData.companyName
                user.nif = updateData.nif
                
                // Save changes to the database and return updated data
                return user.save(on: req.db).map {
                    ProfUser.Public(
                        id: user.id?.uuidString ?? "",
                        name: user.name,
                        firstSurname: user.firstSurname,
                        secondSurname: user.secondSurname ?? "",
                        mobile: user.mobile,
                        email: user.email,
                        street: user.street,
                        city: user.city,
                        state: user.state,
                        postalCode: user.postalCode,
                        country: user.country,
                        categoryBusiness: user.categoryBusiness,
                        companyName: user.companyName,
                        nif: user.nif
                        
                    )
                }
                
            }
        
    }
    

    // MARK: Get All Professional Users
    // Retrieves all professional users from the database.
    @Sendable
    func getAllUsersProf(req: Request) async throws -> [ProfUser.Public] {
        
        // Retrieve all professional users
        let users = try await ProfUser.query(on: req.db)
            .all()
        
        // Map the users to their public data representations
        return users.map { user in
            ProfUser.Public(id: user.id!.uuidString, name: user.name, firstSurname: user.firstSurname,
                            secondSurname: user.secondSurname ?? "", mobile: user.mobile, email: user.email,
                            street: user.street, city: user.city, state: user.state, postalCode: user.postalCode,
                            country: user.country, categoryBusiness: user.categoryBusiness,
                            companyName: user.companyName, nif: user.nif)
                        
        }
        
    }
    
    // MARK: Delete Professional User
    // Deletes a professional user by their ID from the database.
    @Sendable
    func deleteProfUser(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        
        // Find and delete the professional user by ID
        ProfUser.find(req.parameters.get("userID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { user in
                user.delete(on: req.db)
            }
            .transform(to: .noContent)
        
    }
    
}

