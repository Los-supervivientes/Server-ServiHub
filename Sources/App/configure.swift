import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor
import JWT

// MARK: - Configure App
public func configure(_ app: Application) async throws {

    // MARK: Environment Variables
    guard let jwtKey = Environment.get("JWT_KEY") else { fatalError("JWT Key not found")}
    guard let _ = Environment.process.API_KEY else {fatalError("JWT Key not found")}
    guard let dbURL = Environment.process.DATABASE_URL else {fatalError("DB URL not found")}
    guard let _ = Environment.process.APP_BUNDLE_ID else {fatalError("APP Bundle ID not found")}
    
    // MARK: Config JWT
    app.jwt.signers.use(.hs256(key: jwtKey))
    
    // MARK: DB Conection
    try app.databases.use(.postgres(url: dbURL), as: .psql)
    
    // MARK: Config Password
    app.passwords.use(.bcrypt)
    
    // MARK: Migrations
    app.migrations.add(ModelsMigration_v0())
    try await app.autoMigrate()
            
    // MARK: Register Router
    try routes(app)
}
