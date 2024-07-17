//
//  File.swift
//  
//
//  Created by Jose Bueno Cruz on 17/7/24.
//

import Vapor

// MARK: - ProfUserUpdateController
struct ProfUsersController: RouteCollection {
    
    // MARK: Override
    func boot(routes: any RoutesBuilder) throws {
        
        routes.group("users") { builder in
            
            builder.group(JWTToken.authenticator(), JWTToken.guardMiddleware()) { builder in
                
                builder.get("getprofuser", ":userID", use: getProfUserByID)
                builder.put("updateprofuser", ":userID", use: updateProfUser)
                builder.get("getallprofusers", use: getAllUsersProf)
                
            }
            
        }
        
    }
    
    // MARK: Get ProfUser by ID
    @Sendable
    func getProfUserByID(req: Request) async throws -> ProfUser.Public {
        
        // Unpack userid parameter
        let userID = req.parameters.get("userID", as: UUID.self)
        
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
    
    // MARK: Put Update ProfUser
    @Sendable
    func updateProfUser(req: Request) throws -> EventLoopFuture<ProfUser.Public> {
        
        let updateData = try req.content.decode(ProfUser.Update.self)
        try ProfUser.Update.validate(content: req)
        
        return ProfUser.find(req.parameters.get("userID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { user in
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
    
}

