//
//  NumberFormatter.swift
//  Valify
//
//  Created by Nico Samuelson on 28/04/24.
//

import Foundation

func numberInputFormatter(style: NumberFormatter.Style = .none) -> NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = style
    formatter.locale = Locale(identifier: "en_US")
    formatter.usesGroupingSeparator = true
    formatter.maximumFractionDigits = 2
    formatter.decimalSeparator = ","
    formatter.groupingSeparator = "."
    
    return formatter
}
