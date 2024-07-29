//
//  Version.swift
//
//
//  Created by Jose Bueno Cruz on 9/7/24.
//

import Vapor

// MARK: - Version Model
struct Version: Content {
    
    // MARK: Properties
    let current: String     // Current version
    let live: String        // Live version
    let needsUpdate: Bool   // Fag indicating if an update is needed
    
}
