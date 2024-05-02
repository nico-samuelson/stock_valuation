import SwiftUI
import Auth

struct StockView : View {
    @State var search: String = ""
    
    @State var selectedWatchlist: String = "Watchlist 1"
    @State var selectedSegment: String = "Watchlist"
    @Binding var currentUser: User?
//    @State var watchlists = [Watchlist] = [
//        Watchlist(id: UUID.init(), name: "Watchlist 1"),
//        Watchlist(id: UUID.init(), name: "Watchlist 2"),
//    ]
    
    
    @State var addAlertShown: Bool = false
    @State var newWatchlistName: String = ""
    
    let companies : [Company] = [
        Company(id: UUID.init(), logo: "cafe-style-hot-coffee-recipe-1", symbol: "BBCA", name: "Bank Central Asia Tbk.", sector: "Financial", price: 9725, changes: 0.97, sharesOut: 0, dcf: 0, per: 0, pbv: 0, evEbitda: 0, isPublic: true, beta: 1, saveLocal: true),
        Company(id: UUID.init(), logo: "cafe-style-hot-coffee-recipe-1", symbol: "BBRI", name: "Bank Rakyat Indonesia Tbk.",sector: "Financial", price: 4800, changes: 0.97, sharesOut: 0, dcf: 0, per: 0, pbv: 0, evEbitda: 0, isPublic: true, beta: 1, saveLocal: true),
        Company(id: UUID.init(), logo: "cafe-style-hot-coffee-recipe-1", symbol: "BBNI", name: "Bank Negara Indonesia Tbk.",sector: "Financial", price: 5500, changes: 0.97, sharesOut: 0, dcf: 0, per: 0, pbv: 0, evEbitda: 0, isPublic: true, beta: 1, saveLocal: true),
        Company(id: UUID.init(), logo: "cafe-style-hot-coffee-recipe-1", symbol: "BMRI", name: "Bank Mandiri Tbk.", sector: "Financial", price: 6500, changes: 0.97, sharesOut: 0, dcf: 0, per: 0, pbv: 0, evEbitda: 0, isPublic: true, beta: 1, saveLocal: true),
    ]
    
    var body : some View {
        NavigationStack{
            List {
                Picker("Watchlist", selection: $selectedSegment) {
                    Text("Watchlist").tag("Watchlist")
                    Text("All Stock").tag("All Stock")
                }
                .pickerStyle(SegmentedPickerStyle())
                .listRowSeparator(.hidden)
                
                HStack(alignment: .center){
                    Picker("", selection: $selectedWatchlist) {
                        Text("Watchlist 1").tag("Watchlist 1")
                        Text("Watchlist 2").tag("Watchlist 2")
                        Text("Add new watchlist").tag("Add new watchlist")
                    }
                    .onChange(of: selectedWatchlist) { value in
                        if (selectedWatchlist == "Add new watchlist") {
                            addAlertShown = true
                        }
                    }
                    .alert(Text("New watchlist"), isPresented: $addAlertShown, actions: {
                        TextField("Watchlist Name", text: $newWatchlistName)
                        Button("Add", action: {
                            selectedWatchlist = "Watchlist 1"
                        })
                        Button("Cancel", role: .cancel, action: {
                            selectedWatchlist = "Watchlist 1"
                        })
                    }, message: {
                        Text("Enter a name for this watchlist")
                    })
                    .labelsHidden()
                    .pickerStyle(MenuPickerStyle())
                }
                
                ForEach(0..<companies.count, id:\.self) { i in
                    StockList(company: companies[i])
                }.onDelete(perform: { indexSet in
                    print(indexSet)
                })
            }
            .listStyle(.plain)
            .navigationTitle("Stocks")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $search, prompt: "Search stocks")
            .toolbar{
                Menu(content: {
                    Section {
                        Button(role:.destructive, action: {
                            currentUser = nil
                        }) {
                            Label("Logout", systemImage: "rectangle.portrait.and.arrow.forward")
                        }
                    }
                }, label: {
                    Button {} label: {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .aspectRatio(contentMode: .fit)
                    }
                })
            }
        }
    }
}


//#Preview {
//    StockView()
//        .modelContainer(for: Item.self, inMemory: true)
//}
