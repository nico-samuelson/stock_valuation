//
//  HomeView.swift
//  Valify
//
//  Created by Nico Samuelson on 02/05/24.
//

import SwiftUI
import Auth

struct HomeView: View {
    @Binding var currentUser: User?
    
    var body: some View {
        TabView{
            StockView(currentUser: $currentUser).tabItem{
                Image(systemName: "chart.line.uptrend.xyaxis")
                Text("Stocks")
            }
            ValuationView().tabItem{
                Image(systemName: "dollarsign.circle.fill")
                Text("Valuation")
            }
            HistoryView().tabItem{
                Image(systemName: "clock.fill")
                Text("History")
            }
            //        }.onAppear{
            //        }
        }
    }
    
}
