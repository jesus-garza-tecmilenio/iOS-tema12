//
//  EmojiRow.swift
//  Tema12Swift
//
//  Created by JESUS GARZA on 06/11/25.
//

import SwiftUI

// MARK: - EmojiRow View

/// Vista personalizada que representa una fila de emoji en la lista
/// Demuestra: celdas personalizadas, SwipeActions y ContextMenu
struct EmojiRow: View {
    
    // MARK: - Properties
    
    /// El emoji a mostrar
    let emoji: Emoji
    
    /// ViewModel para realizar acciones
    let viewModel: EmojiViewModel
    
    /// Estado para mostrar el sheet de edición
    @State private var isEditingDescription = false
    
    /// Texto temporal para editar la descripción
    @State private var editedDescription = ""
    
    /// Estado para mostrar el share sheet
    @State private var showShareSheet = false
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: 12) {
            // MARK: Emoji Icon
            Text(emoji.emoji)
                .font(.system(size: 40))
                .frame(width: 50, height: 50)
            
            // MARK: Emoji Info
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(emoji.description)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    // Indicador de favorito
                    if emoji.isFavorite {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                    }
                }
                
                HStack {
                    // Categoría
                    Text(emoji.category)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(categoryColor.opacity(0.2))
                        )
                    
                    Spacer()
                    
                    // Fecha de creación
                    Text(emoji.createdDate, style: .date)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
        // MARK: - SwipeActions (Trailing - derecha)
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            // Acción: Eliminar (destructiva)
            Button(role: .destructive) {
                viewModel.deleteEmoji(emoji)
            } label: {
                Label("Eliminar", systemImage: "trash")
            }
            
            // Acción: Favorito
            Button {
                viewModel.toggleFavorite(emoji)
            } label: {
                Label(
                    emoji.isFavorite ? "Quitar favorito" : "Favorito",
                    systemImage: emoji.isFavorite ? "star.slash" : "star.fill"
                )
            }
            .tint(.orange)
            
            // Acción: Copiar
            Button {
                viewModel.copyToClipboard("\(emoji.emoji) - \(emoji.description)")
            } label: {
                Label("Copiar", systemImage: "doc.on.doc")
            }
            .tint(.blue)
        }
        // MARK: - SwipeActions (Leading - izquierda)
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            // Acción: Compartir
            Button {
                showShareSheet = true
            } label: {
                Label("Compartir", systemImage: "square.and.arrow.up")
            }
            .tint(.green)
        }
        // MARK: - ContextMenu (menú contextual con long press)
        .contextMenu {
            // Editar descripción
            Button {
                editedDescription = emoji.description
                isEditingDescription = true
            } label: {
                Label("Editar descripción", systemImage: "pencil")
            }
            
            // Duplicar emoji
            Button {
                viewModel.duplicateEmoji(emoji)
            } label: {
                Label("Duplicar", systemImage: "plus.square.on.square")
            }
            
            Divider()
            
            // Copiar
            Button {
                viewModel.copyToClipboard("\(emoji.emoji) - \(emoji.description)")
            } label: {
                Label("Copiar", systemImage: "doc.on.doc")
            }
            
            // Compartir
            Button {
                showShareSheet = true
            } label: {
                Label("Compartir", systemImage: "square.and.arrow.up")
            }
            
            Divider()
            
            // Alternar favorito
            Button {
                viewModel.toggleFavorite(emoji)
            } label: {
                Label(
                    emoji.isFavorite ? "Quitar de favoritos" : "Agregar a favoritos",
                    systemImage: emoji.isFavorite ? "star.slash" : "star.fill"
                )
            }
            
            Divider()
            
            // Eliminar (destructivo)
            Button(role: .destructive) {
                viewModel.deleteEmoji(emoji)
            } label: {
                Label("Eliminar", systemImage: "trash")
            }
        }
        // MARK: - Sheet para editar descripción
        .sheet(isPresented: $isEditingDescription) {
            EditDescriptionSheet(
                description: $editedDescription,
                onSave: {
                    viewModel.updateEmojiDescription(emoji, newDescription: editedDescription)
                    isEditingDescription = false
                },
                onCancel: {
                    isEditingDescription = false
                }
            )
        }
        // MARK: - Sheet para compartir
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: viewModel.shareEmoji(emoji))
        }
    }
    
    // MARK: - Computed Properties
    
    /// Color según la categoría del emoji
    private var categoryColor: Color {
        switch emoji.category {
        case "Smileys": return .yellow
        case "Nature": return .green
        case "Food": return .orange
        case "Objects": return .blue
        case "Symbols": return .purple
        default: return .gray
        }
    }
}

// MARK: - EditDescriptionSheet

/// Sheet para editar la descripción de un emoji
struct EditDescriptionSheet: View {
    @Binding var description: String
    let onSave: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Descripción del Emoji")) {
                    TextEditor(text: $description)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Editar Descripción")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        onCancel()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        onSave()
                    }
                    .disabled(description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

// MARK: - ShareSheet (UIViewControllerRepresentable)

/// Wrapper para UIActivityViewController (compartir nativo de iOS)
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No necesita actualización
    }
}

// MARK: - Preview

#Preview {
    List {
        EmojiRow(
            emoji: Emoji.sampleEmojis[0],
            viewModel: EmojiViewModel()
        )
        EmojiRow(
            emoji: Emoji.sampleEmojis[1],
            viewModel: EmojiViewModel()
        )
    }
}
