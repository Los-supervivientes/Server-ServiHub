//
//  ConstantsTest.swift
//  
//
//  Created by Jose Bueno Cruz on 1/8/24.
//

import XCTest
@testable import App

final class ConstantsTests: XCTestCase {
    
    // Test for verifying the access token lifetime constant
    func testAccessTokenLifeTime() {
        
        let expectedAccessTokenLifeTime: Double = 60 * 60 * 24 // 1 day in seconds
        XCTAssertEqual(Constants.accessTokenLifeTime, expectedAccessTokenLifeTime, "The access token lifetime should be 1 day.")
        
    }
    
    // Test for verifying the refresh token lifetime constant
    func testRefreshTokenLifeTime() {
        
        let expectedRefreshTokenLifeTime: Double = 60 * 60 * 24 * 7 // 1 week in seconds
        XCTAssertEqual(Constants.refreshTokenLifeTime, expectedRefreshTokenLifeTime, "The refresh token lifetime should be 1 week.")
        
    }
    
    
}
