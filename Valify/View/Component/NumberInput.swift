//
//  NumberInput.swift
//  Valify
//
//  Created by Nico Samuelson on 28/04/24.
//

import Foundation
import SwiftUI


struct NumberInput<T:CustomStringConvertible>: View {
    @State var isAlertShown: Bool = false
    @Binding var value: T
    
    var title: String
    var alertTitle: String? = ""
    var alertMessage: String? = ""
    var numberFormatter: NumberFormatter
    
    var body: some View {
        HStack(spacing: 20){
            
            if (alertTitle != "" && alertMessage != "") {
                Text(self.title)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(Color.blue)
                    .onTapGesture {
                        self.isAlertShown = true
                    }
                    .alert(
                        Text(self.alertTitle ?? ""),
                        isPresented: $isAlertShown,
                        actions: {
                            Button("Confirm"){}
                        },
                        message: {
                            Text(self.alertMessage ?? "")
                        }
                    )
            }
            else {
                Text(self.title).multilineTextAlignment(.leading)
            }
            
            TextField("0", value: $value, formatter: self.numberFormatter)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
        }
    }
}
