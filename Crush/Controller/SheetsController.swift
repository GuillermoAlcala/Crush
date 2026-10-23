//
//  SheetsController.swift
//  Crush
//
//  Created by GuillermoChaconAlcala on 19/10/26.
//

import Foundation
import SwiftUI

enum ActiveSheets : String, CaseIterable, Identifiable, Hashable{
    case paletas = "Paletas"
    case waffles = "Waffles"
    case frappe = "Frappe"
    
    var id: Self{self}
    
    
    @ViewBuilder
    var destinationsView: some View{
        switch self{
        case .frappe:
            Text("Frappe")
            
        case .paletas:
            Text("paletas")
            
        case .waffles:
            Text("waffle")
        }
    }
}
