import SwiftUI

struct ParallaxItem: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let systemImageName: String
    let description: String
}

struct ParallaxSheetExample: View {
    private let items: [ParallaxItem] = [
        .init(title: "Frappe", systemImageName: "cup.and.saucer.fill", description: "Delicioso frappe con crema batida y sirope."),
        .init(title: "Waffle", systemImageName: "fork.knife", description: "Waffle crujiente con toppings a tu gusto."),
        .init(title: "Paleta", systemImageName: "snowflake", description: "Paletas heladas de sabores naturales.")
    ]

    @State private var selected: ParallaxItem?

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(items) { item in
                        Button {
                            selected = item
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: item.systemImageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 56, height: 56)
                                    .padding(12)
                                    .background(.pink.opacity(0.15))
                                    .clipShape(RoundedRectangle(cornerRadius: 14))

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.title)
                                        .font(.headline)
                                    Text(item.description)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(2)
                                }
                                Spacer()
                                Image(systemName: "chevron.up")
                                    .font(.headline)
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                            .background(.thinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationTitle("Ejemplo Sheet + Parallax")
        }
        .sheet(item: $selected) { item in
            ParallaxSheetDetailView(item: item)
                .presentationDetents([.medium, .large])
                .presentationBackground(.ultraThinMaterial)
        }
    }
}

struct ParallaxSheetDetailView: View {
    let item: ParallaxItem
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView(showsIndicators: false) {
            GeometryReader { geo in
                let y = geo.frame(in: .global).minY
                let baseHeight: CGFloat = 300
                Image(systemName: item.systemImageName)
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, .pink)
                    .frame(width: 180)
                    .frame(maxWidth: .infinity)
                    .frame(height: max(baseHeight + y, baseHeight))
                    .background(
                        LinearGradient(colors: [.pink, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .offset(y: (y > 0) ? -y : 0)
                    .clipped()
            }
            .frame(height: 300)
            .overlay(alignment: .topLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.white, .black.opacity(0.35))
                        .padding(12)
                }
            }

            VStack(alignment: .leading, spacing: 12) {
                Text(item.title)
                    .font(.largeTitle.bold())
                Text("Descripción")
                    .font(.title3.weight(.semibold))
                Text(item.description)
                    .foregroundStyle(.secondary)

                Button {
                    // Acción de hacer pedido
                } label: {
                    Text("Hacer pedido")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.pink)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.top, 8)
            }
            .padding()
        }
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    ParallaxSheetExample()
}
