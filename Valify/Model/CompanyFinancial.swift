//
//  FInancials.swift
//  Valify
//
//  Created by Nico Samuelson on 29/04/24.
//

import Foundation
import SwiftData

@Model
class CompanyFinancial: Codable, Identifiable {
    var id: UUID = UUID.init()
    var created_at: Date = Date()
    var company_id: UUID = UUID.init()
    var date: Date = Date()
    var price: Double = 0
    var revenue: Double = 0
    var interestExpense: Double = 0
    var operatingIncome: Double = 0
    var pretaxIncome: Double = 0
    var taxProvision: Double = 0
    var netIncome: Double = 0
    var cashAndEquivalents: Double = 0
    var totalCash: Double = 0
    var totalDebt: Double = 0
    var totalEquity: Double = 0
    var operatingCashFlow: Double = 0
    var capEx: Double = 0
    var depreciationAmortization: Double = 0
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        company_id = try container.decode(UUID.self, forKey: .company_id)
        date = try container.decode(Date.self, forKey: .date)
        price = try container.decode(Double.self, forKey: .price)
        revenue = try container.decode(Double.self, forKey: .revenue)
        interestExpense = try container.decode(Double.self, forKey: .interestExpense)
        operatingIncome = try container.decode(Double.self, forKey: .operatingIncome)
        pretaxIncome = try container.decode(Double.self, forKey: .pretaxIncome)
        taxProvision = try container.decode(Double.self, forKey: .taxProvision)
        netIncome = try container.decode(Double.self, forKey: .netIncome)
        cashAndEquivalents = try container.decode(Double.self, forKey: .cashAndEquivalents)
        totalCash = try container.decode(Double.self, forKey: .totalCash)
        totalDebt = try container.decode(Double.self, forKey: .totalDebt)
        totalEquity = try container.decode(Double.self, forKey: .totalEquity)
        operatingCashFlow = try container.decode(Double.self, forKey: .operatingCashFlow)
        capEx = try container.decode(Double.self, forKey: .capEx)
        depreciationAmortization = try container.decode(Double.self, forKey: .depreciationAmortization)
      }

      // Implement encode(to:) for Encodable
      func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
          try container.encode(created_at, forKey:.created_at)
        try container.encode(company_id, forKey: .company_id)
        try container.encode(date, forKey: .date)
        try container.encode(price, forKey: .price)
        try container.encode(revenue, forKey: .revenue)
        try container.encode(interestExpense, forKey: .interestExpense)
        try container.encode(operatingIncome, forKey: .operatingIncome)
        try container.encode(pretaxIncome, forKey: .pretaxIncome)
        try container.encode(taxProvision, forKey: .taxProvision)
        try container.encode(netIncome, forKey: .netIncome)
        try container.encode(cashAndEquivalents, forKey: .cashAndEquivalents)
        try container.encode(totalCash, forKey: .totalCash)
        try container.encode(totalDebt, forKey: .totalDebt)
        try container.encode(totalEquity, forKey: .totalEquity)
        try container.encode(operatingCashFlow, forKey: .operatingCashFlow)
        try container.encode(capEx, forKey: .capEx)
        try container.encode(depreciationAmortization, forKey: .depreciationAmortization)
      }

    private enum CodingKeys: String, CodingKey {
        case id
        case created_at
        case company_id
        case date
        case price
        case revenue
        case interestExpense
        case operatingIncome
        case pretaxIncome
        case taxProvision
        case netIncome
        case cashAndEquivalents
        case totalCash
        case totalDebt
        case totalEquity
        case operatingCashFlow
        case capEx
        case depreciationAmortization
    }
    
    init() {}
   
    init(company_id: UUID, date: Date, price: Double, revenue: Double, interestExpense: Double, operatingIncome: Double, pretaxIncome: Double, taxProvision: Double, netIncome: Double, cashAndEquivalents: Double, totalCash: Double, totalDebt: Double, totalEquity: Double, operatingCashFlow: Double, capEx: Double, depreciationAmortization: Double) {
        self.company_id = company_id
        self.date = date
        self.price = price
        self.revenue = revenue
        self.interestExpense = interestExpense
        self.operatingIncome = operatingIncome
        self.pretaxIncome = pretaxIncome
        self.taxProvision = taxProvision
        self.netIncome = netIncome
        self.cashAndEquivalents = cashAndEquivalents
        self.totalCash = totalCash
        self.totalDebt = totalDebt
        self.totalEquity = totalEquity
        self.operatingCashFlow = operatingCashFlow
        self.capEx = capEx
        self.depreciationAmortization = depreciationAmortization
    }
}
