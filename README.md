# 📚 Emoji Dictionary - Tema 12: Tablas II

Una aplicación educativa en SwiftUI que demuestra conceptos avanzados de listas (List) en iOS.

## 📱 Descripción del Proyecto

**Emoji Dictionary** es una aplicación interactiva que permite crear y gestionar un diccionario personal de emojis con descripciones detalladas. La app fue diseñada con fines educativos para enseñar conceptos avanzados de SwiftUI relacionados con listas y tablas.

### ¿Para qué sirve?

- **Aprendizaje práctico**: Demuestra conceptos del Tema 12 con código real y funcional
- **Gestión de emojis**: Permite agregar, editar, eliminar y organizar emojis
- **Búsqueda inteligente**: Filtrado en tiempo real por texto y categoría
- **Persistencia de datos**: Guarda automáticamente todos los cambios

---

## 🎯 Conceptos Aprendidos (Tema 12)

### 1. **Celdas Personalizadas**
- Creación de vistas customizadas para cada fila (`EmojiRow`)
- Composición de elementos con `HStack` y `VStack`
- Diseño responsivo y adaptable

### 2. **SwipeActions (Acciones de Deslizamiento)**
- **Trailing (derecha)**: Eliminar, Favorito, Copiar
- **Leading (izquierda)**: Compartir
- Múltiples acciones con diferentes colores
- Control de `allowsFullSwipe`

### 3. **ContextMenu (Menú Contextual)**
- Activación con long press (presión larga)
- Acciones: Editar, Duplicar, Copiar, Compartir, Eliminar
- Uso de `Divider` para separar grupos de acciones
- Acciones destructivas con `role: .destructive`

### 4. **Reordenamiento con Drag & Drop**
- Modificador `onMove` para arrastrar y soltar
- Modo edición activado con `EditButton`
- Persistencia automática del nuevo orden

### 5. **Edición Inline de Datos**
- Actualización de descripciones en tiempo real
- Validación de entrada de usuario
- Sheets modales para edición completa

### 6. **Actualización Automática de Datos**
- Patrón MVVM con `@Observable`
- Persistencia con UserDefaults
- Sincronización automática entre vistas

### 7. **Estilos Avanzados de List**
- `.listStyle(.insetGrouped)` para diseño moderno
- `.searchable()` para barra de búsqueda nativa
- `Picker` con `.segmented` para filtros
- Vista de estado vacío (Empty State)

---

## 🏗️ Estructura del Proyecto

### Patrón de Arquitectura: MVVM

```
Tema12Swift/
├── Emoji.swift                 # Model
├── EmojiViewModel.swift        # ViewModel
├── EmojiRow.swift             # Vista de Fila
├── ContentView.swift          # Vista Principal
└── Tema12SwiftApp.swift       # Entry Point
```

### 1. **Emoji.swift (Model)**
- Define la estructura de datos de un emoji
- Conforma `Identifiable` y `Codable`
- Incluye datos de ejemplo y categorías predefinidas
- **Responsabilidad**: Solo datos, sin lógica de negocio

### 2. **EmojiViewModel.swift (ViewModel)**
- Maneja toda la lógica de negocio
- Operaciones CRUD (Create, Read, Update, Delete)
- Filtrado y búsqueda
- Persistencia con UserDefaults
- **Responsabilidad**: Lógica de negocio y estado

### 3. **EmojiRow.swift (Vista de Fila)**
- Celda personalizada para cada emoji
- SwipeActions en ambos lados
- ContextMenu con múltiples opciones
- Indicadores visuales (favorito, categoría, fecha)
- **Responsabilidad**: Presentación de una fila

### 4. **ContentView.swift (Vista Principal)**
- NavigationStack principal
- List con ForEach
- Barra de búsqueda
- Picker de categorías
- Toolbar con acciones
- **Responsabilidad**: Composición de la UI principal

### Flujo de Datos

```
User Action → View → ViewModel → Model
                ↑                   ↓
                └─── Observable ────┘
```

1. Usuario interactúa con la vista
2. Vista llama métodos del ViewModel
3. ViewModel actualiza el Model
4. @Observable notifica cambios automáticamente
5. Vista se actualiza reactivamente

---

## 🚀 Cómo Usar la App

### Agregar Emojis

1. Toca el botón **+** en la barra superior
2. Ingresa el emoji (puedes copiar desde teclado)
3. Escribe una descripción
4. Selecciona una categoría
5. Opcional: marca como favorito
6. Toca **Guardar**

### Buscar y Filtrar

- **Búsqueda por texto**: 
  - Toca la barra de búsqueda
  - Escribe cualquier término
  - Busca en emoji, descripción y categoría

- **Filtrar por categoría**:
  - Usa el Picker segmentado en la parte superior
  - Selecciona: Todas, Smileys, Nature, Food, Objects, Symbols

- **Limpiar filtros**:
  - Toca "Limpiar filtros" en la vista vacía

