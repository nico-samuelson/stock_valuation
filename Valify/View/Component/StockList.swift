import SwiftUI
import Foundation

struct StockList: View {
    @Environment(\.dismiss) var dismiss
    @State var company: Company
    @Binding var selectedSegment: String
    @Binding var selectedWatchlist: String
    @Binding var watchlists: [Watchlist]
    @State var addToWatchlistSheet: Bool = false
    @State var savedWatchlist: [Watchlist] = []
    
    func insertItem() async throws {
        do {
            for wl in savedWatchlist {
                let newItem = WatchlistItem(
                    id: UUID.init(),
                    created_at: Date.now,
                    watchlist_id: wl.id,
                    company_id: self.company.id
                )
                try await supabase.database.from("WatchlistItem").insert(newItem).execute()
            }
        }
        catch {
            print(error)
        }
    }
    
    func removeItem(company: Company) async throws {
        do {
            try await supabase.database
                .from("WatchlistItem")
                .delete()
                .eq("watchlist_id", value: watchlists.filter{ $0.name == selectedWatchlist }[0].id)
                .eq("company_id", value: company.id)
                .execute()
        }
        catch {
            print(error)
        }
    }
    
    var body: some View {
        HStack(){
            if (self.company.logo != "") {
                AsyncImage(url: URL(string: self.company.logo)) { image in
                    image.resizable().aspectRatio(contentMode: .fit)
                }
            placeholder: {
                Circle().foregroundColor(.secondary)
            }
            .frame(width: 48, height: 48)
            .cornerRadius(50)
            }
            
            VStack(alignment: .leading) {
                Text(self.company.symbol)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding(.bottom, 1)
                Text(self.company.name)
                    .frame(maxWidth:200)
                    .lineLimit(1)
                    .fixedSize()
                    .truncationMode(.tail)
            }
            
            Spacer(minLength: 20)
            
            VStack(alignment: .trailing) {
                Text(String(self.company.price))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding(.bottom, 1)
                Text("\(String(format:"%.02f", self.company.changes))%")
                    .foregroundStyle(.green)
            }
            .padding(.vertical, 8)
        }
        .swipeActions(edge: .trailing, content: {
//            Save Item
            if (selectedSegment == "All Stock") {
                Button{
                    addToWatchlistSheet = true
//                    Task {
//                        try await insertItem(company: company)
//                    }
                } label: {
                    Image(systemName: "bookmark.fill")
                }
            }
//            Remove Item
            else {
                Button(role: .destructive) {
                    Task {
                        try await removeItem(company: company)
                    }
                } label: {
                    Image(systemName: "trash.fill")
                }
            }
        })
        .sheet(isPresented: $addToWatchlistSheet) {
            NavigationView {
                List {
                    ForEach(watchlists, id:\.id) { wl in
                        LabeledContent {
                            Button{
                                let wlIndex = savedWatchlist.firstIndex(where: {$0.id == wl.id}) ?? -1
                                if (wlIndex != -1) {
                                    savedWatchlist.removeAll(where: {$0.id == wl.id})
                                }
                                else {
                                    savedWatchlist.append(wl)
                                }
                            } label: {
                                Image(systemName: savedWatchlist.firstIndex(where: {$0.id == wl.id}) ?? -1 == -1 ? "plus" : "minus.circle").foregroundColor(savedWatchlist.firstIndex(where: {$0.id == wl.id}) ?? -1 == -1 ? .blue : .red)
                            }
                        } label: {
                            Text(wl.name)
                        }
                    }
                }
                .navigationTitle("Add to Watchlist")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing, content: {
                        Button{
                            Task {
                                try await insertItem()
                            }
                        } label: {
                            Text("Done")
                        }
                    })
                }
            }
            .presentationDetents([.medium, .large])
        }
    }
}
