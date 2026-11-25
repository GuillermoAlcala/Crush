
import SwiftUI
import SwiftData

struct ConnectionTab: View {
    @State private var items : TabsController = .incio
    @Query private var itemsCarrito: [CartItemModel]
    var body: some View {
    TabView(selection: $items, content: {
        ForEach(TabsController.allCases){ val in
            Tab(val.rawValue, systemImage: val.icons, value: val, content: {
                val.TabViewDestinations
            })
            .badge(val == .carrito ? itemsCarrito.count: 0)
          //  .tag(val) ios 17
            
        }
    }).tint(.indianPink)
            
    }
}
//
//#Preview {
//    ConnectionTab()
//}
