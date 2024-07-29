//
//  ServicesInitialData.swift
//
//
//  Created by Alejandro Alberto Gavira García on 20/7/24.
//

import Vapor
import Fluent

// MARK: - Services Initial Data
// Migration responsible for creating initial service data based on existing categories
struct ServicesInitialData: AsyncMigration {

    // MARK: - Prepare
    // Prepares the initial data in the database
    func prepare(on database: Database) async throws {
        
        // Fetch all categories from the database
        let categories = try await Category.query(on: database).all()
        
        var services: [Service] = []  // Array to hold the services to be created
        
        // Iterate over each category to create associated services
        for category in categories {
            guard let categoryID = category.id else {
                throw Abort(.internalServerError, reason: "Category ID is missing")
            }
            
            // Create a professional user associated with the category
            let profUser = ProfUser(
                name: "\(category.name) User",
                firstSurname: "Apellido1",
                secondSurname: "Apellido2",
                mobile: "123456789",
                email: "\(category.name.lowercased())@example.com",
                password: "password",
                street: "Calle Ejemplo",
                city: "Ciudad Ejemplo",
                state: "Estado Ejemplo",
                postalCode: "12345",
                country: "País Ejemplo",
                categoryBusiness: category.name,
                companyName: "\(category.name) Company",
                nif: String(UUID())
            )
            
            // Save the professional user to the database
            try await profUser.save(on: database)
            
            guard let profUserID = profUser.id else {
                throw Abort(.internalServerError, reason: "Prof User ID is missing")
            }
            
            // Create services based on the category name
            switch category.name {
            case "Electricista":
                services.append(Service(name: "Instalación Eléctrica", note: 5.0, distance: 10.0, categoryID: categoryID, profUserID: profUserID))
                services.append(Service(name: "Reparación de Cortocircuitos", note: 5.0, distance: 10.0, categoryID: categoryID, profUserID: profUserID))
                services.append(Service(name: "Mantenimiento de Instalaciones Eléctricas", note: 5.0, distance: 10.0, categoryID: categoryID, profUserID: profUserID))
            case "Educador":
                services.append(Service(name: "Clases Particulares", note: 5.0, distance: 10.0, categoryID: categoryID, profUserID: profUserID))
                services.append(Service(name: "Asesoría Educativa", note: 5.0, distance: 10.0, categoryID: categoryID, profUserID: profUserID))
            case "Fontanero":
                services.append(Service(name: "Reparación de Fugas", note: 5.0, distance: 10.0, categoryID: categoryID, profUserID: profUserID))
                services.append(Service(name: "Instalación de Tuberías", note: 5.0, distance: 10.0, categoryID: categoryID, profUserID: profUserID))
            case "Carpintero":
                services.append(Service(name: "Fabricación de Muebles", note: 5.0, distance: 10.0, categoryID: categoryID, profUserID: profUserID))
                services.append(Service(name: "Reparación de Muebles", note: 5.0, distance: 10.0, categoryID: categoryID, profUserID: profUserID))
            case "Jardinero":
                services.append(Service(name: "Diseño de Jardines", note: 5.0, distance: 10.0, categoryID: categoryID, profUserID: profUserID))
                services.append(Service(name: "Mantenimiento de Jardines", note: 5.0, distance: 10.0, categoryID: categoryID, profUserID: profUserID))
            case "Limpieza":
                services.append(Service(name: "Limpieza Doméstica", note: 5.0, distance: 10.0, categoryID: categoryID, profUserID: profUserID))
                services.append(Service(name: "Limpieza de Oficinas", note: 5.0, distance: 10.0, categoryID: categoryID, profUserID: profUserID))
            case "Pintor":
                services.append(Service(name: "Pintura de Interiores", note: 5.0, distance: 10.0, categoryID: categoryID, profUserID: profUserID))
                services.append(Service(name: "Pintura de Exteriores", note: 5.0, distance: 10.0, categoryID: categoryID, profUserID: profUserID))
            case "Reparación":
                services.append(Service(name: "Reparación de Electrodomésticos", note: 5.0, distance: 10.0, categoryID: categoryID, profUserID: profUserID))
                services.append(Service(name: "Reparación de Muebles", note: 5.0, distance: 10.0, categoryID: categoryID, profUserID: profUserID))
            case "Cerrajero":
                services.append(Service(name: "Apertura de Puertas", note: 5.0, distance: 10.0, categoryID: categoryID, profUserID: profUserID))
                services.append(Service(name: "Cambio de Cerraduras", note: 5.0, distance: 10.0, categoryID: categoryID, profUserID: profUserID))
            case "Nutricionista":
                services.append(Service(name: "Plan de Alimentación Personalizado", note: 5.0, distance: 10.0, categoryID: categoryID, profUserID: profUserID))
                services.append(Service(name: "Consulta Nutricional", note: 5.0, distance: 10.0, categoryID: categoryID, profUserID: profUserID))
            case "Fisio":
                services.append(Service(name: "Terapia Física", note: 5.0, distance: 10.0, categoryID: categoryID, profUserID: profUserID))
                services.append(Service(name: "Rehabilitación Deportiva", note: 5.0, distance: 10.0, categoryID: categoryID, profUserID: profUserID))
            case "Psicologo":
                services.append(Service(name: "Terapia Psicológica", note: 5.0, distance: 10.0, categoryID: categoryID, profUserID: profUserID))
                services.append(Service(name: "Evaluación Psicológica", note: 5.0, distance: 10.0, categoryID: categoryID, profUserID: profUserID))
            case "Restaurante":
                services.append(Service(name: "Servicio de Comida a Domicilio", note: 5.0, distance: 10.0, categoryID: categoryID, profUserID: profUserID))
                services.append(Service(name: "Reservas para Eventos", note: 5.0, distance: 10.0, categoryID: categoryID, profUserID: profUserID))
            case "Abogados":
                services.append(Service(name: "Asesoría Legal", note: 5.0, distance: 10.0, categoryID: categoryID, profUserID: profUserID))
                services.append(Service(name: "Defensa Legal", note: 5.0, distance: 10.0, categoryID: categoryID, profUserID: profUserID))
            default:
                continue  // Skip categories that do not match any predefined cases
            }
        }
        
        // Save all the created services to the database
        for service in services {
            try await service.save(on: database)
        }
    }

    // MARK: - Revert
    // Reverts the migration by deleting all services
    func revert(on database: Database) async throws {
        try await Service.query(on: database).delete()  // Deletes all services from the database
    }
}


