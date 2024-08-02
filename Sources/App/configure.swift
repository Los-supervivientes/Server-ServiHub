import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor
import JWT

// MARK: - Configure App
public func configure(_ app: Application) throws {

    // Retrieve and validate environment variables
    guard let jwtKey = Environment.get("JWT_KEY") else { fatalError("JWT Key not found")}
    guard let _ = Environment.process.API_KEY else {fatalError("JWT Key not found")}
    guard let dbURL = Environment.process.DATABASE_URL else {fatalError("DB URL not found")}
    guard let _ = Environment.process.APP_BUNDLE_ID else {fatalError("APP Bundle ID not found")}
        
    // Enable serving files from the public directory
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    // Configure JWT with the HS256 algorithm and the retrieved key
    app.jwt.signers.use(.hs256(key: jwtKey))
    
    // Set up the PostgreSQL database connection
    try app.databases.use(.postgres(url: dbURL), as: .psql)
    
    // Configure password hashing using bcrypt
    app.passwords.use(.bcrypt)
    
    // Add and run database migrations
    app.migrations.add(ModelsMigration_v0())
    app.migrations.add(InsertCategories())
    app.migrations.add(ServicesInitialData())
    
    // Ejecuta las migraciones sincrónicamente
    try app.autoMigrate().wait()
            
    // Register routes
    try routes(app)
}

