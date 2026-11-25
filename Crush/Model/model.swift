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
            case emanens = "M&m"
            case kranquis = "Kranquis"
            case chocoretas = "Chocoretas"
            case panditas = "Panditas"
            case gomitas = "Gomitas"
            case manguitos = "Manguitos"
            case ninguno = "Ninguno"
            
            var id: Self{self}
        }
        
    }
    
    enum Paletas: String, CaseIterable,Identifiable{
        case agua = "Agua"
        case crema = "Crema"
        
        var id: Self{self}
        
        enum SaborPaletasAgua: String, CaseIterable, Identifiable{
            case mango = "Mango"
            case piña = "Piña"
            case limon = "Limón"
            
            var id: Self{self}
            
           
        }
        enum SaborPaletasCrema: String, CaseIterable, Identifiable{
            case cacahuate = "Cacahuate"
            case pistace = "Pistache"
            case fresa = "Fresa"
            case chocolate = "Chocolate"
            case oreo = "Oreo"
            
            var id: Self{self}
        }
        
        enum ToppingsPaletasAgua: String, CaseIterable, Identifiable{
            case chamoy = "Chamoy"
            case tajin = "Valentina"
            
            var id: Self{self}
        }
        
        //pendiente definir como asignar los toppings secos
        
        
    }
    
    enum TamanoFrappe: String, CaseIterable, Identifiable{
        case normal = "Normal"
        case sencillo = "Sencillo"
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
    
    enum BolasDeNieve: String, CaseIterable, Identifiable{
        case cero = "Sin bola"
        case uno = "1" // si el waffle  es sencilla una bola
        case dos = "2" // si el waffle  es doble, dos bolas
        var id: String{rawValue}
        
    }
    
    enum SaborFrappe: String,CaseIterable, Identifiable{
        case tradicional = "Tradicional"
        case moka = "Moka"
        case oreo = "Oreo"
        case nutella = "Nutella"
        var id: Self{self}

    
    }
    
    
}

// 🚩entidad persistente para almacenar productos en base de datos
@Model
final class CartItemModel {
    var id: UUID
    var productoNombre: String
    var sabor: String
    var toppingLiquido: String
    var toppingSeco: String
    var extraInfo: String
    var precio: Double
    var cantidad: Int
    var fechaCreacion: Date

    init(
        productoNombre: String,
        sabor: String,
        toppingLiquido: String = "Ninguno",
        toppingSeco: String = "Ninguno",
        extraInfo: String = "",
        precio: Double,
        cantidad: Int = 1
    ) {
        self.id = UUID()
        self.productoNombre = productoNombre
        self.sabor = sabor
        self.toppingLiquido = toppingLiquido
        self.toppingSeco = toppingSeco
        self.extraInfo = extraInfo
        self.precio = precio
        self.cantidad = cantidad
        self.fechaCreacion = Date()
    }
}




@Model
final class VentaModel{
    var id: UUID
    var folio: String
    var fecha: Date
    var metodoPago: MetodoPago
    var subtotal: Double
    var iva: Double
    var total: Double
    var producto: [ItemVendido]
    var timeStamp = TimeStamp.semana.rawValue
    var diasSemana = DiasSemana.lunes.rawValue
    
    init(id: UUID, folio: String, fecha: Date, metodoPago: MetodoPago, subtotal: Double, iva: Double, total: Double,
         producto: [ItemVendido],timeStamp: String = TimeStamp.semana.rawValue, diasSemana: String = DiasSemana.lunes.rawValue) {
        self.id = id
        self.folio = folio
        self.fecha = fecha
        self.metodoPago = metodoPago
        self.subtotal = subtotal
        self.iva = iva
        self.total = total
        self.producto = producto
        self.timeStamp = timeStamp
        self.diasSemana = diasSemana
    }
    
    
    enum MetodoPago: String, CaseIterable, Identifiable, Codable{
        case efectivo = "Efectivo"
        case tarjeta = "Tarjeta"
        var id: Self{self}
    }
    enum TimeStamp: String, CaseIterable, Identifiable{
        case semana = "Semana"
        case mes = "Mes"
        case anio = "Año"
        case todo = "Todo"
        var id: Self{self}
    }
    enum DiasSemana: String, CaseIterable, Identifiable{
        case lunes = "Lunes"
        case martes = "Martes"
        case miercoles = "Miércoles"
        case jueves = "Jueves"
        case viernes = "Viernes"
        case sabado = "Sábado"
        case domingo = "Domingo"
        var id: Self{self}
    }
    
    //crear variable computada: Total Periodo
    
    
}


struct ItemVendido: Codable{
    var productName: String
    var sabor: String
    var toppingLiquido: String
    var toppingSeco: String
    var extraInfo: String
    var precio: Double
    var cantiad: Double
}
