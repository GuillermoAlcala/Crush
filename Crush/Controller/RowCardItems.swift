//
//  RowCardItems.swift
//  Crush
//
//  Created by GuillermoChaconAlcala on 20/10/26.
// Aquí estará alojado el diseño de la card

import Foundation
import SwiftUI
import SwiftData

// MARK: - Wrapper de Sabores
enum SaborPaleta: Hashable, Identifiable {
    case agua(ModelList.Paletas.SaborPaletasAgua)
    case crema(ModelList.Paletas.SaborPaletasCrema)
    
    var id: String {
        switch self {
        case .agua(let sabor): return "agua_\(sabor.rawValue)"
        case .crema(let sabor): return "crema_\(sabor.rawValue)"
        }
    }
    
    var tipoPaleta: ModelList.Paletas {
        switch self {
        case .agua: return .agua
        case .crema: return .crema
        }
    }
}

// MARK: - Model
struct RowModelCard: Identifiable {
    let id = UUID()
    let productName: ModelList.Producto
    let img: ImageResource
    let isSheet: ActiveSheets
    let width: CGFloat
    let height: CGFloat
}

// MARK: - View
struct RowCard: View {
    
    // 🚩 probando
    @Environment(\.modelContext) private var modelContext
    // 🚩 probando función para mandar al carrito
    private func agregarAlCarrito() {
        let saborTexto: String
        let toppingLiquidoTexto: String
        let toppingSecoTexto: String
        let extraInfoTexto: String
        let precioCalculado: Double

        // 🚩 1. Evaluar topping líquido según el producto/tipo de paleta
        if productName == .paletas && selectTypePaleta == .agua {
            toppingLiquidoTexto = selectecPaletaToppingLiquidi.rawValue
        } else {
            toppingLiquidoTexto = selectecTypeToppingsLiquidos.rawValue
        }

        // 🚩 2. Leer topping seco seleccionado
        toppingSecoTexto = selectecTypeToppingsSecos.rawValue

        // 🚩 3. Determinar detalles según la categoría
        switch productName {
        case .paletas:
            saborTexto = selectedSaborPaleta.id
            extraInfoTexto = selectTypePaleta.rawValue
            precioCalculado = 35.0
            
        case .waffles:
            saborTexto = selectedType.rawValue
            extraInfoTexto = selectedType == .normal ? "Sin bolas" : "\(bolasNieve.rawValue) bola(s)"
            precioCalculado = selectedType == .doble ? 75.0 : 55.0
            
        case .frappes:
            saborTexto = saborFrappe.rawValue
            extraInfoTexto = tamanoFrappe.rawValue
            precioCalculado = tamanoFrappe == .grande ? 65.0 : 50.0
        }

        // 🚩 4. Crear e insertar en SwiftData
        let nuevoItem = CartItemModel(
            productoNombre: productName.rawValue,
            sabor: saborTexto,
            toppingLiquido: toppingLiquidoTexto,
            toppingSeco: toppingSecoTexto,
            extraInfo: extraInfoTexto,
            precio: precioCalculado
        )

        modelContext.insert(nuevoItem)
    }
    
    
    let productName: ModelList.Producto
    let recurso: ImageResource
    let width: CGFloat
    let height: CGFloat
    let action: () -> Void
    
    // Estados activos de la vista
    @State private var bolasNieve: ModelList.BolasDeNieve = .cero
    @State private var selectedSaborPaleta: SaborPaleta = .agua(.limon)
    @State private var selectedType: ModelList.TiposWaffle = .normal
    @State private var selectecTypeToppingsLiquidos: ModelList.Toppings.SaboresLiquidos = .cajeta
    @State private var selectecTypeToppingsSecos: ModelList.Toppings.SaboresSecos = .gomitas
    @State private var selectecPaletaToppingLiquidi: ModelList.Paletas.ToppingsPaletasAgua = .chamoy
    @State private var selectTypePaleta: ModelList.Paletas = .agua
    @State private var selectTypeFrappe: ModelList.TamanoFrappe = .normal
    @State private var saborFrappe: ModelList.SaborFrappe = .moka
    @State private var tamanoFrappe: ModelList.TamanoFrappe = .grande
    
    // Toppings líquidos según tipo de paleta
    private var toppingsLiquidosDisponibles: [ModelList.Toppings.SaboresLiquidos] {
        if productName == .paletas && selectTypePaleta == .crema {
            return [.nutella, .mermelada, .lechera, .cajeta, .ninguno]
        }
        return ModelList.Toppings.SaboresLiquidos.allCases
    }
    
