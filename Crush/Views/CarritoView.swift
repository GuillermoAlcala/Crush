import SwiftUI
import SwiftData

struct CarritoView: View {
    @Environment(\.modelContext) private var modelContext
    
    // Lectura persistente de productos ordenados en SwiftData
    @Query(sort: \CartItemModel.fechaCreacion, order: .forward)
    private var cartItems: [CartItemModel]
    
    // 🚩 Estado para controlar la apertura del modal de cobro
    @State private var mostrarCobroSheet = false
    
    // Propiedades computadas para montos financieros
    private var subtotal: Double {
        cartItems.reduce(0) { $0 + ($1.precio * Double($1.cantidad)) }
    }
    private var iva: Double { subtotal * 0.16 }
    private var totalFinal: Double { subtotal + iva }

    var body: some View {
        VStack {
            if cartItems.isEmpty {
                ContentUnavailableView(
                    "Tu carrito está vacío",
                    systemImage: "cart",
                    description: Text("Agrega productos desde el menú de inicio.")
                )
            } else {
                List {
                    Section("Productos") {
                        ForEach(cartItems) { item in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.productoNombre)
                                        .font(.headline)
                                    
                                    // 💡 Muestra únicamente el nombre del sabor sin el prefijo "agua_" o "crema_"
                                    Text(item.sabor.components(separatedBy: "_").last ?? item.sabor)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    
                                    Text("Toppings: \(item.toppingLiquido) / \(item.toppingSeco)")
                                        .font(.caption2)
                                        .foregroundStyle(.tertiary)
                                    
                                    Text(item.fechaCreacion.formatted(date: .abbreviated, time: .standard))
                                        .font(.caption2)
                                        .foregroundStyle(.tertiary)
                                }
                                
                                Spacer()
                                
                                Text(item.precio * Double(item.cantidad), format: .currency(code: "MXN"))
                                    .font(.subheadline.bold())
                            }
                        }
                        .onDelete(perform: eliminarItems)
                    }
                    
                    Section("Resumen de Pago") {
                        HStack {
                            Text("Subtotal")
                            Spacer()
                            Text(subtotal, format: .currency(code: "MXN"))
                        }
                        HStack {
                            Text("IVA (16%)")
                            Spacer()
                            Text(iva, format: .currency(code: "MXN"))
                        }
                        HStack {
                            Text("Total")
                                .font(.headline)
                            Spacer()
                            Text(totalFinal, format: .currency(code: "MXN"))
                                .font(.headline)
                                .foregroundStyle(.blue)
                        }
                    }
                }
                .listStyle(.insetGrouped)
                
                // 🚩 Abre el modal CobroSheet en lugar de procesar la eliminación directamente
                Button(action: { mostrarCobroSheet = true }) {
                    Text("Pagar \(totalFinal, format: .currency(code: "MXN"))")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding()
            }
        }
        .navigationTitle("Carrito")
        // 🚩 Presentación del sheet de cobro pasando la lista de productos del carrito
        .sheet(isPresented: $mostrarCobroSheet) {
            CobroSheet(cartItems: cartItems)
        }
    }

    // Eliminación individual de ítems del carrito
    private func eliminarItems(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(cartItems[index])
        }
    }
}

#Preview {
    CarritoView()
}
