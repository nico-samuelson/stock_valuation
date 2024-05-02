//
//  CAGR.swift
//  Valify
//
//  Created by Nico Samuelson on 01/05/24.
//

import Foundation

func calculateCAGR(array: [Double]) -> Double {
    return pow(array[0] / array[array.count - 1], (1/Double(array.count))) - 1
}
