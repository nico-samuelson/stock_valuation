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
    @Binding var isAuthenticated: Bool
    @Binding var currentUser: User?
    
    //    @State var companies = [Company]
    
//        init() {
//            let technologies: [String] = [
//                "AAPL",
//                "GOOGL",
//                "META",
//                "MSFT",
//                "AMZN",
//                "NVDA",
//                "NFLX"
//            ]
//            let healthcare: [String] = [
//                "JNJ",
//                "PFE",
//                "MRK",
//                "ABT",
//                "AMGN"
//            ]
//            let energy: [String] = ["NEE", "DUK", "SO", "AEP"]
//            let banks: [String] = [
////                "JPM", "BAC", "WFC", "GS", "MS",
//                "BLK", "BRK.A"]
//            let industrials: [String] = ["MMM", "HON", "UPS", "UNP", "FDX"]
//            let consumers: [String] = ["BBY", "F", "HD", "WMT", "NKE", "COST"]
//            let foods: [String] = ["MCD", "SBUX", "KO"]
//            let autos: [String] = ["TSLA", "GM"]
//            Task {
////                for i in banks {
////                    try await fetchCompanyData(symbol: i)
////                }
//            }
//        }
    
    var body: some View {
        HomeView(isAuthenticated: $isAuthenticated, currentUser: $currentUser)
//        if (isAuthenticated) {
//            LoginView(currentUser: $currentUser).transition(.move(edge: .leading))
//        }
//            else {
//                HomeView(currentUser: $currentUser).transition(.move(edge: .leading))
//            }
        }
    }

//#Preview {
//    ContentView(isAuthenticated: .constant(true), currentUser: .constant(User))
//        .modelContainer(for: [Company.self, CompanyFinancial.self], inMemory: false)
//}
