//
//  ServicesController.swift
//
//
//  Created by Jose Bueno Cruz on 20/7/24.
//

import Vapor

// MARK: - ServicesController
struct ServicesController: RouteCollection {
    
    // MARK: Override
    func boot(routes: RoutesBuilder) throws {
        
        
        routes.group("services") { builder in
            
            builder.group(JWTToken.authenticator(), JWTToken.guardMiddleware()) { builder in
                
                builder.get(use: getAllHandler)
                builder.get(":serviceID", use: getHandler)
                builder.get("user", ":profUserID", use: getServicesForUserHandler)
                builder.post(use: createHandler)
                builder.put(":serviceID", use: updateHandler)
                builder.delete(":serviceID", use: deleteHandler)
                
            }
                
        }
        
    }
    
    
    // MARK: - Get All Services
    @Sendable
    func getAllHandler(_ req: Request) throws -> EventLoopFuture<[Service]> {
        
        Service.query(on: req.db).with(\.$category).with(\.$profUser).all()
        
    }
    
    // MARK: - Get Services for ProfUser
    @Sendable
    func getHandler(_ req: Request) throws -> EventLoopFuture<Service> {
        
        Service.find(req.parameters.get("serviceID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { service in
                service.$category.load(on: req.db).and(service.$profUser.load(on: req.db)).map { _ in
                    return service
                }
                
            }
        
    }
    
    // MARK: - Get All Services for Prof User
    @Sendable
    func getServicesForUserHandler(req: Request) async throws -> [Service] {
        
        // Unpack id profUser
        guard let profUserID = req.parameters.get("profUserID", as: UUID.self) else {
            throw Abort(.badRequest)
        }

        // Find profUser
        guard let profUser = try await ProfUser.find(profUserID, on: req.db) else {
            throw Abort(.notFound, reason: "ProfUser not found")
        }

        // Load services profuser
        return try await profUser.$services.query(on: req.db)
            .with(\.$category)
            .with(\.$profUser)
            .all()
    }
    
    // MARK: - Create Service
    @Sendable
    func createHandler(_ req: Request) throws -> EventLoopFuture<Service> {
        
        let service = try req.content.decode(Service.self)
        return service.save(on: req.db).map { service }
        
    }
    
    // MARK: - Udpdate Service
    @Sendable
    func updateHandler(_ req: Request) throws -> EventLoopFuture<Service> {
        
        let updatedService = try req.content.decode(Service.self)
        
        return Service.find(req.parameters.get("serviceID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { service in
                service.name = updatedService.name
                service.note = updatedService.note
                service.distance = updatedService.distance
                service.$category.id = updatedService.$category.id
                service.$profUser.id = updatedService.$profUser.id
                return service.save(on: req.db).map { service }
            }
    }
    
    // MARK: - Delete Service
    @Sendable
    func deleteHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        
        Service.find(req.parameters.get("serviceID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { service in
                service.delete(on: req.db)
            }
            .transform(to: .noContent)
        
    }
    
}
