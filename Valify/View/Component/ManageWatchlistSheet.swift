//
//  ManageWatchlistSheet.swift
//  Valify
//
//  Created by Nico Samuelson on 03/05/24.
//

import SwiftUI

struct ManageWatchlistSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var watchlists: [Watchlist]
    @State var updatedName: String = ""
    @State var editedWl: UUID = UUID.init()
    @State var editAlertShown: Bool = false
    
    func removeWatchlist(offsets: IndexSet) async throws {
        for index in offsets {
            do {
                try await supabase.database
                    .from("Watchlist")
                    .delete()
                    .eq("id", value: watchlists[index].id)
                    .execute()
            }
            catch {
                print(error)
            }
        }
    }
    
    func editWatchlist() async throws {
        do {
            try await supabase.database
                .from("Watchlist")
                .update(["name": updatedName])
                .eq("id", value: editedWl)
                .execute()
            
            
            watchlists.filter{$0.id == editedWl}[0].name = updatedName
        }
        catch {
            print(error)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(watchlists, id:\.id) { wl in
                    LabeledContent {
                        Button{} label: {
                            Image(systemName: "line.3.horizontal").foregroundColor(.secondary)
                        }
                    } label: {
                        Button{
                            editAlertShown = true
                            editedWl = wl.id
                            updatedName = wl.name
                        } label: {
                            Label(wl.name, systemImage: "pencil")
                        }
                        
                    }
                }
                .onDelete { indexSet in
                    Task {
                        try await removeWatchlist(offsets: indexSet)
                    }
                }
                .onMove { indexSet, offset in
                    watchlists.move(fromOffsets: indexSet, toOffset: offset)
                }
                .alert(Text("Edit watchlist"), isPresented: $editAlertShown, actions: {
                    TextField("Watchlist Name", text: $updatedName)
                    Button("Edit", action: {
                        Task {
                            try await editWatchlist()
                        }
                    })
                    Button("Cancel", role: .cancel, action: {})
                }, message: {
                    Text("Enter a new name for this watchlist")
                })
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Manage Watchlists")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button{
                        dismiss()
                    } label: {
                        Text("Done")
                    }
                })
            }
        }
        .presentationDetents([.medium, .large])
    }
}
