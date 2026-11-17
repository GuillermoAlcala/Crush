//
//  Ventas.swift
//  Crush
//
//  Created by GuillermoChaconAlcala on 16/10/26.
//

import SwiftUI
import SwiftData
import Charts
struct VentasView: View {
    
    struct dummy:Identifiable,Hashable {
        var id = UUID()
        let date: String
        let product_name: String
        let paymethod: String
        let qty: Int
        let ticket: String
        let price: Double
    }
    
    let item = [
        dummy(date: "lun", product_name: "paleta", paymethod: "Tarjeta", qty: 10, ticket: "CR-0142",price: 167.99),
        dummy(date: "lun", product_name: "paleta", paymethod: "Tarjeta", qty: 9, ticket: "CR-0143",price: 17.33),
        dummy(date: "mar", product_name: "paleta", paymethod: "efectivo", qty: 40, ticket: "CR-0144",price: 100.10),
        dummy(date: "mier", product_name: "helado", paymethod: "efectivo",qty: 33, ticket: "CR-0145",price: 9.98),
        dummy(date: "mier", product_name: "frappe", paymethod: "Tarjeta",qty: 49, ticket: "CR-0146",price: 67.00)
        
    ]
    @Query(sort: \CartItemModel.fechaCreacion, order: .reverse) private var ventas: [CartItemModel]
    @Query(sort: \VentaModel.fecha, order: .reverse) private var ventaModel: [VentaModel]
    @State private var timeStamp : VentaModel.TimeStamp = .semana
    
    
    var body: some View {
        NavigationStack{
            VStack{
                Picker("Periodo", selection: $timeStamp){
                    ForEach(VentaModel.TimeStamp.allCases){ time in
                        Text(time.rawValue).tag(time)
                    }
                    
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                .padding()
                
                //MARK: - BAR GRAPHIC
                VStack(alignment: .leading, spacing: 10){
                    Group{
                        Text("Total del perdiodo")
                            .foregroundStyle(.secondary)
                            .font(.footnote)
                        Text("MX $1,284.00")
                            .font(.title2)
                    }
                    Chart(item) { sales in
                        BarMark(x: .value("Fecha", sales.date),
                                y: .value("Cantidad",sales.qty))
                        .cornerRadius(7)
                        .foregroundStyle(by: .value("Payment", sales.paymethod))
                        //.position(by: .value("Método", sales.paymethod))
                        
                        
                    }
                    .chartForegroundStyleScale([
                        "Tarjeta": Color.ligthCoral,
                        "efectivo": Color.deepBlue
                    ])
                    .frame(height: 200)
                    .padding()
                }.padding()
            } //VStack principal
            List{
                Section(header:Text("Tickets registrados"),content: {
                    ForEach(item,id: \.self){ t in
                        NavigationLink(destination: EmptyView(), label: {
                            VStack(alignment: .leading){
                                Text(t.ticket)
                                HStack{
                                    Text(t.date)
                                    Text("*")
                                    Text(t.paymethod)
                                    Spacer()
                                    Text("\(t.price)")
                                }
                            }//vstack
                            
                        })
                            
                            
                        }
                    }
                )}
                .navigationTitle("Ventas")
        }
        
    }
}

#Preview {
    VentasView()
}
