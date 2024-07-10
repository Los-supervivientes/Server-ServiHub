import Fluent
import Vapor

// MARK: - Routes
func routes(_ app: Application) throws {
    
    // MARK: Group Api
    try app.group("api") { builder in
        
        try builder.group(APIKeyMiddleware()) { builder in
            
            try builder.register(collection: AuxiliarController())
        }
        
    }
    
}
