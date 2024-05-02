//
//  ContentView.swift
//  Valify
//
//  Created by Nico Samuelson on 26/04/24.
//

import SwiftUI
import SwiftData
import AuthenticationServices
import Auth

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State var currentUser: User?
    
    //    @State var companies = [Company]
    
    //    init() {
    //        callAPI()
    //    }
    
    var body: some View {
        if (currentUser == nil) {
            LoginView(currentUser: $currentUser).transition(.move(edge: .leading))
        }
            else {
                HomeView(currentUser: $currentUser).transition(.move(edge: .leading))
            }
        }
    }

#Preview {
    ContentView()
        .modelContainer(for: [Company.self, CompanyFinancial.self], inMemory: false)
}
