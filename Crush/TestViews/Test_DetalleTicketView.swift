import SwiftUI
import SwiftData


struct Test_DetalleTicketView: View {
    let venta: VentaModel
    
    var body: some View {
        List {
            Section("Información de la Venta") {
                LabeledContent("Folio", value: venta.folio)
                LabeledContent("Fecha", value: venta.fecha.formatted(date: .long, time: .standard))
                LabeledContent("Método de Pago", value: venta.metodoPago.rawValue)
            }
            
            Section("Productos Vendidos") {
                ForEach(venta.producto, id: \.productName) { item in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.productName)
                                .font(.headline)
                            if !item.sabor.isEmpty {
                                Text("Sabor: \(item.sabor)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Text("Toppings: \(item.toppingLiquido) / \(item.toppingSeco)")
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                        }
                        Spacer()
                        Text(item.precio, format: .currency(code: "MXN"))
                            .font(.subheadline.bold())
                    }
                }
            }
            
            Section("Desglose Financiero") {
                LabeledContent("Subtotal", value: venta.subtotal, format: .currency(code: "MXN"))
                LabeledContent("IVA (16%)", value: venta.iva, format: .currency(code: "MXN"))
                LabeledContent("Total Final", value: venta.total, format: .currency(code: "MXN"))
                    .bold()
            }
        }
        .navigationTitle(venta.folio)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview{
    Test_DetalleTicketView(venta: .init(id: UUID(), folio: "", fecha: .now, metodoPago: .efectivo, subtotal: 22.99, iva: 33.2, total: 22.1, producto: [""] as! [ItemVendido]))
}
