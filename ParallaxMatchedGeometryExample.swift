import SwiftUI

struct MGItem: Identifiable, Equatable, Hashable {
    let id = UUID()
    let title: String
    let systemImageName: String
    let description: String
}

struct ParallaxMatchedGeometryExample: View {
    @Namespace private var ns
    @State private var selected: MGItem?

    private let items: [MGItem] = [
        .init(title: "Frappe", systemImageName: "cup.and.saucer.fill", description: "Delicioso frappe con crema batida y sirope."),
        .init(title: "Waffle", systemImageName: "fork.knife", description: "Waffle crujiente con toppings a tu gusto."),
        .init(title: "Paleta", systemImageName: "snowflake", description: "Paletas heladas de sabores naturales.")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(items) { item in
                        ParallaxCard(item: item, ns: ns) {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                                selected = item
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("MatchedGeometry + Parallax")
            .navigationDestination(item: $selected) { it in
                MatchedDetailParallaxView(item: it, ns: ns)
            }
        }
    }
}

struct ParallaxCard: View {
    let item: MGItem
    var ns: Namespace.ID
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: item.systemImageName)
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, .pink)
                    .frame(width: 56)
                    .padding(14)
                    .background(
                        LinearGradient(colors: [.pink, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .matchedGeometryEffect(id: item.id, in: ns)

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.headline)
                    Text(item.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                Spacer()
                Image(systemName: "chevron.right")
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

struct MatchedDetailParallaxView: View {
    let item: MGItem
    var ns: Namespace.ID
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView(showsIndicators: false) {
            GeometryReader { geo in
                let y = geo.frame(in: .global).minY
                let baseHeight: CGFloat = 320
                ZStack {
                    LinearGradient(colors: [.pink, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                    Image(systemName: item.systemImageName)
                        .resizable()
                        .scaledToFit()
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, .pink)
                        .frame(width: 200)
                        .matchedGeometryEffect(id: item.id, in: ns)
                }
                .frame(height: max(baseHeight + y, baseHeight))
                .offset(y: (y > 0) ? -y : 0)
                .clipped()
            }
            .frame(height: 320)
            .overlay(alignment: .topLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left.circle.fill")
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
    ParallaxMatchedGeometryExample()
}
