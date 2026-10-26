//
//  RowCardItems.swift
//  Crush
//
//  Created by GuillermoChaconAlcala on 20/10/26.
// Aquí estará alojado el diseño de la card

import Foundation
import SwiftUI


//
//  InicioViewModel.swift
//  Crush
//
//  Created by GuillermoChaconAlcala on 16/10/26.
//

import Foundation
import SwiftUI


struct RowModelCard: Identifiable{
    let id = UUID()
    let productName: ModelList.Producto
    let img: ImageResource
    let isSheet : ActiveSheets
    let width: CGFloat
    let height: CGFloat
    
}


struct RowCard: View {
    let productName: ModelList.Producto
    let recurso: ImageResource
    let width: CGFloat
    let height: CGFloat
    let action : () -> Void
    @State private var selectedType: ModelList.TiposWaffle = .sencillo
    @State private var selectecTypeToppingsLiquidos: ModelList.Toppings.SaboresLiquidos = .cajeta
    @State private var selectecTypeToppingsSecos: ModelList.Toppings.SaboresSecos = .ninguno
    
    @State private var selectecPaletaToppingLiquidi: ModelList.Paletas.ToppingsPaletasAgua = .chamoy
    @State private var selectTypePaleta : ModelList.Paletas = .agua
    
    @State private var selectTypeFrappe: ModelList.TamanoFrappe = .normal
    @State private var isDisabled: Bool = false

    //Exceptio cuando la paleta sea agua y seleccione sabores secos
    private var toppingsSecosDisponibles: [ModelList.Toppings.SaboresSecos] {
        if productName == .paletas && selectTypePaleta == .agua {
            return [.panditas, .gomitas, .manguitos, .ninguno]
        }
        return ModelList.Toppings.SaboresSecos.allCases
    }
    
    //Exceptio cuando la paleta sea crema y seleccione sabores líquidos
    private var toppingsLiquidosDisponibles: [ModelList.Toppings.SaboresLiquidos] {
        if productName == .paletas && selectTypePaleta == .crema {
            return [.nutella,.mermelada,.lechera,.cajeta,.ninguno]
        }
        return ModelList.Toppings.SaboresLiquidos.allCases
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 12){
            Button(action:action){
                Image(recurso)
                .resizable()
                .scaledToFit()
                .frame(width: width,height: height)
             //   .frame(width: 110,height: 110)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            }.buttonStyle(.plain)
            

            VStack(alignment: .leading,spacing: 12){
                Text(productName.rawValue)
                    .font(.title3)
                    .bold()
                Divider()
                
                HStack{
                    Text("Tipos")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                    //MARK: -  Validando Paleta
                    ValidationType
                    
                }//hstack
                HStack(){ // probando
                    Text("T/liquidos")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                    //MARK: - VALIDANDO TOPPING LIQUIDO
                    LiquidToppingsPicker
                    
                    
                }
                
                HStack(){
                    Text("T/secos")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                    DryToppingsPicker
                    
                    
                }

            }
            .padding(.vertical,8)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
                // 🔹 1. Padding mayor para dar más aire alrededor del contenido
                .padding(7)
                // 🔹 2. Altura mínima garantizada para que entren todos los controles
                .frame(minHeight: 190)
                // 🔹 3. Fondo relleno con sombra suave y borde
                
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(.secondarySystemGroupedBackground))
                        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
    }
    
    @ViewBuilder
    var ValidationType: some View{
        //MARK: -  Validando Paleta
        
        if productName == .paletas{
            Picker("", selection: $selectTypePaleta){
                ForEach(ModelList.Paletas.allCases, id: \.self) { tipoPaleta in
                    Text(tipoPaleta.rawValue).tag(tipoPaleta)
                }
                
            }.pickerStyle(.menu)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            //MARK: -  Validando Waffle
            
        }else if productName == .waffles{
            Picker("", selection: $selectedType){
                ForEach(ModelList.TiposWaffle.allCases, id: \.self) { opcion in
                    Text(opcion.rawValue).tag(opcion)
                }
            }
            .labelsHidden()
            .pickerStyle(.menu)
        } else{
            //MARK: -  Validando Frappe
            Picker("", selection: $selectTypeFrappe){
                ForEach(ModelList.TamanoFrappe.allCases, id: \.self) { frappe in
                    Text(frappe.rawValue).tag(frappe)
                }
             
            }
            .labelsHidden()
            .pickerStyle(.menu)
        }
    }
    
    @ViewBuilder
    var LiquidToppingsPicker: some View {
        if productName == .paletas && selectTypePaleta == .agua {
            Picker("", selection: $selectecPaletaToppingLiquidi){
                ForEach(ModelList.Paletas.ToppingsPaletasAgua.allCases, id: \.self) { paletaL in
                    Text(paletaL.rawValue).tag(paletaL)
                }
            }
            .pickerStyle(.menu)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
          //  .disabled(productName == .paletas && selectTypePaleta == .crema)
            
        } else {
            Picker("", selection: $selectecTypeToppingsLiquidos){
                ForEach(toppingsLiquidosDisponibles, id: \.self) { topping in
                    Text(topping.rawValue).tag(topping)
                }
            }
            .pickerStyle(.menu)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            // Recalibra la selección al cambiar a Paleta de Crema si el sabor actual no está en la lista reducida
                    .onChange(of: selectTypePaleta) { _, newType in
                        if productName == .paletas && newType == .crema {
                            if !toppingsLiquidosDisponibles.contains(selectecTypeToppingsLiquidos) {
                                selectecTypeToppingsLiquidos = .cajeta
                            }
                        }
                    }
        }
    }

    @ViewBuilder
    var DryToppingsPicker: some View {
        Picker("", selection: $selectecTypeToppingsSecos) {
            ForEach(toppingsSecosDisponibles, id: \.self) { secos in
                Text(secos.rawValue).tag(secos)
            }
        }
        .pickerStyle(.menu)
        .lineLimit(1)
        .minimumScaleFactor(0.8)
        // Se recalibra la opción seleccionada al cambiar a Paleta de Agua
        .onChange(of: selectTypePaleta){ _, new in
            if productName == .paletas && new == .agua{
                if !toppingsSecosDisponibles.contains(selectecTypeToppingsSecos) {
                    selectecTypeToppingsSecos = .panditas
                            }
            }
            
        }
    }
}
#Preview {
}

/*
  waffle normal es el puro pan, solo puede llevar topping líquido y seco.
 
 -puede llevar un topping líquido
 -puede llevar un topping seco
 o sin nada.
 
 
 waffle sencillo solo lleva una bola de helado
 de topping cualquiera ( líquido y seco) o líquido o seco
 
 waffle doble es lo mismo solo se incluye dos bolas de helado.
 
 
 */
// el sencillo no pueda tener dos bolas
// bola 1
//bola 2 = valor default ninguno



/*
 // Propiedad computada para evaluar si debe bloquearse
 private var esPaletaDeAgua: Bool {
     productName == .paleta && selectTypePaleta == .agua
 }

 @ViewBuilder
 var DryToppingsPicker: some View {
     Picker("", selection: $selectecTypeToppingsSecos) {
         ForEach(ModelList.Toppings.SaboresSecos.allCases, id: \.self) { secos in
             Text(secos.rawValue).tag(secos)
         }
     }
     .pickerStyle(.menu)
     .lineLimit(1)
     .minimumScaleFactor(0.8)
     // ✏️ Bloquea únicamente las Paletas de Agua
     .disabled(esPaletaDeAgua)
 }
 */
