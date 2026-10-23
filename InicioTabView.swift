import SwiftUI

struct InicioTabView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Pantalla de Inicio")
                    .font(.largeTitle)
                    .bold()
                Text("Contenido de ejemplo para la pestaña Inicio.")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .navigationTitle("Inicio")
        }
    }
}

#Preview {
    InicioTabView()
}
