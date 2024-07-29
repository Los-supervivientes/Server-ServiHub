//
//  ServicesController.swift
//
//
//  Created by Jose Bueno Cruz on 20/7/24.
//

import Vapor

// MARK: - ServicesController
struct ServicesController: RouteCollection {
    
    // MARK: Route Registration
    // Registers routes for service operations.
    func boot(routes: RoutesBuilder) throws {
        
        
        routes.group("services") { builder in
            
            // Routes requiring JWT token authentication
            builder.group(JWTToken.authenticator(), JWTToken.guardMiddleware()) { builder in
                
                builder.get(use: getAllServices)
                builder.get(":serviceID", use: getServiceByID)
                builder.get("user", ":profUserID", use: getServicesForProfUser)
                builder.post(use: createService)
                builder.put(":serviceID", use: updateService)
                builder.delete(":serviceID", use: deleteService)
                
            }
                
        }
        
    }
    
    
    // MARK: Get All Services
    // Retrieves all services from the database,
    // including related category and professional user information.
    @Sendable
    func getAllServices(_ req: Request) throws -> EventLoopFuture<[Service]> {
        
        // Query all services with their associated category and professional user
        Service.query(on: req.db).with(\.$category).with(\.$profUser).all()
        
    }
    
    // MARK: Get Service by ID
    // Retrieves a specific service by its ID, including related category and professional user information.
    @Sendable
    func getServiceByID(_ req: Request) throws -> EventLoopFuture<Service> {
        
        // Find service by ID and return it with associated category and professional user
        Service.find(req.parameters.get("serviceID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { service in
                service.$category.load(on: req.db).and(service.$profUser.load(on: req.db)).map { _ in
                    return service
                }
                
            }
        
    }
    
    // MARK: Get All Services for ProfUser
    // Retrieves all services associated with a specific professional user.
    @Sendable
    func getServicesForProfUser(req: Request) async throws -> [Service] {
        
        // Extract professional user ID from request parameters
        guard let profUserID = req.parameters.get("profUserID", as: UUID.self) else {
            throw Abort(.badRequest)
        }

        // Find professional user by ID and retrieve their services
        guard let profUser = try await ProfUser.find(profUserID, on: req.db) else {
            throw Abort(.notFound, reason: "ProfUser not found")
        }

        // Return services associated with the professional user
        return try await profUser.$services.query(on: req.db)
            .with(\.$category)
            .with(\.$profUser)
            .all()
    }
    
    // MARK: Create Service
    /// Creates a new service and saves it to the database.
    @Sendable
    func createService(_ req: Request) throws -> EventLoopFuture<Service> {
        
        // Decode service creation data from request body
        let serviceData = try req.content.decode(Service.CreateUpdate.self)
        
        // Create and save the new service in the database
        let service = Service(name: serviceData.name,
                              note: serviceData.note,
                              distance: serviceData.distance,
                              categoryID: serviceData.categoryID,
                              profUserID: serviceData.profUserID)
        
        return service.save(on: req.db).map { service }
    }
    
    // MARK: Update Service
    // Updates an existing service with new data and saves it to the database.
    @Sendable
    func updateService(_ req: Request) throws -> EventLoopFuture<Service> {
        
        // Decode updated service data from request body
        let updatedService = try req.content.decode(Service.CreateUpdate.self)
        
        // Find service by ID, update its fields, and save changes to the database
        return Service.find(req.parameters.get("serviceID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { service in
                service.name = updatedService.name
                service.note = updatedService.note
                service.distance = updatedService.distance
                service.$category.id = updatedService.categoryID
                service.$profUser.id = updatedService.profUserID
                return service.save(on: req.db).map { service }
            }
    }
    
    // MARK: - Delete Service
    // Deletes a service from the database by its ID.
    @Sendable
    func deleteService(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        
        // Find and delete the service by ID
        Service.find(req.parameters.get("serviceID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { service in
                service.delete(on: req.db)
            }
            .transform(to: .noContent)
        
    }
    
}
