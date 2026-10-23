//
//  CrushApp.swift
//  Crush
//
//  Created by GuillermoChaconAlcala on 15/10/26.
//

import SwiftUI
import SwiftData
@main
struct CrushApp: App {
    var body: some Scene {
        WindowGroup {
            ConnectionTab()
                .modelContainer(for: ModelList.self, inMemory: true)
        }
    }
}
