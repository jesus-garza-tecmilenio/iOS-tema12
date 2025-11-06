//
//  ContentView.swift
//  Tema12Swift
//
//  Created by JESUS GARZA on 06/11/25.
//

import SwiftUI

// MARK: - ContentView

/// Vista principal de la aplicación Emoji Dictionary
/// Demuestra conceptos avanzados de List:
/// - Búsqueda y filtrado
/// - Reordenamiento con drag & drop
/// - Edición inline
/// - SwipeActions y ContextMenu (en EmojiRow)
struct ContentView: View {
    
    // MARK: - Properties
    
    /// ViewModel que maneja toda la lógica de negocio
    /// @State para mantener la instancia durante la vida de la vista
    @State private var viewModel = EmojiViewModel()
    
    /// Estado para mostrar el sheet de agregar emoji
    @State private var showAddEmojiSheet = false
    
    /// Estado para modo edición de la lista
    @State private var editMode: EditMode = .inactive
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // MARK: Category Filter Picker
                categoryFilterPicker
                
                // MARK: Emoji List
                emojiList
            }
            .navigationTitle("📚 Emoji Dictionary")
            .navigationBarTitleDisplayMode(.large)
            // MARK: - Toolbar
            .toolbar {
                // Botón de edición (activa modo reordenamiento)
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                
                // Botón para agregar emoji
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddEmojiSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                }
                
                // Botón para resetear datos (solo en desarrollo)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.resetToSampleData()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            // MARK: - Environment
            .environment(\.editMode, $editMode)
            // MARK: - Sheet para agregar emoji
            .sheet(isPresented: $showAddEmojiSheet) {
                AddEmojiSheet(viewModel: viewModel)
            }
        }
        // MARK: - Searchable (barra de búsqueda)
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Buscar emoji o descripción..."
        )
    }
    
    // MARK: - Category Filter Picker
    
    /// Picker para filtrar por categoría
    private var categoryFilterPicker: some View {
        Picker("Categoría", selection: $viewModel.selectedCategory) {
            Text("Todas")
                .tag(nil as String?)
            
            ForEach(Emoji.categories, id: \.self) { category in
                Text(category)
                    .tag(category as String?)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    // MARK: - Emoji List
    
    /// Lista de emojis con todas las funcionalidades
    private var emojiList: some View {
        List {
            // ForEach permite usar onDelete y onMove
            ForEach(viewModel.filteredEmojis) { emoji in
                EmojiRow(emoji: emoji, viewModel: viewModel)
            }
            // MARK: onDelete - Eliminar deslizando
            .onDelete { indexSet in
                deleteEmojis(at: indexSet)
            }
            // MARK: onMove - Reordenamiento con drag & drop
            .onMove { source, destination in
                viewModel.moveEmoji(from: source, to: destination)
            }
        }
        .listStyle(.insetGrouped)
        // Mensaje cuando no hay resultados
        .overlay {
            if viewModel.filteredEmojis.isEmpty {
                emptyStateView
            }
        }
    }
    
    // MARK: - Empty State View
    
    /// Vista que se muestra cuando no hay emojis
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("No se encontraron emojis")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Intenta con otro término de búsqueda o agrega un nuevo emoji")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            if !viewModel.searchText.isEmpty || viewModel.selectedCategory != nil {
                Button("Limpiar filtros") {
                    viewModel.searchText = ""
                    viewModel.selectedCategory = nil
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
    }
    
    // MARK: - Helper Methods
    
    /// Elimina emojis en los índices especificados
    /// - Parameter indexSet: Conjunto de índices a eliminar
    /// - Note: Ajusta los índices según el filtrado actual
    private func deleteEmojis(at indexSet: IndexSet) {
        // Obtener los emojis filtrados a eliminar
        let emojisToDelete = indexSet.map { viewModel.filteredEmojis[$0] }
        
        // Eliminar cada emoji del array principal
        for emoji in emojisToDelete {
            viewModel.deleteEmoji(emoji)
        }
    }
}

// MARK: - AddEmojiSheet

/// Sheet para agregar un nuevo emoji
struct AddEmojiSheet: View {
    @Environment(\.dismiss) private var dismiss
    let viewModel: EmojiViewModel
    
    // MARK: Form State
    @State private var selectedEmoji = "😀"
    @State private var description = ""
    @State private var selectedCategory = "Smileys"
    @State private var isFavorite = false
    
    var body: some View {
        NavigationStack {
            Form {
                // MARK: Emoji Selection
                Section(header: Text("Emoji")) {
                    HStack {
                        Text(selectedEmoji)
                            .font(.system(size: 60))
                        
                        Spacer()
                        
                        // En producción, aquí podrías usar un Emoji Picker
                        TextField("Emoji", text: $selectedEmoji)
                            .font(.title)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                    }
                }
                
                // MARK: Description
                Section(header: Text("Descripción")) {
                    TextEditor(text: $description)
                        .frame(height: 80)
                }
                
                // MARK: Category
                Section(header: Text("Categoría")) {
                    Picker("Categoría", selection: $selectedCategory) {
                        ForEach(Emoji.categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                // MARK: Favorite Toggle
                Section {
                    Toggle("Marcar como favorito", isOn: $isFavorite)
                }
            }
            .navigationTitle("Nuevo Emoji")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Botón Cancelar
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                // Botón Guardar
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        saveEmoji()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
    
    // MARK: - Validation
    
    /// Valida que el formulario esté completo
    private var isFormValid: Bool {
        !selectedEmoji.isEmpty &&
        !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // MARK: - Actions
    
    /// Guarda el nuevo emoji
    private func saveEmoji() {
        let newEmoji = Emoji(
            emoji: selectedEmoji,
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            category: selectedCategory,
            isFavorite: isFavorite,
            createdDate: Date()
        )
        
        viewModel.addEmoji(newEmoji)
        dismiss()
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
