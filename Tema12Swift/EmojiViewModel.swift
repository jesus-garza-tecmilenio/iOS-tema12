//
//  EmojiViewModel.swift
//  Tema12Swift
//
//  Created by JESUS GARZA on 06/11/25.
//

import SwiftUI
import Foundation

// MARK: - EmojiViewModel

/// ViewModel que maneja toda la lógica de negocio de la aplicación
/// Usa el macro @Observable de Swift 5.9+ para reactividad automática
/// Patrón MVVM: separa la lógica de negocio de la vista
@Observable
class EmojiViewModel {
    
    // MARK: - Published Properties
    
    /// Lista principal de emojis
    /// Se guarda automáticamente en UserDefaults cuando cambia
    var emojis: [Emoji] {
        didSet {
            saveEmojis()
        }
    }
    
    /// Texto de búsqueda para filtrar emojis
    var searchText: String = ""
    
    /// Categoría seleccionada para filtrar (nil = todas las categorías)
    var selectedCategory: String? = nil
    
    // MARK: - Constants
    
    /// Key para guardar los emojis en UserDefaults
    private let EMOJIS_KEY = "saved_emojis"
    
    // MARK: - Computed Properties
    
    /// Lista de emojis filtrada según búsqueda y categoría
    /// Se recalcula automáticamente cuando cambian searchText, selectedCategory o emojis
    var filteredEmojis: [Emoji] {
        var result = emojis
        
        // Filtrar por categoría si hay una seleccionada
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }
        
        // Filtrar por texto de búsqueda
        if !searchText.isEmpty {
            result = result.filter { emoji in
                emoji.description.localizedCaseInsensitiveContains(searchText) ||
                emoji.emoji.contains(searchText) ||
                emoji.category.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return result
    }
    
    // MARK: - Initializer
    
    /// Inicializa el ViewModel
    /// Carga los emojis guardados o usa datos de ejemplo si es la primera vez
    init() {
        // Cargar emojis guardados o usar datos de ejemplo
        // No podemos llamar a loadEmojis() aquí porque usa self
        let savedEmojis = Self.loadSavedEmojis()
        self.emojis = savedEmojis ?? Emoji.sampleEmojis
        
        // Si no había datos guardados, guardar los datos de ejemplo
        if savedEmojis == nil {
            saveEmojis()
        }
    }
    
    /// Método estático para cargar emojis sin usar self
    private static func loadSavedEmojis() -> [Emoji]? {
        guard let data = UserDefaults.standard.data(forKey: "saved_emojis") else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([Emoji].self, from: data)
        } catch {
            print("❌ Error al cargar emojis: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - CRUD Operations
    
    /// Agrega un nuevo emoji a la lista
    /// - Parameter emoji: El emoji a agregar
    func addEmoji(_ emoji: Emoji) {
        emojis.append(emoji)
        // didSet se encarga de guardar automáticamente
    }
    
    /// Elimina emojis en los índices especificados
    /// - Parameter offsets: Conjunto de índices a eliminar
    /// - Note: Usado por el modificador onDelete de List
    func deleteEmoji(at offsets: IndexSet) {
        emojis.remove(atOffsets: offsets)
    }
    
    /// Elimina un emoji específico por su ID
    /// - Parameter emoji: El emoji a eliminar
    func deleteEmoji(_ emoji: Emoji) {
        if let index = emojis.firstIndex(where: { $0.id == emoji.id }) {
            emojis.remove(at: index)
        }
    }
    
    /// Mueve emojis de una posición a otra (reordenamiento)
    /// - Parameters:
    ///   - source: Índices de origen
    ///   - destination: Índice de destino
    /// - Note: Usado por el modificador onMove de List
    func moveEmoji(from source: IndexSet, to destination: Int) {
        emojis.move(fromOffsets: source, toOffset: destination)
    }
    
    // MARK: - Update Operations
    
    /// Alterna el estado de favorito de un emoji
    /// - Parameter emoji: El emoji a actualizar
    func toggleFavorite(_ emoji: Emoji) {
        if let index = emojis.firstIndex(where: { $0.id == emoji.id }) {
            emojis[index].isFavorite.toggle()
        }
    }
    
    /// Actualiza la descripción de un emoji
    /// - Parameters:
    ///   - emoji: El emoji a actualizar
    ///   - newDescription: La nueva descripción
    func updateEmojiDescription(_ emoji: Emoji, newDescription: String) {
        if let index = emojis.firstIndex(where: { $0.id == emoji.id }) {
            emojis[index].description = newDescription
        }
    }
    
    /// Duplica un emoji existente
    /// - Parameter emoji: El emoji a duplicar
    func duplicateEmoji(_ emoji: Emoji) {
        let newEmoji = Emoji(
            emoji: emoji.emoji,
            description: emoji.description + " (Copia)",
            category: emoji.category,
            isFavorite: false,
            createdDate: Date()
        )
        addEmoji(newEmoji)
    }
    
    // MARK: - System Integration
    
    /// Copia texto al portapapeles del sistema
    /// - Parameter text: El texto a copiar
    func copyToClipboard(_ text: String) {
        #if os(iOS)
        UIPasteboard.general.string = text
        #elseif os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
        #endif
    }
    
    /// Prepara el contenido para compartir un emoji
    /// - Parameter emoji: El emoji a compartir
    /// - Returns: Array de items para compartir
    func shareEmoji(_ emoji: Emoji) -> [Any] {
        let shareText = "\(emoji.emoji) - \(emoji.description)"
        return [shareText]
    }
    
    // MARK: - Persistence (UserDefaults)
    
    /// Guarda los emojis en UserDefaults
    /// - Note: Usa JSONEncoder para convertir el array a Data
    private func saveEmojis() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(emojis)
            UserDefaults.standard.set(data, forKey: EMOJIS_KEY)
        } catch {
            print("❌ Error al guardar emojis: \(error.localizedDescription)")
        }
    }
    
    /// Carga los emojis guardados de UserDefaults
    /// - Returns: Array de emojis o nil si no hay datos guardados
    /// - Note: Usa JSONDecoder para convertir Data a array
    private func loadEmojis() -> [Emoji]? {
        guard let data = UserDefaults.standard.data(forKey: EMOJIS_KEY) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let emojis = try decoder.decode([Emoji].self, from: data)
            return emojis
        } catch {
            print("❌ Error al cargar emojis: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Resetea todos los datos a los valores de ejemplo
    /// - Note: Útil para desarrollo y testing
    func resetToSampleData() {
        emojis = Emoji.sampleEmojis
    }
}
