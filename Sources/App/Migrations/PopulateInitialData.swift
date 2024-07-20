//
//  PopulateInitialData.swift
//
//
//  Created by Jose Bueno Cruz on 16/7/24.
//

import Vapor
import Fluent

// MARK: - PopulateInitialData
struct PopulateInitialData: AsyncMigration {

    func prepare(on database: Database) async throws {
        
        let categories = [
            Category(name: "Electricista"),
            Category(name: "Educador"),
            Category(name: "Fontanero"),
            Category(name: "Carpintero"),
            Category(name: "Jardinero"),
            Category(name: "Limpieza"),
            Category(name: "Pintor"),
            Category(name: "Reparación"),
            Category(name: "Cerrajero"),
            Category(name: "Nutricionista"),
            Category(name: "Fisio"),
            Category(name: "Psicologo"),
            Category(name: "Restaurante"),
            Category(name: "Abogados")
        ]
        
        try await categories.create(on: database)
        
    }
    
    func revert(on database: Database) async throws {
        try await Category.query(on: database).delete()
    }
    
    
}
    
//    func prepare(on database: Database) async throws {
//            // Create main categories and their subcategories
//            let hogarYJardin = Category(name: "Hogar y Jardín", description: "Categoría principal de Hogar y Jardín.", imageURL: "http://example.com/hogar_y_jardin.png")
//            let saludYBienestar = Category(name: "Salud y Bienestar", description: "Categoría principal de Salud y Bienestar.", imageURL: "http://example.com/salud_y_bienestar.png")
//            let automovilesYVehiculos = Category(name: "Automóviles y Vehículos", description: "Categoría principal de Automóviles y Vehículos.", imageURL: "http://example.com/automoviles_y_vehiculos.png")
//            let tecnologiaYElectronica = Category(name: "Tecnología y Electrónica", description: "Categoría principal de Tecnología y Electrónica.", imageURL: "http://example.com/tecnologia_y_electronica.png")
//            let educacionYCapacitacion = Category(name: "Educación y Capacitación", description: "Categoría principal de Educación y Capacitación.", imageURL: "http://example.com/educacion_y_capacitacion.png")
//            let eventosYEntretenimiento = Category(name: "Eventos y Entretenimiento", description: "Categoría principal de Eventos y Entretenimiento.", imageURL: "http://example.com/eventos_y_entretenimiento.png")
//            let modaYBelleza = Category(name: "Moda y Belleza", description: "Categoría principal de Moda y Belleza.", imageURL: "http://example.com/moda_y_belleza.png")
//            let serviciosProfesionales = Category(name: "Servicios Profesionales", description: "Categoría principal de Servicios Profesionales.", imageURL: "http://example.com/servicios_profesionales.png")
//            let mascotas = Category(name: "Mascotas", description: "Categoría principal de Mascotas.", imageURL: "http://example.com/mascotas.png")
//            let otros = Category(name: "Otros", description: "Categoría principal de Otros.", imageURL: "http://example.com/otros.png")
//
//            try await hogarYJardin.create(on: database)
//            try await saludYBienestar.create(on: database)
//            try await automovilesYVehiculos.create(on: database)
//            try await tecnologiaYElectronica.create(on: database)
//            try await educacionYCapacitacion.create(on: database)
//            try await eventosYEntretenimiento.create(on: database)
//            try await modaYBelleza.create(on: database)
//            try await serviciosProfesionales.create(on: database)
//            try await mascotas.create(on: database)
//            try await otros.create(on: database)
//
//            let subcategories = [
//                ("Electricista", hogarYJardin),
//                ("Fontanero", hogarYJardin),
//                ("Carpintero", hogarYJardin),
//                ("Jardinero", hogarYJardin),
//                ("Limpieza doméstica", hogarYJardin),
//                ("Pintor", hogarYJardin),
//                ("Reparación de electrodomésticos", hogarYJardin),
//                ("Instalación de aire acondicionado", hogarYJardin),
//                ("Albañil", hogarYJardin),
//                ("Cerrajero", hogarYJardin),
//                ("Entrenador personal", saludYBienestar),
//                ("Fisioterapeuta", saludYBienestar),
//                ("Nutricionista", saludYBienestar),
//                ("Masajista", saludYBienestar),
//                ("Terapeuta ocupacional", saludYBienestar),
//                ("Cuidado de ancianos", saludYBienestar),
//                ("Cuidado de niños", saludYBienestar),
//                ("Esteticista", saludYBienestar),
//                ("Psicólogo", saludYBienestar),
//                ("Acupunturista", saludYBienestar),
//                ("Mecánico", automovilesYVehiculos),
//                ("Lavado y detallado de autos", automovilesYVehiculos),
//                ("Taller de chapa y pintura", automovilesYVehiculos),
//                ("Instalación de audio y alarmas", automovilesYVehiculos),
//                ("Cambio de neumáticos", automovilesYVehiculos),
//                ("Revisión y mantenimiento general", automovilesYVehiculos),
//                ("Servicio de grúa", automovilesYVehiculos),
//                ("Alquiler de coches", automovilesYVehiculos),
//                ("Tintado de ventanas", automovilesYVehiculos),
//                ("Inspección técnica de vehículos", automovilesYVehiculos),
//                ("Reparación de computadoras", tecnologiaYElectronica),
//                ("Reparación de teléfonos móviles", tecnologiaYElectronica),
//                ("Desarrollo de software", tecnologiaYElectronica),
//                ("Diseño web", tecnologiaYElectronica),
//                ("Instalación de redes", tecnologiaYElectronica),
//                ("Soporte técnico a domicilio", tecnologiaYElectronica),
//                ("Consultoría IT", tecnologiaYElectronica),
//                ("Reparación de televisores", tecnologiaYElectronica),
//                ("Instalación de sistemas de seguridad", tecnologiaYElectronica),
//                ("Mantenimiento de servidores", tecnologiaYElectronica),
//                ("Clases particulares", educacionYCapacitacion),
//                ("Tutoring", educacionYCapacitacion),
//                ("Cursos de idiomas", educacionYCapacitacion),
//                ("Clases de música", educacionYCapacitacion),
//                ("Formación profesional", educacionYCapacitacion),
//                ("Preparación para exámenes", educacionYCapacitacion),
//                ("Coaching personal", educacionYCapacitacion),
//                ("Clases de baile", educacionYCapacitacion),
//                ("Talleres y seminarios", educacionYCapacitacion),
//                ("Clases de arte y manualidades", educacionYCapacitacion),
//                ("Organización de eventos", eventosYEntretenimiento),
//                ("Catering", eventosYEntretenimiento),
//                ("DJ y música en vivo", eventosYEntretenimiento),
//                ("Fotografía y video", eventosYEntretenimiento),
//                ("Animadores y payasos", eventosYEntretenimiento),
//                ("Decoración de eventos", eventosYEntretenimiento),
//                ("Alquiler de equipos de sonido", eventosYEntretenimiento),
//                ("Planificación de bodas", eventosYEntretenimiento),
//                ("Alquiler de carpas y mobiliario", eventosYEntretenimiento),
//                ("Maquillaje y peluquería para eventos", eventosYEntretenimiento),
//                ("Peluquería", modaYBelleza),
//                ("Maquillaje", modaYBelleza),
//                ("Manicura y pedicura", modaYBelleza),
//                ("Estilista personal", modaYBelleza),
//                ("Tratamientos faciales", modaYBelleza),
//                ("Depilación", modaYBelleza),
//                ("Barbería", modaYBelleza),
//                ("Asesoría de imagen", modaYBelleza),
//                ("Masajes de belleza", modaYBelleza),
//                ("Spa y tratamientos corporales", modaYBelleza),
//                ("Abogado", serviciosProfesionales),
//                ("Contador", serviciosProfesionales),
//                ("Consultor de negocios", serviciosProfesionales),
//                ("Agente inmobiliario", serviciosProfesionales),
//                ("Diseñador gráfico", serviciosProfesionales),
//                ("Traductor e intérprete", serviciosProfesionales),
//                ("Consultor de marketing", serviciosProfesionales),
//                ("Asesor financiero", serviciosProfesionales),
//                ("Fotógrafo profesional", serviciosProfesionales),
//                ("Editor de video", serviciosProfesionales),
//                ("Paseo de perros", mascotas),
//                ("Cuidado de mascotas", mascotas),
//                ("Adiestramiento de perros", mascotas),
//                ("Peluquería canina", mascotas),
//                ("Veterinario a domicilio", mascotas),
//                ("Guardería de mascotas", mascotas),
//                ("Fotografía de mascotas", mascotas),
//                ("Servicios de adopción", mascotas),
//                ("Asesoría en nutrición animal", mascotas),
//                ("Taxi para mascotas", mascotas),
//                ("Mudanzas", otros),
//                ("Personal de mantenimiento", otros),
//                ("Tareas de bricolaje", otros),
//                ("Reparación de bicicletas", otros),
//                ("Clases de conducción", otros),
//                ("Gestoría y trámites administrativos", otros),
//                ("Asesoría legal", otros),
//                ("Asesoría en viajes", otros),
//                ("Alquiler de equipos", otros),
//                ("Recados y mensajería", otros)
//            ]
//
//            // Assign subcategories to main category
//            for (subcategoryName, parentCategory) in subcategories {
//                let subcategory = Category(name: subcategoryName)
//                subcategory.$parent.id = parentCategory.id
//                try await subcategory.create(on: database)
//            }
//        }
//        
//        func revert(on database: Database) async throws {
//            try await Category.query(on: database).delete()
//        }

