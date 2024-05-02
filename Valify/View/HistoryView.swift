//
//  HistoryView.swift
//  Valify
//
//  Created by Nico Samuelson on 29/04/24.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) var context
    @State var search = ""
    @State var selectedWatchlist = "Watchlist 1"
    @State var selectedSegment = "Watchlist"
    @Query var companies: [Company]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(companies, id:\.self) { company in
                    StockList(company: company)
                }
                .onDelete(perform: deleteItems)
            }
            .listStyle(.plain)
            .listRowSpacing(10)
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $search, prompt: "Search stocks")
            .toolbar{
                Menu(content: {
                    Section {
                        Button(role:.destructive, action: {
                            // logout
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
    
    func deleteItems(offsets: IndexSet) {
        for index in offsets {
            context.delete(companies[index])
        }
    }
}

#Preview {
    HistoryView()
}
