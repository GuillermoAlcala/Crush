//
//  InicioViewModel.swift
//  Crush
//
//  Created by GuillermoChaconAlcala on 16/10/26.
//

import Foundation
import SwiftUI


struct RowModel: Identifiable{
    let id = UUID()
    let img: ImageResource
    let isSheet : ActiveSheets
    let width: CGFloat
    let heigth: CGFloat
}


struct RowCardPhotos: View {
    let recurso: ImageResource
    let action : () -> Void
    let width: CGFloat
    let height: CGFloat
    var body: some View {
        VStack(alignment: .leading){
         //   HStack{
                Button(action:action){
                    Image(recurso)
                        .resizable()
                        .scaledToFit()
                        .frame(width: width, height: height)
                        
                }
        //    }
        }
    }
    
    
}

#Preview {
    NavigationStack{
        RowCardPhotos(recurso: .recurso21.self,action: {},width: 200, height: 200)
    }
}

