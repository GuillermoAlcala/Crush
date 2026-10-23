
import SwiftUI

struct ConnectionTab: View {
    @State private var items : TabsController = .incio
    
    var body: some View {
    TabView(selection: $items, content: {
        ForEach(TabsController.allCases){ val in
            Tab(val.rawValue, systemImage: val.icons, value: val, content: {
                val.TabViewDestinations
            })
            
        }
    }).tint(.indianPink)
    }
}

#Preview {
    ConnectionTab()
}
