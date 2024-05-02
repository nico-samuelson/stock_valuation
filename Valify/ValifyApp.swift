//
//  ValifyApp.swift
//  Valify
//
//  Created by Nico Samuelson on 26/04/24.
//

import SwiftUI
import SwiftData

@main
struct ValifyApp: App {
    @State var isAuthenticated: Bool = false
    
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Company.self,
            CompanyFinancial.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            Group{
                ContentView()

            }.task {
                for await state in supabaseAuth.authStateChanges {
                    if [.initialSession, .signedIn, .signedOut].contains(state.event) {
                        isAuthenticated = state.session != nil
                    }
                }
            }
        }
        .modelContainer(sharedModelContainer)
        //        .modelContainer(for: [Company.self, CompanyFinancial.self], inMemory: false, isAutosaveEnabled: false, isUndoEnabled: true)
        
    }
}
