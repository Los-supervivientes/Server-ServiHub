//
//  APIKeyMiddleware.swift
//
//
//  Created by Jose Bueno Cruz on 10/7/24.
//

import Vapor

final class APIKeyMiddleware: AsyncMiddleware {
    
    func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        
        // Get client API key
        guard let apiKey = request.headers.first(name: "SSH-ApiKey") else {
            throw Abort(.badRequest, reason: "SSH-ApiKey header is missing")
        }
        
        // Get API Key from environment
        guard let envApiKey = Environment.process.API_KEY else {
            throw Abort(.failedDependency)
        }
        
        guard apiKey == envApiKey else {
            throw Abort(.unauthorized, reason: "Invalid API Key")
        }

        return try await next.respond(to: request)
        
    }
    
}
