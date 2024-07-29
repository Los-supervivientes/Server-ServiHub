import Fluent
import Vapor

// MARK: - Routes
func routes(_ app: Application) throws {
    
    // MARK: Group Api
    // Create a route group with the path prefix "api".
    try app.group("api") { builder in
        
        // Apply APIKeyMiddleware for API key authentication.
        try builder.group(APIKeyMiddleware()) { builder in
            
            // Register various controllers for handling specific routes.
            try builder.register(collection: VersionController())    // API versioning
            try builder.register(collection: AuthController())       // User authentication
            try builder.register(collection: AuthControllerProf())   // Professional user authentication
            try builder.register(collection: UsersController())      // General user management
            try builder.register(collection: ProfUsersController())  // Professional user management
            try builder.register(collection: CategoryController())   // Category management
            try builder.register(collection: ServicesController())   // Services management
            
        }
        
    }
    
}
