//
//  DCFSection.swift
//  Valify
//
//  Created by Nico Samuelson on 28/04/24.
//

import Foundation
import SwiftUI

struct DCFSection: View {
    @Binding var viewModel: FormViewModel
    let index: Int
    
    var body: some View {
        Section(header: Text(index + 1 == 1 ? "Last Year" : "\(index + 1) years ago")) {
            NumberInput(value: $viewModel.financialHistory[index].revenue,
                        title: "Revenue",
                        alertTitle: "Revenue",
                        alertMessage: "Revenue is the income a company generates from selling its goods or services. It represents the total amount of money coming into the business before accounting for expenses.",
                        numberFormatter: numberInputFormatter())
            
            NumberInput(value: $viewModel.financialHistory[index].netIncome,
                        title: "Net Income",
                        alertTitle: "Net Income",
                        alertMessage: "Net income, also known as the bottom line, is a company's profit after all expenses, including operating costs and taxes, have been deducted from its revenue. It represents the company's overall financial health and profitability.",
                        numberFormatter: numberInputFormatter())
            
            NumberInput(value: $viewModel.financialHistory[index].operatingCashFlow,
                        title: "Operating Cash Flow",
                        alertTitle: "Operating Cash Flow",
                        alertMessage: "Operating cash flow shows how much cash a company generates from its daily operations, reflecting its ability to cover expenses through core business activities. You can find this in the company cash flow statement",
                        numberFormatter: numberInputFormatter())
            
            NumberInput(value: $viewModel.financialHistory[index].capEx,
                        title: "Capital Expenditure",
                        alertTitle: "Capital Expenditure",
                        alertMessage: "CAPEX (Capital Expenditures) refers to the money a company spends on acquiring or upgrading physical assets like property, equipment, or vehicles. You can typically find it listed in the \"cash flow statement\" or \"investment activities\" section of a company's financial reports.",
                        numberFormatter: numberInputFormatter())
        }
    }
}
