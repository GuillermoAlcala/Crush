//
//  ContentView.swift
//  Crush
//
//  Created by GuillermoChaconAlcala on 15/10/26.
//

import SwiftUI

struct ContentView: View {
    //creando una instancia del struct para usarla como boton
    let item = [RowModel(img: .recurso21, isSheet: .frappe,
                         width: 200, heigth: 200),
                RowModel(img: .waffleSencillo, isSheet: .waffles
                         ,width: 200, heigth: 200),
                RowModel(img: .paletas, isSheet: .paletas,width: 200,heigth: 200)]

    @State private var isActiveSheet: ActiveSheets? = nil
  //  @State private var isSelected : RowModel? = nil
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    ScrollView(.vertical,showsIndicators: false){
                        ForEach(item){ items in
                            RowCardPhotos(
                                recurso: items.img,action: {isActiveSheet = items.isSheet},
                                width: items.width,height: items.heigth
                            )
                            
                        }
                }
                .frame(maxWidth: .infinity)
                }
            }.sheet(item: $isActiveSheet){ sh in
                sh.destinationsView
            }
                .navigationTitle("Bienvenido")
                .navigationBarTitleDisplayMode(.inline)
                .CustomToolbarOptionsMenu(
                    MenuTitle: "Nuevo", MenuImage: "plus",
                    options: [MenuOption(title: "Waffle",
                                         image: "seal",
                                         actions: {
                                             //agregar acción
                }),
                MenuOption(title: "Paleta",
                           image: "triangle",
                           actions: {
                               //agregar acción
                })])
//                .background{
//                    ImageBackground(imageName: "logo")
//
//                }
                
        }
            
    }
}
//
//#Preview {
//    NavigationStack{
//        ContentView(sheets: .frappe)
//    }
//}
