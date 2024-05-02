//
//  ValuationResult.swift
//  Valify
//
//  Created by Nico Samuelson on 01/05/24.
//

import SwiftUI

struct ValuationResult: View {
    var method: String = ""
    var fairValue : Double = 0
    var marginOfSafety: Double = 0
    
    init(method: String, fairValue: Double, marginOfSafety: Double) {
        self.method = method
        self.fairValue = fairValue
        self.marginOfSafety = marginOfSafety
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(method)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 8)
            
            Text(String(format: "%.2f", fairValue))
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(
                    marginOfSafety >= 0.25 ? Color.green :
                    marginOfSafety >= 0 ? Color.orange : Color.red
                )
        }
        
        Spacer()
    
        Gauge(value: marginOfSafety, in: marginOfSafety > 0 ? 0...1 : -1...0) {}
        currentValueLabel: {
            Text(String(format: "%.0f", marginOfSafety * 100)).foregroundStyle(
                marginOfSafety >= 0.25 ? Color.green :
                marginOfSafety >= 0 ? Color.orange : Color.red
            )
        }
        .gaugeStyle(.accessoryCircularCapacity)
    }
}
