//
//  JWTToken.swift
//
//
//  Created by Jose Bueno Cruz on 13/7/24.
//

import Vapor
import JWT

// MARK: - JWT Token Type Enum
// Enum to differentiate between access and refresh tokens
enum JWTTokenType: String, Codable {
    case access
    case refresh
}

// MARK: - JWT Token
struct JWTToken: JWTPayload, Authenticatable {
    
    // MARK: Claims
    var exp: ExpirationClaim
    var iss: IssuerClaim
    var sub: SubjectClaim
    var type: JWTTokenType
    
    // MARK: Verify JWTToken
    // Function to verify the validity of the token claims
    func verify(using signer: JWTKit.JWTSigner) throws {
        
        // Check if the token has expired
        try exp.verifyNotExpired()
        
        // Verify the issuer of the token
        guard iss.value == Environment.process.APP_BUNDLE_ID else {
            throw JWTError.claimVerificationFailure(name: "iss", reason: "Issueris invalid")
        }
        
        // Validate the subject (user) ID
        guard let _ = UUID(sub.value) else {
            throw JWTError.claimVerificationFailure(name: "sub", reason: "Subject is invalid")
        }
        
        // Validate the token type
        guard type == .access || type == .refresh else {
            throw JWTError.claimVerificationFailure(name: "type", reason: "JWT type is invalid")
        }
    }
    
}


// MARK: - DTOs
extension JWTToken {
    
    // MARK: - Public DTO
    struct Public: Content {
        
        // MARK: Properties
        // DTO for public token information
        let accessToken: String
        let refreshToken: String
        let userID: UUID?
        
    }
    
}


// MARK: - Auxiliary Functions
extension JWTToken {
    
    // MARK: Token Generation
    // Function to generate access and refresh tokens for a given user
    static func generateTokens(user: UUID) -> (access: JWTToken, refresh: JWTToken) {
        
        // Set expiration date for access token
        var expDate = Date().addingTimeInterval(Constants.accessTokenLifeTime)
        let iss = Environment.process.APP_BUNDLE_ID!
        let sub = user.uuidString
        
        // Create access token
        let access = JWTToken(exp: .init(value: expDate), iss: .init(value: iss), sub: .init(value: sub), type: .access)
        
        // Set expiration date for refresh token
        expDate = Date().addingTimeInterval(Constants.refreshTokenLifeTime)
        
        // Create refresh token
        let refresh = JWTToken(exp: .init(value: expDate), iss: .init(value: iss), sub: .init(value: sub), type: .refresh)
        
        return (access, refresh)
        
    }
    
}
