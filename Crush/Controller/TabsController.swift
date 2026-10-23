import Foundation
import SwiftUI

enum TabsController:String, CaseIterable, Identifiable,Hashable{
    case incio = "Inicio"
    case ventas = "Ventas"
    case inventario = "Inventario"
    var id: String{rawValue}
    
    var icons:String{
        switch self{
        case .incio : "house"
        case .ventas: "creditcard"
        case .inventario: "chart.bar.xaxis.ascending"
        }
    }
    
    @ViewBuilder
     var TabViewDestinations: some View{
        switch self{
        case.incio :
            ContentView2()
        case .ventas:
            VentasView()
        case .inventario:
            InventarioView()
        }
    }
    
    }
