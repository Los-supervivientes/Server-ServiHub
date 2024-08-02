//
//  CategoryControllerTest.swift
//  
//
//  Created by Jose Bueno Cruz on 1/8/24.
//

import XCTest
import XCTVapor
@testable import App

final class CategoryControllerTests: XCTestCase {
    
    var app: Application!
    var categoryID: UUID?
    
    override func setUpWithError() throws {
        // Configures the Vapor application instance for testing
        app = Application(.testing)
        
        // Uses the test database
        guard let dbURL = Environment.process.DATABASE_URL else { fatalError("DB URL not found") }
        // Set up the PostgreSQL database connection
        try app.databases.use(.postgres(url: dbURL), as: .psql)
        
        // Configures the application
        try configure(app)
        
        // Runs migrations for the test database
        try app.autoMigrate().wait()
    }
    
    override func tearDownWithError() throws {
        // Cleans up after each test
        app.shutdown()
    }
    
    func testCRUDCategory() throws {
        // Create JSON as a string
        let jsonString = """
            {
                "name": "Test Category"
            }
            """
        
        // Perform POST request to create the category
        try app.test(.POST, "/api/categories", headers: commonHeaders(), body: .init(string: jsonString)) { response in
            XCTAssertEqual(response.status, .ok)
            let createdCategory = try response.content.decode(Category.self)
            XCTAssertEqual(createdCategory.name, "Test Category")
            self.categoryID = createdCategory.id
        }
        
        guard let categoryID = categoryID else {
            XCTFail("Category ID should not be nil")
            return
        }
        
        // Perform GET request to retrieve the category by ID
        try app.test(.GET, "/api/categories/\(categoryID)", headers: commonHeaders()) { response in
            XCTAssertEqual(response.status, .ok)
            
            // Decode the response as a Category object
            let fetchedCategory = try response.content.decode(Category.self)
            
            // Verify that the data matches
            XCTAssertEqual(fetchedCategory.id, categoryID)
            XCTAssertEqual(fetchedCategory.name, "Test Category")
        }
        
        // Create JSON for the update
        let updateJsonString = """
            {
                "name": "Updated Test Category"
            }
            """
        
        // Perform PUT request to update the category
        try app.test(.PUT, "/api/categories/\(categoryID)", headers: commonHeaders(), body: .init(string: updateJsonString)) { response in
            XCTAssertEqual(response.status, .ok)
            
            // Decode the response as a Category object
            let updatedCategory = try response.content.decode(Category.self)
            
            // Verify that the data has been updated correctly
            XCTAssertEqual(updatedCategory.id, categoryID)
            XCTAssertEqual(updatedCategory.name, "Updated Test Category")
        }
        
        // Delete the updated category
        try app.test(.DELETE, "/api/categories/\(categoryID)", headers: commonHeaders()) { response in
            XCTAssertEqual(response.status, .noContent)
        }
        
        // Verify that the category no longer exists
        try app.test(.GET, "/api/categories/\(categoryID)", headers: commonHeaders()) { response in
            XCTAssertEqual(response.status, .notFound)
        }
        
    }
    
    func testGetAllCategories() throws {
        // Perform GET request to retrieve all categories
        try app.test(.GET, "/api/categories", headers: commonHeaders()) { response in
            XCTAssertEqual(response.status, .ok)
            
            print(response.body.string)

        }
    }
    
    // Provides common headers for API requests
    func commonHeaders() -> HTTPHeaders {
        let apiKey = Environment.process.API_KEY ?? "default_test_api_key"
        var headers = HTTPHeaders()
        headers.add(name: "SSH-ApiKey", value: apiKey)
        headers.add(name: .contentType, value: "application/json")
        return headers
    }
}

