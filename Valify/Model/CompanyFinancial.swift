//
//  FInancials.swift
//  Valify
//
//  Created by Nico Samuelson on 29/04/24.
//

import Foundation
import SwiftData

@Model
class CompanyFinancial {
    var id: UUID = UUID.init()
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
