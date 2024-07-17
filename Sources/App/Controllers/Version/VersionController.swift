//
//  AuxiliarController.swift
//
//
//  Created by Jose Bueno Cruz on 9/7/24.
//

import Vapor

// MARK: - AuxliarController
struct VersionController: RouteCollection {
    
    // MARK: Override
    func boot(routes: any Vapor.RoutesBuilder) throws {
        
        routes.get("version", use: needsUpdate)
        
    }
    
    // MARK: Routes
    @Sendable
    func needsUpdate(req: Request) async throws -> Version {
        
        guard let current: String = req.query["current"] else {
            throw Abort(.badRequest)
        }
        
        let appStoreLiveVersion = "1.0.8"
        let needsUpdate = current < appStoreLiveVersion
        
        return Version(current: current, live: appStoreLiveVersion, needsUpdate: needsUpdate)
        
    }
    
}
