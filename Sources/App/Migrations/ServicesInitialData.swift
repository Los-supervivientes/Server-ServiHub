//
//  File.swift
//  
//
//  Created by Alejandro Alberto Gavira García on 20/7/24.
//

import Vapor
import Fluent

// MARK: - PopulateInitialData
struct ServicesInitialData: AsyncMigration {

    func prepare(on database: Database) async throws {
        
        let services = [
            Services(name: "Antonio", category: Category(name: "Electricista")),
            Services(name: "Maria", category: Category(name: "Electricista")),
            Services(name: "Carlos", category: Category(name: "Electricista")),
            
            Services(name: "Ana", category: Category(name: "Educador")),
            Services(name: "Jose", category: Category(name: "Educador")),
            Services(name: "Luisa", category: Category(name: "Educador")),
            
            Services(name: "Miguel", category: Category(name: "Fontanero")),
            Services(name: "Sofia", category: Category(name: "Fontanero")),
            Services(name: "Pablo", category: Category(name: "Fontanero")),
            
            Services(name: "Javier", category: Category(name: "Carpintero")),
            Services(name: "Lucia", category: Category(name: "Carpintero")),
            Services(name: "Alberto", category: Category(name: "Carpintero")),
            
            Services(name: "Fernando", category: Category(name: "Jardinero")),
            Services(name: "Claudia", category: Category(name: "Jardinero")),
            Services(name: "Monica", category: Category(name: "Jardinero")),
            
            Services(name: "Daniela", category: Category(name: "Limpieza")),
            Services(name: "Roberto", category: Category(name: "Limpieza")),
            Services(name: "Isabel", category: Category(name: "Limpieza")),
            
            Services(name: "Sara", category: Category(name: "Pintor")),
            Services(name: "Victor", category: Category(name: "Pintor")),
            Services(name: "Laura", category: Category(name: "Pintor")),
            
            Services(name: "Raul", category: Category(name: "Reparación")),
            Services(name: "Adriana", category: Category(name: "Reparación")),
            Services(name: "Diego", category: Category(name: "Reparación")),
            
            Services(name: "Elena", category: Category(name: "Cerrajero")),
            Services(name: "Andres", category: Category(name: "Cerrajero")),
            Services(name: "Paula", category: Category(name: "Cerrajero")),
            
            Services(name: "Francisco", category: Category(name: "Restaurante")),
            Services(name: "Gloria", category: Category(name: "Restaurante")),
            Services(name: "Natalia", category: Category(name: "Restaurante")),
            
            Services(name: "Teresa", category: Category(name: "Nutricionista")),
            Services(name: "Eduardo", category: Category(name: "Nutricionista")),
            Services(name: "Beatriz", category: Category(name: "Nutricionista")),
            
            Services(name: "Marcos", category: Category(name: "Fisio")),
            Services(name: "Alicia", category: Category(name: "Fisio")),
            Services(name: "Marta", category: Category(name: "Fisio")),
            
            Services(name: "Jorge", category: Category(name: "Psicologo")),
            Services(name: "Rocio", category: Category(name: "Psicologo")),
            Services(name: "Carmen", category: Category(name: "Psicologo")),
            
            Services(name: "Luis", category: Category(name: "Abogados")),
            Services(name: "Patricia", category: Category(name: "Abogados")),
            Services(name: "Gonzalo", category: Category(name: "Abogados"))
        ]
        
        try await services.create(on: database)


    }
    
    func revert(on database: Database) async throws {
        try await Category.query(on: database).delete()
        try await Services.query(on: database).delete()
    }
    
    
}
