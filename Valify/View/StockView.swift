import SwiftUI
import Auth


struct StockView : View {
    @Environment (\.dismiss) var dismiss
    @Binding var isAuthenticated: Bool
    @Binding var currentUser: User?
    
    @State var search: String = ""
    @State var selectedWatchlist: String = ""
    @State var selectedSegment: String = "Watchlist"
    
    @State var filtered: [Company] = []
    @State var watchlists: [Watchlist] = []
    
    @State var newWatchlistName: String = ""
    @State var addAlertShown: Bool = false
    @State var manageWlSheet: Bool = false
    @Binding var profileSheet: Bool
    
    func checkAuthentication() -> Bool {
        return currentUser != nil && isAuthenticated
    }
    
    func fetchWatchlist() async throws {
        if (checkAuthentication()) {
            do {
                watchlists = try await supabase.database
                    .from("Watchlist")
                    .select()
                    .match(["user_id": supabase.auth.session.user.id])
                    .execute()
                    .value
                selectedWatchlist = watchlists[0].name
                
            }
            catch {
                print("error fetching")
                print("error: ", error)
            }
        }
    }
    
    func fetchWatchlistItem() async throws {
        if (checkAuthentication()) {
            do {
                filtered = try await supabase
                    .rpc("fetch_watchlist_items", params: ["watchlist_name": selectedWatchlist])
                    .execute()
                    .value
            }
            catch {
                print("error fetching")
                print(error)
            }
        }
    }
    
    func searchItem() async throws {
        if (search != "") {
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
        if (checkAuthentication()) {
            do {
                let watchlist = try await Watchlist(
                    id: UUID.init(),
                    created_at: Date.now,
                    user_id: supabase.auth.session.user.id,
                    name: newWatchlistName
                )
                try await supabase.database.from("Watchlist").insert(watchlist).execute()
                
                watchlists.append(watchlist)
            }
            catch {
                print(error)
            }
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
                
                HStack(alignment: .center){
                    if (selectedSegment == "Watchlist") {
                        Picker("", selection: $selectedWatchlist) {
                            ForEach(watchlists, id:\.id) { wl in
                                Text(wl.name).tag(wl.name)
                            }
                            Label("Manage Watchlist", systemImage: "slider.horizontal.3").tag("Manage Watchlist")
                            Label("Add Watchlist", systemImage: "plus").tag("Add Watchlist")
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
                    if (search != "") {
                        ContentUnavailableView.search.listRowSeparator(.hidden)
                    }
                    else if (!isAuthenticated) {
                        ContentUnavailableView {
                            Label("You are logged out", systemImage: "key.slash.fill")
                        } description: {
                            Button{
                                profileSheet = true
                            } label: {
                                Text("Log in here").foregroundStyle(.blue)
                            }
                        }
                        .listRowSeparator(.hidden)
                    }
                    else {
                        ContentUnavailableView {
                            Label("No Stock Yet", systemImage: "dollarsign.circle.fill")
                        } description: {
                            Button{
                                withAnimation{
                                    selectedSegment = "All Stock"
                                }
                            } label: {
                                Text("Browse Stocks").foregroundStyle(.blue)
                            }
                        }
                        .listRowSeparator(.hidden)
                    }
                    
                }
                else {
                    ForEach(filtered, id:\.id) { company in
                        StockList(
                            company: company,
                            selectedSegment: $selectedSegment,
                            selectedWatchlist: $selectedWatchlist,
                            watchlists: $watchlists
                        )
                    }
                }
            }
            .frame(maxHeight: .infinity)
            .listStyle(.plain)
            .onChange(of: selectedSegment) { value in
                Task {
                    if (selectedSegment == "Watchlist") {
                        if (isAuthenticated) {
                            try await fetchWatchlistItem()
                            try await searchItem()
                        }
                        else {
                            filtered = []
                        }
                    }
                    else {
                        try await fetchAllCompany()
                        try await searchItem()
                    }
                }
            }
            .onChange(of: selectedWatchlist) { value in
                if (selectedWatchlist == "Add Watchlist") {
                    addAlertShown = true
                }
                else if (selectedWatchlist == "Manage Watchlist") {
                    manageWlSheet = true
                    selectedWatchlist = watchlists[0].name
                }
                else {
                    Task {
                        try await fetchWatchlistItem()
                        try await searchItem()
                    }
                }
            }
            .onChange(of: search) { value in
                Task {
                    if (search != "") {
                        try await searchItem()
                    }
                    else if (selectedSegment == "Watchlist") {
                        try await fetchWatchlistItem()
                    }
                    else {
                        try await fetchAllCompany()
                    }
                }
            }
            .onChange(of: isAuthenticated) { value in
                if (isAuthenticated) {
                    Task{
                        try await fetchWatchlist()
                        try await fetchWatchlistItem()
                    }
                }
                else {
                    watchlists = [Watchlist(id: UUID.init(), created_at: Date.now, user_id: UUID.init(), name: "Watchlist 1")]
                    filtered = []
                }
            }
            .navigationTitle("Stocks")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $search, prompt: "Search stocks")
            .toolbar{
                ProfileButton(profileSheet: $profileSheet, isAuthenticated: $isAuthenticated, currentUser: $currentUser)
            }
        }
    }
}
