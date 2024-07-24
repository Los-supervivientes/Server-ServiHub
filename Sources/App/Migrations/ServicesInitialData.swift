//
//  ServicesInitialData.swift
//
//
//  Created by Alejandro Alberto Gavira García on 20/7/24.
//

import Vapor
import Fluent

// MARK: - Services Initial Data
struct ServicesInitialData: AsyncMigration {

    func prepare(on database: Database) async throws {
        // Recuperar todas las categorías
        let categories = try await Category.query(on: database).all()
        
        // Definir los servicios a agregar
        var services: [Service] = []
        
        for category in categories {
            guard let categoryID = category.id else {
                throw Abort(.internalServerError, reason: "Category ID is missing")
            }
            
            switch category.name {
            case "Electricista":
                services.append(Service(name: "Instalación Eléctrica", note: 5.0, distance: 10.0, categoryID: categoryID))
                services.append(Service(name: "Reparación de Cortocircuitos", note: 5.0, distance: 10.0, categoryID: categoryID))
                services.append(Service(name: "Mantenimiento de Instalaciones Eléctricas", note: 5.0, distance: 10.0, categoryID: categoryID))
            case "Educador":
                services.append(Service(name: "Clases Particulares", note: 5.0, distance: 10.0, categoryID: categoryID))
                services.append(Service(name: "Asesoría Educativa", note: 5.0, distance: 10.0, categoryID: categoryID))
            case "Fontanero":
                services.append(Service(name: "Reparación de Fugas", note: 5.0, distance: 10.0, categoryID: categoryID))
                services.append(Service(name: "Instalación de Tuberías", note: 5.0, distance: 10.0, categoryID: categoryID))
            case "Carpintero":
                services.append(Service(name: "Fabricación de Muebles", note: 5.0, distance: 10.0, categoryID: categoryID))
                services.append(Service(name: "Reparación de Muebles", note: 5.0, distance: 10.0, categoryID: categoryID))
            case "Jardinero":
                services.append(Service(name: "Diseño de Jardines", note: 5.0, distance: 10.0, categoryID: categoryID))
                services.append(Service(name: "Mantenimiento de Jardines", note: 5.0, distance: 10.0, categoryID: categoryID))
            case "Limpieza":
                services.append(Service(name: "Limpieza Doméstica", note: 5.0, distance: 10.0, categoryID: categoryID))
                services.append(Service(name: "Limpieza de Oficinas", note: 5.0, distance: 10.0, categoryID: categoryID))
            case "Pintor":
                services.append(Service(name: "Pintura de Interiores", note: 5.0, distance: 10.0, categoryID: categoryID))
                services.append(Service(name: "Pintura de Exteriores", note: 5.0, distance: 10.0, categoryID: categoryID))
            case "Reparación":
                services.append(Service(name: "Reparación de Electrodomésticos", note: 5.0, distance: 10.0, categoryID: categoryID))
                services.append(Service(name: "Reparación de Muebles", note: 5.0, distance: 10.0, categoryID: categoryID))
            case "Cerrajero":
                services.append(Service(name: "Apertura de Puertas", note: 5.0, distance: 10.0, categoryID: categoryID))
                services.append(Service(name: "Cambio de Cerraduras", note: 5.0, distance: 10.0, categoryID: categoryID))
            case "Nutricionista":
                services.append(Service(name: "Plan de Alimentación Personalizado", note: 5.0, distance: 10.0, categoryID: categoryID))
                services.append(Service(name: "Consulta Nutricional", note: 5.0, distance: 10.0, categoryID: categoryID))
            case "Fisio":
                services.append(Service(name: "Terapia Física", note: 5.0, distance: 10.0, categoryID: categoryID))
                services.append(Service(name: "Rehabilitación Deportiva", note: 5.0, distance: 10.0, categoryID: categoryID))
            case "Psicologo":
                services.append(Service(name: "Terapia Psicológica", note: 5.0, distance: 10.0, categoryID: categoryID))
                services.append(Service(name: "Evaluación Psicológica", note: 5.0, distance: 10.0, categoryID: categoryID))
            case "Restaurante":
                services.append(Service(name: "Servicio de Comida a Domicilio", note: 5.0, distance: 10.0, categoryID: categoryID))
                services.append(Service(name: "Reservas para Eventos", note: 5.0, distance: 10.0, categoryID: categoryID))
            case "Abogados":
                services.append(Service(name: "Asesoría Legal", note: 5.0, distance: 10.0, categoryID: categoryID))
                services.append(Service(name: "Defensa Legal", note: 5.0, distance: 10.0, categoryID: categoryID))
            default:
                continue
            }
        }
        
        // Insertar todos los servicios en la base de datos
        for service in services {
            try await service.save(on: database)
        }
    }

    func revert(on database: Database) async throws {
        // Eliminar todos los servicios
        try await Service.query(on: database).delete()
    }
}

