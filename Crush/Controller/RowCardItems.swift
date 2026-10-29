//
//  RowCardItems.swift
//  Crush
//
//  Created by GuillermoChaconAlcala on 20/10/26.
// Aquí estará alojado el diseño de la card

import Foundation
import SwiftUI

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
    let productName: ModelList.Producto
    let recurso: ImageResource
    let width: CGFloat
    let height: CGFloat
    let action: () -> Void
    
    // Estados activos de la vista
    @State private var selectedSaborPaleta: SaborPaleta = .agua(.limon)
    @State private var selectedType: ModelList.TiposWaffle = .sencillo
    @State private var selectecTypeToppingsLiquidos: ModelList.Toppings.SaboresLiquidos = .ninguno
    @State private var selectecTypeToppingsSecos: ModelList.Toppings.SaboresSecos = .ninguno
    @State private var selectecPaletaToppingLiquidi: ModelList.Paletas.ToppingsPaletasAgua = .chamoy
    @State private var selectTypePaleta: ModelList.Paletas = .agua
    @State private var selectTypeFrappe: ModelList.TamanoFrappe = .normal
    
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
                Text(productName.rawValue)
                    .font(.title3)
                    .bold()
                
                Divider()
                
                HStack {
                    Text("Sabor")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                    ValidationType
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
            
        } else {
            Picker("", selection: $selectTypeFrappe) {
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

////quitar panditas, gomitas, manguitos en topping secos de crema


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
