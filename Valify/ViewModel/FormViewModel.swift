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
    
    func calculateDCF() -> Double {
        let duration = Double(financialHistory.count)
        let recentFinancial = financialHistory[0]
        
        // WACC (Discount Rate) Calculation
        let taxRate: Double = recentFinancial.taxProvision / recentFinancial.pretaxIncome
        let interestRate: Double = recentFinancial.interestExpense / recentFinancial.totalDebt
        let costOfDebt = interestRate * (1 - taxRate)
        let costOfEquity = bondYield + company.beta * (indexYield - bondYield)
        
        let totalDebtAndEquity = recentFinancial.totalDebt + recentFinancial.totalEquity
        let weightOfDebt = recentFinancial.totalDebt / totalDebtAndEquity
        let weightOfEquity = recentFinancial.totalEquity / totalDebtAndEquity
        
        let wacc = weightOfDebt * costOfDebt + weightOfEquity * costOfEquity
        
        // FCFF Projections
        let revenues = financialHistory.map { $0.revenue }
        let netIncomes = financialHistory.map { $0.netIncome }
       
        let revenueGrowthRate = calculateCAGR(array: revenues)
        let netIncomeGrowthRate = calculateCAGR(array: netIncomes)

        let cashFlowMargins = financialHistory.map { $0.operatingCashFlow / $0.revenue }
        let capExMargins = financialHistory.map { $0.capEx / $0.netIncome }
        
        let meanCashFlowMargin = cashFlowMargins.reduce(0, +) / duration
        let meanCapExMargin = capExMargins.reduce(0, +) / duration
        
        debugPrint("cash flow margin", meanCashFlowMargin)
        debugPrint("capex margin", meanCapExMargin)
        
        var discountedCashFlows: [Double] = []
        var lastCashFlowProjection: Double = 0
        var lastRevenueProjection: Double = revenues[revenues.count - 1]
        var lastNetIncomeProjection: Double = netIncomes[netIncomes.count - 1]
        
        // DCF Calculation
        for i in 0..<Int(duration) {
            let revenueProjection = lastRevenueProjection * (1 + revenueGrowthRate)
            let netIncomeProjection = lastNetIncomeProjection * (1 + netIncomeGrowthRate)
            var freeCashFlowProjection = (revenueProjection * meanCashFlowMargin) - (netIncomeProjection * meanCapExMargin)
            
            lastCashFlowProjection = freeCashFlowProjection
            lastRevenueProjection = revenueProjection
            lastNetIncomeProjection = netIncomeProjection
            
            debugPrint("revenue projection", revenueProjection)
            debugPrint("cf projection", freeCashFlowProjection)
            
            freeCashFlowProjection /= pow((1 + wacc), Double(i + 1))
            discountedCashFlows.append(freeCashFlowProjection)
        }
        
        debugPrint("DCF", discountedCashFlows)
        debugPrint("WACC", wacc)
        
        let perpetualGrowth = 0.02
        let terminalValue = lastCashFlowProjection * perpetualGrowth / (wacc - perpetualGrowth)
        
        let totalDCF = discountedCashFlows.reduce(0, +) + terminalValue
        
        let presentValue = totalDCF + recentFinancial.totalCash - recentFinancial.totalDebt
        let fairValue = presentValue / company.sharesOut * 10
        
        debugPrint("Terminal Value", terminalValue)
        debugPrint("total")
        debugPrint("PV", presentValue)
        
        return fairValue
    }
    
    func calculatePER() -> Double {
        let earnings = financialHistory.map{ $0.netIncome }
        let historicalPER = financialHistory.map { $0.price / ($0.netIncome / company.sharesOut) }
        let duration = Double(financialHistory.count)
        
        let earningsGrowthRate = calculateCAGR(array: earnings)
        let meanPER = historicalPER.reduce(0, +) / duration
        
        let fairValue = meanPER * (earnings[Int(duration) - 1] * (1 + earningsGrowthRate)) / company.sharesOut
        
        return fairValue
    }
    
    func calculatePBV() -> Double {
        let bookValues = financialHistory.map{ $0.totalEquity }
        let historicalPBV = financialHistory.map { $0.price / ($0.totalEquity / company.sharesOut) }
        
        let duration = Double(financialHistory.count)
        
        let bookValueGrowthRate = calculateCAGR(array: bookValues)
        let meanPBV = historicalPBV.reduce(0, +) / duration
        
        let fairValue = meanPBV * (bookValues[Int(duration) - 1] * (1 + bookValueGrowthRate)) / company.sharesOut
        
        return fairValue
    }
    
    func calculateEVEBITDA() -> Double {
        let duration = Double(financialHistory.count)
        
        let ebitda = financialHistory.map { $0.operatingIncome + $0.depreciationAmortization }
        let enterpriseValues = financialHistory.map { $0.price * company.sharesOut + $0.totalDebt - $0.totalCash }
        let evEbitda = zip(ebitda, enterpriseValues).map { $0.0 / $0.1 }
        
        let ebitdaGrowthRate = calculateCAGR(array: ebitda)
        let meanEvEbitda = evEbitda.reduce(0, +) / duration
        
        let nextYearEbitda = ebitda[Int(duration) - 1] * (1 + ebitdaGrowthRate)
        
        let fairValue = (nextYearEbitda * meanEvEbitda + financialHistory[0].totalCash - financialHistory[0].totalDebt) / company.sharesOut * 10
        
        return fairValue
    }
}
