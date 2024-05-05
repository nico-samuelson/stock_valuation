//
//  FormViewModel.swift
//  Valify
//
//  Created by Nico Samuelson on 28/04/24.
//

import Foundation
import Observation

@Observable
class FormViewModel {
    var company: Company
    var financialHistory: [CompanyFinancial]
    var bondYield: Double = 0
    var indexYield: Double = 0
    var duration: Int = 2
    var methods: [Method]
    
    init() {
        let id = UUID.init()
        self.company = Company(id: id, logo: "", symbol: "", name: "", sector: "", price: 0, changes: 0, sharesOut: 0, dcf: 0, per: 0, pbv: 0, evEbitda: 0, isPublic: true, beta: 1, saveLocal: true)
        self.methods = [Method.DCF]
        self.financialHistory = [
            CompanyFinancial(
                company_id: id,
                date: Date.now,
                price: 0,
                revenue: 0,
                interestExpense: 0,
                operatingIncome: 0,
                pretaxIncome: 0,
                taxProvision: 0,
                netIncome: 0,
                cashAndEquivalents: 0,
                totalCash: 0,
                totalDebt: 0,
                totalEquity: 0,
                operatingCashFlow: 0,
                capEx: 0,
                depreciationAmortization: 0
            ),
            CompanyFinancial(
                company_id: id,
                date: Date(),
                price: 0,
                revenue: 0,
                interestExpense: 0,
                operatingIncome: 0,
                pretaxIncome: 0,
                taxProvision: 0,
                netIncome: 0,
                cashAndEquivalents: 0,
                totalCash: 0,
                totalDebt: 0,
                totalEquity: 0,
                operatingCashFlow: 0,
                capEx: 0,
                depreciationAmortization: 0
            ),
        ]
    }
    
    func isGeneralFormValid() {
        
    }
    
    func isDcfFormValid() {
        
    }
    
    func isPerFormValid() {
        
    }
    
    func isPbvFormValid() {
        
    }
    
    func isEvEbitdaFormValid() {
        
    }
}
