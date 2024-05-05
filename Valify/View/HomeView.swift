//
//  HomeView.swift
//  Valify
//
//  Created by Nico Samuelson on 02/05/24.
//

import SwiftUI
import Auth

struct HomeView: View {
    @Binding var isAuthenticated: Bool
    @Binding var currentUser: User?
    @State var profileSheet: Bool = false
    
    var body: some View {
        TabView{
            StockView(isAuthenticated: $isAuthenticated, currentUser: $currentUser, profileSheet: $profileSheet).tabItem{
                Image(systemName: "chart.line.uptrend.xyaxis")
                Text("Stocks")
            }
            ValuationView(profileSheet: $profileSheet, isAuthenticated: $isAuthenticated, currentUser: $currentUser).tabItem{
                Image(systemName: "dollarsign.circle.fill")
                Text("Valuation")
            }
            HistoryView(profileSheet: $profileSheet, isAuthenticated: $isAuthenticated, currentUser: $currentUser).tabItem{
                Image(systemName: "clock.fill")
                Text("History")
            }
        }
        .onAppear{
            
        }
    }
    
}
