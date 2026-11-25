import SwiftUI

struct AjustesTabView: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true

    var body: some View {
        NavigationStack {
            Form {
                Section("General") {
                    Toggle("Notificaciones", isOn: $notificationsEnabled)
                }
                Section("Acerca de") {
                    LabeledContent("Versión", value: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-")
                }
            }
            .navigationTitle("Ajustes")
        }
    }
}

#Preview {
    AjustesTabView()
}
