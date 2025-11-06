//
//  Emoji.swift
//  Tema12Swift
//
//  Created by JESUS GARZA on 06/11/25.
//

import Foundation

// MARK: - Emoji Model

/// Modelo que representa un emoji con su información asociada
/// Conforma Identifiable para poder usarlo en listas de SwiftUI
/// Conforma Codable para poder guardarlo en UserDefaults o archivos JSON
struct Emoji: Identifiable, Codable {
    // MARK: - Properties
    
    /// Identificador único generado automáticamente
    let id: UUID
    
    /// El emoji en sí (por ejemplo: "😀")
    var emoji: String
    
    /// Descripción del emoji (por ejemplo: "Cara sonriente")
    var description: String
    
    /// Categoría del emoji (Smileys, Nature, Food, Objects, Symbols)
    var category: String
    
    /// Indica si el emoji está marcado como favorito
    var isFavorite: Bool
    
    /// Fecha en la que se creó o agregó el emoji
    var createdDate: Date
    
    // MARK: - Initializer
    
    /// Inicializador completo del emoji
    /// - Parameters:
    ///   - id: UUID único (se genera automáticamente si no se proporciona)
    ///   - emoji: El emoji como string
    ///   - description: Descripción del emoji
    ///   - category: Categoría del emoji
    ///   - isFavorite: Si está marcado como favorito (false por defecto)
    ///   - createdDate: Fecha de creación (Date() por defecto)
    init(
        id: UUID = UUID(),
        emoji: String,
        description: String,
        category: String,
        isFavorite: Bool = false,
        createdDate: Date = Date()
    ) {
        self.id = id
        self.emoji = emoji
        self.description = description
        self.category = category
        self.isFavorite = isFavorite
        self.createdDate = createdDate
    }
}

// MARK: - Sample Data

extension Emoji {
    /// Datos de ejemplo para usar en la aplicación
    /// Incluye emojis de diferentes categorías para demostrar filtrado
    static let sampleEmojis: [Emoji] = [
        Emoji(
            emoji: "😀",
            description: "Cara sonriente - Expresa felicidad y alegría",
            category: "Smileys",
            isFavorite: true,
            createdDate: Date().addingTimeInterval(-86400 * 7) // Hace 7 días
        ),
        Emoji(
            emoji: "❤️",
            description: "Corazón rojo - Amor y afecto profundo",
            category: "Symbols",
            isFavorite: true,
            createdDate: Date().addingTimeInterval(-86400 * 6)
        ),
        Emoji(
            emoji: "🍕",
            description: "Pizza - Comida italiana favorita de todos",
            category: "Food",
            isFavorite: false,
            createdDate: Date().addingTimeInterval(-86400 * 5)
        ),
        Emoji(
            emoji: "🌳",
            description: "Árbol - Naturaleza y medio ambiente",
            category: "Nature",
            isFavorite: false,
            createdDate: Date().addingTimeInterval(-86400 * 4)
        ),
        Emoji(
            emoji: "⚽",
            description: "Balón de fútbol - Deporte más popular del mundo",
            category: "Objects",
            isFavorite: true,
            createdDate: Date().addingTimeInterval(-86400 * 3)
        ),
        Emoji(
            emoji: "🎵",
            description: "Nota musical - Música y melodías",
            category: "Symbols",
            isFavorite: false,
            createdDate: Date().addingTimeInterval(-86400 * 2)
        ),
        Emoji(
            emoji: "🚗",
            description: "Auto - Transporte y vehículos",
            category: "Objects",
            isFavorite: false,
            createdDate: Date().addingTimeInterval(-86400 * 1)
        ),
        Emoji(
            emoji: "🌙",
            description: "Luna - Noche y astronomía",
            category: "Nature",
            isFavorite: true,
            createdDate: Date().addingTimeInterval(-3600 * 12)
        ),
        Emoji(
            emoji: "🎉",
            description: "Confeti - Celebración y fiesta",
            category: "Symbols",
            isFavorite: false,
            createdDate: Date().addingTimeInterval(-3600 * 6)
        ),
        Emoji(
            emoji: "☕",
            description: "Café - Bebida energizante matutina",
            category: "Food",
            isFavorite: true,
            createdDate: Date()
        )
    ]
    
    /// Lista de todas las categorías disponibles
    /// Útil para el Picker de filtrado
    static let categories: [String] = [
        "Smileys",
        "Nature",
        "Food",
        "Objects",
        "Symbols"
    ]
}

// MARK: - Equatable Conformance

extension Emoji: Equatable {
    /// Comparación de igualdad basada en el ID
    /// Necesario para encontrar y actualizar emojis en arrays
    static func == (lhs: Emoji, rhs: Emoji) -> Bool {
        lhs.id == rhs.id
    }
}
