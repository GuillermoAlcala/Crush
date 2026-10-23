//
//  ContentView2.swift
//  Crush
//
//  Created by GuillermoChaconAlcala on 19/10/26.
//
import SwiftUI
import SwiftData

struct ContentView2: View {
    // MARK: - Data
    @Query(sort: \ModelList.date, order: .reverse) var allData: [ModelList]
    @Environment(\.modelContext)  var modelContent
    
    
    @State private var isActiveSheet: ActiveSheets? = nil
    
    
    let item = [
        RowModel(img: .recurso21, isSheet: .frappe,
                         width: 150, heigth: 150),
        RowModel(img: .waffleSencillo, isSheet: .waffles
                         ,width: 150, heigth: 150),
        RowModel(img: .paletas, isSheet: .paletas,
                         width: 150,heigth: 150)]
    
    let newModel = [
        RowModelCard(productName: .frappes, img: .píxel,isSheet: .frappe,
                     width: 110,height: 110),
        RowModelCard(productName: .paletas, img: .paletas,isSheet: .paletas,
                     width: 110,height: 110),
        RowModelCard(productName: .waffles, img: .waffleSencillo,isSheet: .waffles,
                     width: 110,height: 110)
    ]
    
    
    var body: some View {
        NavigationStack{
                List{
                    ForEach(newModel) { model in
                        RowCard(
                            productName: model.productName,
                            recurso: model.img,
                            width: model.width,
                            height: model.height,
                            action: {
                            isActiveSheet = model.isSheet

                        })
                        .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
//                    ForEach(item){ items in
//                        RowCardPhotos(recurso: items.img,
//                                      action: {
//                            //agregar State
//                            isActiveSheet = items.isSheet
//                        },
//                                      width: items.width,
//                                      height:items.heigth)
//                        
//                        
//                        .padding(.vertical,20)
//                        
//                    }
                   // .listRowSeparator(.automatic)
                  //  .listRowBackground(Color.clear)
                    
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            
            .sheet(item: $isActiveSheet){ sheet in
                sheet.destinationsView
                
            }
            .navigationTitle("Crush")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
}

//#Preview {
//    ContentView2()
//}



/*
 import SwiftUI
 import SwiftData

 struct ContentView2: View {
     // MARK: - Data
     @Query(sort: \ModelList.date, order: .reverse) var allData: [ModelList]
     @Environment(\.modelContext) var modelContent
     
     @State private var isActiveSheet: ActiveSheets? = nil
     
     let newModel = [
         RowModelCard(productName: "Frappe", img: .recurso21, isSheet: .frappe, width: 110, height: 110),
         RowModelCard(productName: "Paletas", img: .paletas, isSheet: .paletas, width: 110, height: 110),
         RowModelCard(productName: "Waffles", img: .waffleSencillo, isSheet: .waffles, width: 110, height: 110)
     ]
     
     var body: some View {
         NavigationStack {
             List {
                 ForEach(newModel) { model in
                     RowCard(
                         productName: model.productName,
                         recurso: model.img,
                         width: model.width,
                         height: model.height,
                         action: {
                             isActiveSheet = model.isSheet
                         }
                     )
                     // ✏️ Ajuste de insets para evitar encimamientos
                     .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                     .listRowSeparator(.hidden)
                     .listRowBackground(Color.clear)
                 }
             }
             .listStyle(.plain)
             .scrollContentBackground(.hidden)
             // ✏️ CAMBIO CLAVE: .navigationTitle DENTRO del NavigationStack
             .navigationTitle("Crush")
             .sheet(item: $isActiveSheet) { sheet in
                 sheet.destinationsView
             }
         }
     }
 }
 */
