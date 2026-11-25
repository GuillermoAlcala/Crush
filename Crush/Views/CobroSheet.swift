//
//  CobroSheet.swift
//  Crush
//
//  Created by GuillermoChaconAlcala on 08/11/26.
//

import SwiftUI
import SwiftData

struct CobroSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // Consulta para calcular el folio autoincrementable (#CRUSH-001)
    @Query private var ventasExistentes: [VentaModel]
    
    let cartItems: [CartItemModel]
    
    @State private var metodoPago: VentaModel.MetodoPago = .tarjeta
    @State private var montoEntregadoTexto: String = ""
    
    // Cálculos financieros
    private var subtotal: Double {
        cartItems.reduce(0) { $0 + ($1.precio * Double($1.cantidad)) }
    }
    private var iva: Double { subtotal * 0.16 }
    private var total: Double { subtotal + iva }
    
    private var montoEntregado: Double {
        Double(montoEntregadoTexto) ?? 0.0
    }
    
    private var cambio: Double {
        max(0, montoEntregado - total)
    }
    
    private var esEfectivoValido: Bool {
        metodoPago == .tarjeta || (metodoPago == .efectivo && montoEntregado >= total)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Selector de Método de Pago
                Picker("Método de Pago", selection: $metodoPago) {
                    Text("Efectivo").tag(VentaModel.MetodoPago.efectivo)
                    Text("Tarjeta").tag(VentaModel.MetodoPago.tarjeta)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // Resumen de Total
                VStack(spacing: 4) {
                    Text("Total a Cobrar")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(total, format: .currency(code: "MXN"))
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(.blue)
                }
                .padding(.vertical, 8)
                
                // Sección de Efectivo y Cambio
                if metodoPago == .efectivo {
                    VStack(spacing: 16) {
                        TextField("Monto recibido ($)", text: $montoEntregadoTexto)
                            .keyboardType(.decimalPad)
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        // Botones de billetes rápidos
                        HStack(spacing: 10) {
                            Button("$100") { agregarBillete(100) }
                            Button("$200") { agregarBillete(200) }
                            Button("$500") { agregarBillete(500) }
                            Button("Exacto") { montoEntregadoTexto = String(format: "%.2f", total) }
                        }
                        .buttonStyle(.bordered)
                        
                        // Display de Cambio
                        HStack {
                            Text("Cambio a Entregar:")
                                .font(.headline)
                            Spacer()
                            Text(cambio, format: .currency(code: "MXN"))
                                .font(.title3.bold())
                                .foregroundStyle(montoEntregado >= total ? .green : .secondary)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGroupedBackground)))
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                // Botón para procesar la venta
                Button(action: procesarVenta) {
                    Text("Confirmar y Registrar Venta")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(esEfectivoValido ? Color.green : Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(!esEfectivoValido)
                .padding()
            }
            .navigationTitle("Finalizar Cobro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
            }
        }
    }
    
    private func agregarBillete(_ valor: Double) {
        montoEntregadoTexto = String(format: "%.2f", valor)
    }

    // Proceso de transformación y vaciado
    private func procesarVenta() {
        // 1. Generar Folio consecutivo (#CRUSH-001)
        let folioNuevo = String(format: "#CRUSH-%03d", ventasExistentes.count + 1)
        
        // 2. Congelar snapshot de productos del carrito
        let productosVendidoSnapshot = cartItems.map { item in
            ItemVendido(
                productName: item.productoNombre,
                sabor: item.sabor,
                toppingLiquido: item.toppingLiquido,
                toppingSeco: item.toppingSeco,
                extraInfo: item.extraInfo,
                precio: item.precio,
                cantiad: Double(item.cantidad)
            )
        }
        
        // 3. Crear el ticket de VentaModel
        let nuevaVenta = VentaModel(
            id: UUID(),
            folio: folioNuevo,
            fecha: Date(),
            metodoPago: metodoPago,
            subtotal: subtotal,
            iva: iva,
            total: total,
            producto: productosVendidoSnapshot
        )
        
        // 4. Guardar venta en SwiftData
        modelContext.insert(nuevaVenta)
        
        // 5. Vaciar los ítems del carrito
        for item in cartItems {
            modelContext.delete(item)
        }
        
        // 6. Cerrar el modal
        dismiss()
    }
}
//#Preview {
//    CobroSheet()
//}
