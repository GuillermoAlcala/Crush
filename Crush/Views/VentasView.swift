//
//  VentasView.swift
//  Crush
//
//  Created by GuillermoChaconAlcala on 07/11/26.
// La sección de navigationLink se habilitará en la versión 2 

import SwiftUI
import SwiftData
import Charts


struct VentasView: View {
    @State private var timeStamp: VentaModel.TimeStamp = .semana
    @Query(sort:\VentaModel.fecha, order: .reverse) private var records: [VentaModel]
    
    
    //variable computada para ventas filtradas
    private var ventasFiltradas: [VentaModel]{
        let calendar = Calendar.current
        let now = Date()
        
        return records.filter{ venta in
            switch timeStamp {
            case .semana:
                return calendar.isDate(venta.fecha, equalTo: now, toGranularity: .weekOfYear)
            case .mes:
                return calendar.isDate(venta.fecha, equalTo: now, toGranularity: .month)
            case .anio:
                return calendar.isDate(venta.fecha, equalTo: now, toGranularity: .year)
            case .todo:
                return true
            }
            
        }
    }
    
    //cálculo del total acumulado en el periodo visible
    private var totalVentasPeriodo: Double{
        ventasFiltradas.reduce(0){$0 + $1.total}
    }
    var body: some View {
        NavigationStack{
            VStack(alignment:.leading, spacing: 8){
                PickerValues
                UpLegend
                GraphicDesign
            }.padding(.horizontal)
            Spacer()
            //List
            RowItems
                .navigationTitle("Ventas")
        }
    }
    
    
    @ViewBuilder
    private var PickerValues: some View{
        //pendiente lógica
        Picker("Picker", selection: $timeStamp){
            ForEach(VentaModel.TimeStamp.allCases){ time in
                Text(time.rawValue).tag(time)
            }
        }.pickerStyle(.segmented)
        //    .padding(.horizontal)
    }
    
    @ViewBuilder
    private var UpLegend: some View{
        //pendiente lógica
        VStack(alignment: .leading, spacing: 8){
            Group{
                Text("Total del perido")
                    .foregroundStyle(.secondary)
                    .font(.footnote)
                Text("\(totalVentasPeriodo.formatted(.currency(code: "MXN")))")
                    .font(.title.bold())
                    .foregroundStyle(Color.deepBlue)
            }
        }.padding()
    }
    
    @ViewBuilder
    private var GraphicDesign: some View{
        Chart{
            ForEach(ventasFiltradas){ ventas in
                BarMark(x: .value("Día", ventas.fecha,unit: .day),
                        y: .value("Monto", ventas.total))
                .foregroundStyle(by: .value("Método", ventas.metodoPago.rawValue))
                .cornerRadius(4)
                
            }
        }
        .chartForegroundStyleScale([
            "Tarjeta": Color.ligthCoral,
            "Efectivo": Color.deepBlue
        ])
        .chartXAxis {
            AxisMarks(values: .stride(by: .day)) { _ in
                AxisValueLabel(format: .dateTime.weekday(.abbreviated))
            }
        }
        .frame(height: 240)
        .padding(.horizontal)
       // .background(Color(.secondarySystemBackground))
       // .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
        
        
    }
    
    @ViewBuilder
    private var RowItems: some View{
        List{
            Section("Tickets Registrados (\(ventasFiltradas.count))"){
                ForEach(ventasFiltradas){ val in
                //    NavigationLink(destination: TicketDetailView()){
                        HStack{
                        VStack(alignment: .leading, spacing: 4){
                            Text(val.folio)
                                .font(.subheadline).bold()
                            
                            Text("\(val.fecha.formatted(date:.abbreviated, time: .shortened)) • \(val.metodoPago.rawValue)")
                                .font(.footnote)
                        }//Vstack
                        .foregroundStyle(.secondary)
                        Spacer()
                            Text(val.total,format: .currency(code: "MXN"))
                                .font(.subheadline.bold())
                                .foregroundStyle(Color.ligthCoral)
                            
                        }
                        
                        
             //       } //link
                }
            }
            .listStyle(.insetGrouped)
        }
    }
}

#Preview {
    VentasView()
}


/*
 import SwiftUI

 struct DetalleTicketView: View {
     let venta: VentaModel
     
     var body: some View {
         List {
             Section("Información de la Venta") {
                 LabeledContent("Folio", value: venta.folio)
                 LabeledContent("Fecha", value: venta.fecha.formatted(date: .long, time: .standard))
                 LabeledContent("Método de Pago", value: venta.metodoPago.rawValue)
             }
             
             Section("Productos Vendidos") {
                 ForEach(venta.productos, id: \.productoNombre) { item in
                     HStack {
                         VStack(alignment: .leading, spacing: 4) {
                             Text(item.productoNombre)
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
 */
