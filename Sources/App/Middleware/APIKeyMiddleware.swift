//
//  APIKeyMiddleware.swift
//
//
//  Created by Jose Bueno Cruz on 10/7/24.
//

import Vapor

// MARK: - ApiKeyMiddleware
final class APIKeyMiddleware: AsyncMiddleware {
    
    // MARK: Respond
    // Middleware function to handle requests and validate the API key.
    func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        
        // Retrieve the API key from the request headers
        guard let apiKey = request.headers.first(name: "SSH-ApiKey") else {
            throw Abort(.badRequest, reason: "SSH-ApiKey header is missing")
        }
        
        // Retrieve the expected API key from environment variables
        guard let envApiKey = Environment.process.API_KEY else {
            throw Abort(.failedDependency)
        }
        
        // Compare the provided API key with the expected API key
        guard apiKey == envApiKey else {
            throw Abort(.unauthorized, reason: "Invalid API Key")
        }
        
        // Proceed to the next responder if the API key is valid
        return try await next.respond(to: request)
        
    }
    
}
