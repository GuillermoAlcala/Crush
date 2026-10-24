//
//  model.swift
//  Crush
//
//  Created by GuillermoChaconAlcala on 19/10/26.
//

import Foundation
import SwiftData


@Model
class ModelList{
    var id = UUID()
    var producto   = Producto.paletas.rawValue
    var tipoWaffle = TiposWaffle.sencillo.rawValue
    var tipoTopping = Toppings.liquido.rawValue
    var saborLiquido = Toppings.SaboresLiquidos.cajeta.rawValue
    var saborSeco = Toppings.SaboresSecos.almendra.rawValue
    
    var tipoPaleta = Paletas.agua.rawValue
    var saborPaletasAgua = Paletas.ToppingsPaletasAgua.chamoy.rawValue
    var toppingsPaletasCrema = Toppings.SaboresSecos.nuez.rawValue
    
    var tamanoFrappe = TamanoFrappe.grande.rawValue
    var tipoFrappe = TiposFrappe.mango.rawValue
    
    var date            = Date.now
    var price           : Double
    var qty             : Int = 1
    
    init(id: UUID = UUID(),
         producto: String = Producto.paletas.rawValue,
         tipoWaffle: String = TiposWaffle.sencillo.rawValue,
         tipoTopping: String = Toppings.liquido.rawValue,
         saborLiquido: String = Toppings.SaboresLiquidos.cajeta.rawValue,
         saborSeco: String = Toppings.SaboresSecos.almendra.rawValue,
         tipoPaleta: String = Paletas.agua.rawValue,
         saborPaletasAgua: String = Paletas.ToppingsPaletasAgua.chamoy.rawValue,
         toppingPaletasCrema: String = Toppings.SaboresSecos.nuez.rawValue,
         tamanoFrappe: String = TamanoFrappe.grande.rawValue,
         tipoFrappe: String = TiposFrappe.tradicional.rawValue,
         date: Date = Date(),
         price: Double,
         qty: Int) {
        
        self.id = id
        self.producto = producto
        self.tipoWaffle = tipoWaffle
        self.tipoTopping = tipoTopping
        self.saborLiquido = saborLiquido
        self.saborSeco = saborSeco
        self.tipoPaleta = tipoPaleta
        self.saborPaletasAgua = saborPaletasAgua
        self.toppingsPaletasCrema = toppingPaletasCrema
        self.tamanoFrappe = tamanoFrappe
        self.tipoFrappe = tipoFrappe
        
        self.date = date
        self.price = price
        self.qty = qty
    }
    
    enum Producto: String, CaseIterable, Identifiable{
        case waffles = "Waffles"
        case paletas = "Paletas"
        case frappes = "Frappes"
        
        var id: Self{self}
    }
    enum TiposWaffle:String,Identifiable,CaseIterable{
        case normal = "Normal"
        case sencillo = "Sencillo"
        case doble = "Doble"
        
        var id: Self{self}
    }
    
    enum Toppings: String, CaseIterable, Identifiable{
        case liquido = "Líquido"
        case seco = "Seco"
        case ambos = "Ambos"
        
        var id: Self{self}
        
        
        enum SaboresLiquidos: String, CaseIterable, Identifiable{
            case nutella = "Nutella"
            case mermelada = "Mermelada"
            case cajeta = "Cajeta"
            case lechera = "Lechera"
            case chocolateHershies = "Hershies"
            case chocolateHershiesFresa = "Hershies Fresa"
            case ninguno = "Ninguno"
            var id: Self{self}
        }
        
        
        enum SaboresSecos: String, CaseIterable, Identifiable{
            case chispas = "Chispas"
            case nuez = "Nuez"
            case almendra = "Almendra"
            case emanens = "m&m"
            case kranquis = "Kranquis"
            case chocoretas = "Chocoretas"
            case ninguno = "Ninguno"
            var id: Self{self}
        }
        
    }
    
    enum Paletas: String, CaseIterable,Identifiable{
        case agua = "Agua"
        case crema = "Crema"
        
        var id: Self{self}
        
        enum PaletasAgua: String, CaseIterable, Identifiable{
            case mango = "Mango"
            case piña = "Piña"
            case fresa = "Fresa"
            
            var id: Self{self}
            
            enum PaletasCrema: String, CaseIterable, Identifiable{
                case cacahuate = "Cacahuate"
                case pistace = "Pistache"
                case fresa = "Fresa"
                case chocolate = "Chocolate"
                case oreo = "Oreo"
                
                var id: Self{self}
            }
        }
        
        enum ToppingsPaletasAgua: String, CaseIterable, Identifiable{
            case gomitas = "Gomitas"
            case chamoy = "Chamoy"
            case tajin = "Valentina"
            
            var id: Self{self}
        }
        
        //pendiente definir como asignar los toppings secos
        
        
    }
    
    enum TamanoFrappe: String, CaseIterable, Identifiable{
        case normal = "Normal"
        case grande = "Grande"
        var id: Self{self}
    }
    
    enum TiposFrappe: String, CaseIterable, Identifiable{
        case tradicional = "Tradicional"
        case oreo = "Oreo"
        case nutella = "Nutella"
        case moka = "Moka"
        case mango = "Mango"
        var id: Self{self}
    }
    
    
    
}
