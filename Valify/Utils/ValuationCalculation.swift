//
//  ValuationCalculation.swift
//  Valify
//
//  Created by Nico Samuelson on 05/05/24.
//

import Foundation

func calculateDCF(company: Company, financialHistory: [CompanyFinancial], bondYield: Double, indexYield: Double) -> Double {
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
        
        freeCashFlowProjection /= pow((1 + wacc), Double(i + 1))
        discountedCashFlows.append(freeCashFlowProjection)
    }
    
    let perpetualGrowth = 0.02
    let terminalValue = lastCashFlowProjection * perpetualGrowth / (wacc - perpetualGrowth)
    
    let totalDCF = discountedCashFlows.reduce(0, +) + terminalValue
    
    let presentValue = totalDCF + recentFinancial.totalCash - recentFinancial.totalDebt
    let fairValue = presentValue / company.sharesOut * 10
    
    return fairValue
}

func calculatePER(company: Company, financialHistory: [CompanyFinancial]) -> Double {
    let earnings = financialHistory.map{ $0.netIncome }
    let historicalPER = financialHistory.map { $0.price / ($0.netIncome / company.sharesOut) }
    let duration = Double(financialHistory.count)
    
    let earningsGrowthRate = calculateCAGR(array: earnings)
    let meanPER = historicalPER.reduce(0, +) / duration
    
    let fairValue = meanPER * (earnings[0] * (1 + earningsGrowthRate)) / company.sharesOut
    
    return fairValue
}

func calculatePBV(company: Company, financialHistory: [CompanyFinancial]) -> Double {
    let bookValues = financialHistory.map{ $0.totalEquity }
    let historicalPBV = financialHistory.map { $0.price / ($0.totalEquity / company.sharesOut) }
    
    let duration = Double(financialHistory.count)
    
    let bookValueGrowthRate = calculateCAGR(array: bookValues)
    let meanPBV = historicalPBV.reduce(0, +) / duration
    
    let fairValue = meanPBV * (bookValues[0] * (1 + bookValueGrowthRate)) / company.sharesOut
    
    return fairValue
}

func calculateEVEBITDA(company: Company, financialHistory: [CompanyFinancial]) -> Double {
    let duration = Double(financialHistory.count)
    
    let ebitda = financialHistory.map { $0.operatingIncome + $0.depreciationAmortization }
    let enterpriseValues = financialHistory.map { $0.price * company.sharesOut + $0.totalDebt - $0.totalCash }
    let evEbitda = zip(ebitda, enterpriseValues).map { $0.0 / $0.1 }
    
    let ebitdaGrowthRate = calculateCAGR(array: ebitda)
    let meanEvEbitda = evEbitda.reduce(0, +) / duration
    
    let nextYearEbitda = ebitda[0] * (1 + ebitdaGrowthRate)
    
    let fairValue = (nextYearEbitda * meanEvEbitda + financialHistory[0].totalCash - financialHistory[0].totalDebt) / company.sharesOut * 10
    
    return fairValue
}