### Editar Descripciones

**Método 1: ContextMenu**
1. Presiona largo (long press) sobre un emoji
2. Selecciona "Editar descripción"
3. Modifica el texto
4. Toca "Guardar"

**Método 2: Agregar a Favoritos**
- Desliza a la izquierda → toca ⭐ Favorito
- O usa el ContextMenu

### Reordenar Emojis

1. Toca el botón **Edit** en la esquina superior izquierda
2. Arrastra el ícono ≡ de cada emoji
3. Suelta en la nueva posición
4. Toca **Done** para salir del modo edición

### Usar Acciones

**SwipeActions (deslizar)**:
- **Deslizar a la izquierda**:
  - 🗑️ Eliminar (rojo)
  - ⭐ Favorito (naranja)
  - 📄 Copiar (azul)

- **Deslizar a la derecha**:
  - 📤 Compartir (verde)

**ContextMenu (presión larga)**:
- ✏️ Editar descripción
- ➕ Duplicar
- 📄 Copiar
- 📤 Compartir
- ⭐ Agregar/Quitar de favoritos
- 🗑️ Eliminar

### Resetear Datos

- Toca el ícono 🔄 en la barra superior
- Los datos volverán a los valores de ejemplo

---

## 💻 Requisitos Técnicos

### Plataforma
- **iOS**: 15.0 o superior
- **Xcode**: 13.0 o superior
- **Swift**: 5.5 o superior
- **SwiftUI**: Framework principal

### Dependencias
- **Ninguna**: Proyecto standalone sin dependencias externas
- Usa solo frameworks nativos de Apple

### Capacidades del Proyecto
- ✅ Compilación sin warnings
- ✅ Código bien documentado
- ✅ Patrón MVVM implementado
- ✅ Persistencia con UserDefaults
- ✅ Interfaz adaptable (Light/Dark mode)

---

## 🎓 Uso Educativo

### Para Profesores

Este proyecto puede usarse para:
- Explicar el patrón MVVM en SwiftUI
- Demostrar SwipeActions y ContextMenu
- Enseñar persistencia de datos
- Mostrar buenas prácticas de código
- Ejemplificar MARK comments

### Para Estudiantes

Aprenderás:
- Cómo estructurar una app con MVVM
- Técnicas avanzadas de List en SwiftUI
- Gestión de estado con @Observable
- Persistencia con UserDefaults
- Validación de entrada de usuario
- Integración con el sistema (compartir, portapapeles)

### Ejercicios Propuestos

1. **Nivel Básico**:
   - Agregar más categorías de emojis
   - Cambiar los colores de las categorías
   - Agregar más datos de ejemplo

2. **Nivel Intermedio**:
   - Implementar ordenamiento (por fecha, alfabético, favoritos)
   - Agregar contador de emojis por categoría
   - Implementar modo oscuro personalizado

3. **Nivel Avanzado**:
   - Migrar a Core Data
   - Implementar sincronización con iCloud
   - Agregar widget para iOS
   - Exportar/importar emojis en JSON

---

## 🔮 Mejoras Futuras

### Persistencia Avanzada
- [ ] Migrar de UserDefaults a Core Data
- [ ] Sincronización con iCloud (CloudKit)
- [ ] Exportar a JSON/CSV
- [ ] Importar desde archivos

### Funcionalidades
- [ ] Historial de cambios (undo/redo)
- [ ] Estadísticas de uso
- [ ] Etiquetas personalizadas
- [ ] Notas adicionales por emoji

### UI/UX
- [ ] Animaciones personalizadas
- [ ] Temas de color personalizables
- [ ] Widget de iOS para favoritos
- [ ] Soporte para iPad (multitarea)
- [ ] Accesibilidad mejorada

### Integración
- [ ] Compartir a redes sociales
- [ ] Extensión de teclado personalizada
- [ ] Siri shortcuts
- [ ] Complicaciones de watchOS

---

## 📚 Recursos Adicionales

### Documentación Apple
- [SwiftUI List](https://developer.apple.com/documentation/swiftui/list)
- [Observable Macro](https://developer.apple.com/documentation/observation)
- [UserDefaults](https://developer.apple.com/documentation/foundation/userdefaults)

### Conceptos Clave
- **MVVM**: Model-View-ViewModel
- **@Observable**: Macro de Swift 5.9+ para reactividad
- **Codable**: Protocolo para serialización
- **UserDefaults**: Persistencia ligera de datos

---

## 👨‍💻 Autor

**JESUS GARZA**  
Proyecto educativo - Tema 12: Tablas II  
Fecha: 06/11/2025

---

## 📄 Licencia

Este proyecto es de uso educativo libre. Puedes usarlo, modificarlo y distribuirlo para fines de aprendizaje.

---

## 🙏 Agradecimientos

Creado con fines educativos para enseñar conceptos avanzados de SwiftUI y desarrollo iOS.

**¡Feliz aprendizaje! 🚀📱**
