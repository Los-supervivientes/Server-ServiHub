import Fluent
import Vapor

// MARK: - Routes
func routes(_ app: Application) throws {
    
    // MARK: Group Api
    try app.group("api") { builder in
        
        try builder.group(APIKeyMiddleware()) { builder in
            
            try builder.register(collection: VersionController())
            try builder.register(collection: AuthController())
            try builder.register(collection: AuthControllerProf())
            try builder.register(collection: UsersController())
            try builder.register(collection: ProfUsersController())
            try builder.register(collection: CategoryController())
            try builder.register(collection: ServicesController())
            
        }
        
    }
    
}
