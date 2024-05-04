import SwiftUI
import Auth

struct StockView : View {
    @Environment (\.dismiss) var dismiss
    @State var search: String = ""
    @State var selectedWatchlist: String = ""
    @State var selectedSegment: String = "Watchlist"
    @Binding var currentUser: User?
    @State var companies: [Company] = []
    @State var filtered: [Company] = []
    @State var watchlists: [Watchlist] = []
    @State var items: [WatchlistItem] = []
    @State var addAlertShown: Bool = false
    @State var newWatchlistName: String = ""
    @State var manageWlSheet: Bool = false
    @State var currentCompany: Company = Company()
    
    func fetchWatchlist() async throws {
        do {
            watchlists = try await supabase.database
                .from("Watchlist")
                .select()
                .match(["user_id": currentUser?.id])
                .execute()
                .value
            selectedWatchlist = watchlists[1].name
            print(watchlists)
            
        }
        catch {
            print(error)
        }
    }
    
    func fetchWatchlistItem() async throws {
        do {
            companies = try await supabase.rpc("fetch_watchlist_items", params: ["watchlist_name": selectedWatchlist])
                .execute()
                .value
            
            print(items)
            
            filtered = companies
        }
        catch {
            print(error)
        }
    }
    
    func searchItem() async throws {
        let watchlist = watchlists.filter{ $0.name == selectedWatchlist }
        do {
            filtered = try await supabase.rpc("search_company", params: [
                "watchlist": watchlist.count > 0 ? watchlist[0].id.uuidString : UUID.init().uuidString,
                "value": search.lowercased() != "" ? search.lowercased() : "*",
                "segment": selectedSegment
            ])
            .execute()
            .value
        }
        catch {
            print(error)
        }
    }
    
    func fetchAllCompany() async throws {
        do {
            filtered = try await supabase.database
                .from("Company")
                .select()
                .execute()
                .value
        }
        catch {
            print(error)
        }
    }
    
    func addWatchlist() async throws {
        do {
            let watchlist = Watchlist(
                id: UUID.init(),
                created_at: Date.now,
                user_id: currentUser?.id ?? UUID.init(),
                name: newWatchlistName
            )
            try await supabase.database.from("Watchlist").insert(watchlist).execute()
            
            watchlists.append(watchlist)
        }
        catch {
            print(error)
        }
    }
    
    var body : some View {
        NavigationStack{
            List {
                Picker("Watchlist", selection: $selectedSegment) {
                    Text("Watchlist").tag("Watchlist")
                    Text("All Stock").tag("All Stock")
                }
                .pickerStyle(SegmentedPickerStyle())
                .listRowSeparator(.hidden)
                .onChange(of: selectedSegment) { value in
                    Task {
                        if (selectedSegment == "Watchlist") {
                            try await fetchWatchlistItem()
                        }
                        else {
                            try await fetchAllCompany()
                        }
                    }
                }
                
                HStack(alignment: .center){
                    if (selectedSegment == "Watchlist") {
                        Picker("", selection: $selectedWatchlist) {
                            ForEach(watchlists, id:\.id) { wl in
                                Text(wl.name).tag(wl.name)
                            }
                            Label("Manage Watchlist", systemImage: "slider.horizontal.3").tag("Manage Watchlist")
                            Label("Add Watchlist", systemImage: "plus").tag("Add Watchlist")
                        }
                        .onChange(of: selectedWatchlist) { value in
                            if (selectedWatchlist == "Add Watchlist") {
                                addAlertShown = true
                            }
                            else if (selectedWatchlist == "Manage Watchlist") {
                                manageWlSheet = true
                                selectedWatchlist = "Watchlist 1"
                            }
                            else {
                                Task {
                                    try await fetchWatchlistItem()
                                }
                            }
                        }
                        .sheet(isPresented: $manageWlSheet) {
                            ManageWatchlistSheet(watchlists: $watchlists)
                        }
                        .alert(Text("New watchlist"), isPresented: $addAlertShown, actions: {
                            TextField("Watchlist Name", text: $newWatchlistName)
                            Button("Add", action: {
                                Task {
                                    try await addWatchlist()
                                    selectedWatchlist = newWatchlistName
                                }
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
                }
                
                if (filtered.count == 0) {
                    HStack(alignment: .center) {
                        ContentUnavailableView {
                            Label("No Stock Yet", systemImage: "dollarsign.circle.fill")
                        } description: {
                            Button{
                                withAnimation{
                                    selectedSegment = "All Stock"
                                }
                            } label: {
                                Text("Add Stock").foregroundStyle(.blue)
                            }
                        }
                    }
                }
                else {
                    ForEach(filtered, id:\.id) { company in
                        StockList(company: company, selectedSegment: $selectedSegment, selectedWatchlist: $selectedWatchlist, watchlists: $watchlists)
                    }
                }
            }
            .listStyle(.plain)
            .onAppear{
                Task{
                    try await fetchWatchlist()
                    try await fetchWatchlistItem()
                }
            }
            .onChange(of: search) { value in
                Task {
//                    if (search != "") {
                        try await searchItem()
//                    }
//                    else {
//                        
//                    }
                }
            }
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
