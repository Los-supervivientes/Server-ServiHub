//
//  AuxiliarController.swift
//
//
//  Created by Jose Bueno Cruz on 9/7/24.
//

import Vapor

// MARK: - VersionController
struct VersionController: RouteCollection {
    
    // MARK: Route Registration
    // Registers routes for the `VersionController`.
    func boot(routes: any Vapor.RoutesBuilder) throws {
        
        // Register a GET route for "/version" that uses the `needsUpdate` function
        routes.get("version", use: needsUpdate)
        
    }
    
    // MARK: Routes Handlers
    // Handles the request to check if an update is needed based on the current version.
    @Sendable
    func needsUpdate(req: Request) async throws -> Version {
        
        // Retrieve the 'current' version from the query parameters
        guard let current: String = req.query["current"] else {
            throw Abort(.badRequest)
        }
        
        // Define the live version available in the App Store
        let appStoreLiveVersion = "1.0.8"
        
        // Check if the current version is less than the live version, indicating an update is needed
        let needsUpdate = current < appStoreLiveVersion
        
        // Return a Version object with the current version, live version, and update status
        return Version(current: current, live: appStoreLiveVersion, needsUpdate: needsUpdate)
        
    }
    
}