    // Toppings secos según tipo de paleta
    private var newToppingsSecosDisponibles: [ModelList.Toppings.SaboresSecos] {
        guard productName == .paletas else {
            return ModelList.Toppings.SaboresSecos.allCases
        }
        switch selectTypePaleta {
        case .agua:
            return [.panditas, .gomitas, .manguitos, .ninguno]
            
        case .crema:
            let exclude: Set<ModelList.Toppings.SaboresSecos> = [.panditas, .gomitas, .manguitos]
            return ModelList.Toppings.SaboresSecos.allCases.filter {
                !exclude.contains($0)
            }
        }
    }
    
    
    //State para manipular el estado de selección
    @State private var isSelected : Bool = false
    
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Button(action: action) {
                Image(recurso)
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading, spacing: 12) {
                HStack{ //nuevo: probando insercicón del icono carrito
                    Text(productName.rawValue)
                        .font(.title3)
                        .bold()
                 Spacer()
//                    
//                    Button("Agregar al carrito", systemImage: isSelected == true ? "checkmark.circle.fill" : "circle.dotted"){
//                        isSelected.toggle()
//                    }.foregroundStyle(isSelected == true ? Color.indianPink : .gray)
//                        .buttonStyle(.plain)
                    
                    //MARK: - 🚩probando 02112026
                    Button(action: agregarAlCarrito) {
                                Label("", systemImage: "cart.badge.plus")
                                    .font(.subheadline.bold())
                                    .foregroundStyle(Color.indianPink)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                    }.buttonStyle(.plain)
                }
                Divider()
                
                HStack { //refactorizar a switch
                    if productName == .waffles{
                        Text("Tipo")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        ValidationType
                    }
                    
                    if productName == .paletas{
                        Text("Sabor")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        ValidationType
                    }else if productName == .frappes{
                        Text("Sabor")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        SaborFrappes
                    }
                    
                        }
                
                HStack{
                    if productName == .frappes{
                        Text("Tamaño")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        TamanoFrappe
                    }
                    if productName == .waffles{
                        Text("Bolas")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        BolasNieve
                    }
                    
                        }
                    
                HStack {
                    Text("T/liquidos")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                    LiquidToppingsPicker
                            }
                    
                          HStack {
                    Text("T/secos")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                    DryToppingsPicker
                }
            
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(7)
        .frame(minHeight: 190)
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
    
    // MARK: - Pickers
    @ViewBuilder
    var ValidationType: some View {
        if productName == .paletas {
            Picker("", selection: $selectedSaborPaleta) {
                Section("Paletas de Agua") {
                    ForEach(ModelList.Paletas.SaborPaletasAgua.allCases, id: \.self) { sabor in
                        Text(sabor.rawValue).tag(SaborPaleta.agua(sabor))
                    }
                }
                
                Section("Paletas de Crema") {
                    ForEach(ModelList.Paletas.SaborPaletasCrema.allCases, id: \.self) { sabor in
                        Text(sabor.rawValue).tag(SaborPaleta.crema(sabor))
                    }
                }
            }
            .pickerStyle(.menu)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .onChange(of: selectedSaborPaleta) { _, nuevoSabor in
                self.selectTypePaleta = nuevoSabor.tipoPaleta
            }
            
        } else if productName == .waffles {
            Picker("", selection: $selectedType) {
                ForEach(ModelList.TiposWaffle.allCases, id: \.self) { opcion in
                    Text(opcion.rawValue).tag(opcion)
                }
            }
            .labelsHidden()
            .pickerStyle(.menu)
            .onChange(of: selectedType){_, newType in
                switch newType{
                case .normal:
                    bolasNieve = .cero
                case .sencillo:
                    bolasNieve = .uno
                case .doble:
                    bolasNieve = .dos
                }
                
            }
            
        } else {
            Picker("", selection: $saborFrappe) {
                ForEach(ModelList.SaborFrappe.allCases, id: \.self) { frappe in
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
            Picker("", selection: $selectecPaletaToppingLiquidi) {
                ForEach(ModelList.Paletas.ToppingsPaletasAgua.allCases, id: \.self) { paletaL in
                    Text(paletaL.rawValue).tag(paletaL)
                }
            }
            .pickerStyle(.menu)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            
        } else {
            Picker("", selection: $selectecTypeToppingsLiquidos) {
                ForEach(toppingsLiquidosDisponibles, id: \.self) { topping in
                    Text(topping.rawValue).tag(topping)
                }
            }
            .pickerStyle(.menu)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
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
            ForEach(newToppingsSecosDisponibles, id: \.self) { secos in
                Text(secos.rawValue).tag(secos)
            }
        }
        .pickerStyle(.menu)
        .lineLimit(1)
        .minimumScaleFactor(0.8)
        .onChange(of: selectTypePaleta) { _, _ in
            if productName == .paletas {
                if !newToppingsSecosDisponibles.contains(selectecTypeToppingsSecos) {
                    selectecTypeToppingsSecos = newToppingsSecosDisponibles.first ?? .ninguno
                }
            }
        }
    }
    
    @ViewBuilder
    private var BolasNieve: some View{
        if selectedType == .normal{
            Picker("",selection: $bolasNieve){
                ForEach(ModelList.BolasDeNieve.allCases,id: \.self){ normal in
                    Text(normal.rawValue).tag(normal)
                }
            }
            .pickerStyle(.menu)
            .disabled(selectedType == .normal)
            
        }else if selectedType == .sencillo{
            Picker("",selection: $bolasNieve){
                ForEach(ModelList.BolasDeNieve.allCases.filter({$0 == .uno}),id: \.self){ sencillo in
                    Text(sencillo.rawValue).tag(sencillo)
                }
            }.pickerStyle(.menu)
        } else if selectedType == .doble{
            Picker("",selection: $bolasNieve){
                ForEach(ModelList.BolasDeNieve.allCases.filter({$0 == .dos}),id: \.self){ doble in
                    Text(doble.rawValue).tag(doble)
                }
            }.pickerStyle(.menu)
        }
    }
    
    @ViewBuilder
    private var TamanoFrappe: some View{
        Picker("",selection: $tamanoFrappe){
            ForEach(ModelList.TamanoFrappe.allCases,id:\.self){ tamano in
                Text(tamano.rawValue).tag(tamano)
                
            }
        }
        
    }
    
    @ViewBuilder
    private var SaborFrappes: some View{
        Picker("", selection: $saborFrappe){
            ForEach(ModelList.SaborFrappe.allCases){ sabores in
                Text(sabores.rawValue).tag(sabores)
                
            }
        }.pickerStyle(.menu)
    }
}

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

// falta poder seleccionar una bola para sencillo y dos bolas para doble
