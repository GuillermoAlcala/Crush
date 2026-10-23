import SwiftUI

struct BuscarTabView: View {
    @State private var query: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                TextField("Buscar...", text: $query)
                    .textFieldStyle(.roundedBorder)
                List {
                    if query.isEmpty {
                        Text("Empieza a escribir para buscar...")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(0..<5, id: \.self) { index in
                            Text("Resultado \(index + 1) para '\(query)'")
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Buscar")
        }
    }
}

#Preview {
    BuscarTabView()
}
