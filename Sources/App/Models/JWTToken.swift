//
//  JWTToken.swift
//
//
//  Created by Jose Bueno Cruz on 13/7/24.
//

import Vapor
import JWT

enum JWTTokenType: String, Codable {
    case access
    case refresh
}


struct JWTToken: JWTPayload, Authenticatable {
    
    // MARK: Claims
    var exp: ExpirationClaim
    var iss: IssuerClaim
    var sub: SubjectClaim
    var type: JWTTokenType
    
    // MARK: Verify JWTToken
    func verify(using signer: JWTKit.JWTSigner) throws {
        
        // Expired
        try exp.verifyNotExpired()
        
        //Issuer
        guard iss.value == Environment.process.APP_BUNDLE_ID else {
            throw JWTError.claimVerificationFailure(name: "iss", reason: "Issueris invalid")
        }
        
        // Validate subject
        guard let _ = UUID(sub.value) else {
            throw JWTError.claimVerificationFailure(name: "sub", reason: "Subject is invalid")
        }
        
        // Validate JWT type
        guard type == .access || type == .refresh else {
            throw JWTError.claimVerificationFailure(name: "type", reason: "JWT type is invalid")
        }
    }
    
}


// MARK: - DTOs
extension JWTToken {
    
    struct Public: Content {
        
        let accessToken: String
        let refreshToken: String
        
    }
    
}


// MARK: - Auxiliar
extension JWTToken {
    
    static func generateTokens(user: UUID) -> (access: JWTToken, refresh: JWTToken) {
        
        var expDate = Date().addingTimeInterval(Constants.accessTokenLifeTime)
        let iss = Environment.process.APP_BUNDLE_ID!
        let sub = user.uuidString
        
        let access = JWTToken(exp: .init(value: expDate), iss: .init(value: iss), sub: .init(value: sub), type: .access)
        
        expDate = Date().addingTimeInterval(Constants.refreshTokenLifeTime)
        let refresh = JWTToken(exp: .init(value: expDate), iss: .init(value: iss), sub: .init(value: sub), type: .refresh)
        
        return (access, refresh)
        
    }
    
}
