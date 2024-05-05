//
//  ValifyApp.swift
//  Valify
//
//  Created by Nico Samuelson on 26/04/24.
//

import SwiftUI
import SwiftData
import Auth

@main
struct ValifyApp: App {
    @State var isAuthenticated: Bool = false
    @State var currentUser: User?
    
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
                ContentView(isAuthenticated: $isAuthenticated, currentUser: $currentUser)

            }.task {
                Task {
                    isAuthenticated = try await supabaseAuth.session.user != nil
                    currentUser = try await supabaseAuth.session.user
                    
                    print(isAuthenticated)
                }
                
                for await state in supabaseAuth.authStateChanges {
                    if [.initialSession, .signedIn, .signedOut].contains(state.event) {
                        isAuthenticated = state.session != nil
                        currentUser = state.session?.user
                    }
                }
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
