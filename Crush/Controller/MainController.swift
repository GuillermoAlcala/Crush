//
//  MainController.swift
//  Crush
//
//  Created by GuillermoChaconAlcala on 16/10/26.
//

import Foundation
import SwiftUI

struct ImageBackground: View {
    // Nombre de la imagen guardada en Assets.xcassets
    var imageName: String = "logo"
    var body: some View {
        Image(imageName)
            .resizable()
            .opacity(0.50)
            .offset(x: 10, y: 100)
            .frame(width: 150,height: 150)
    }
}
extension Color {
    static let skyBlue = Color(hex: "95C8EC")
    static let pastelPink = Color(hex: "F8C8D8")
    static let warmYellow = Color(hex: "FCE4A6")
    static let cyanAqua = Color(hex: "1FC7C1")
    static let deepBlue = Color(hex: "2C3E6B")
    static let magentaPurple = Color(hex: "82386E")
    static let ligthCoral = Color(hex: "F08080")
    static let indianPink = Color(hex: "FF8A8A")
    

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6:
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 1)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1.0
        )
    }
}

// el Foreach me marcaba error porqué me faltaba el protocolo Identifiable, así como el id
struct MenuOption: Identifiable{
    let id = UUID()
    let title: String
    let image: String
    let actions : () -> Void
}
struct CustomMenuToolbar: ViewModifier{
    let menuTitle: String
    let menuImage: String
    let options: [MenuOption]
    //let titleButton:String
    //let imageButton: String
    func body(content: Content) -> some View {
        content
            .toolbar{
                Menu(menuTitle, systemImage: menuImage){
                    ForEach(options){ option in
                        Button(option.title, systemImage: option.image, action: option.actions)
                        
                    }
    //             Button(title, systemImage: image){} Qué pasa si necesito un nuevo botón? tendría que agregar más lets?
                }.buttonStyle(.glass)
                
            }
    }
}

extension View{
    func CustomToolbarOptionsMenu(MenuTitle:String, MenuImage:String, options: [MenuOption]) -> some View{
        self.modifier(CustomMenuToolbar(menuTitle: MenuTitle, menuImage: MenuImage, options: options))
    }
}


