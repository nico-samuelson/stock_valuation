//
//  DCFView.swift
//  Valify
//
//  Created by Nico Samuelson on 28/04/24.
//

import Foundation
import SwiftUI

struct DCFView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.modelContext) var context
    @Binding var viewModel: FormViewModel
    @Binding var navPath: [String]
    @Binding var tempNavPath: [String]
    @Binding var total: Double
    @Binding var current: Double
    
    //    init(viewModel: FormViewModel, navPath: [String], tempNavPath: [String]) {
    //        self.viewModel = viewModel
    //        self.navPath = navPath
    //        self.tempNavPath = tempNavPath
    //    }
    
    var body: some View {
        VStack {
            Form {
                GeometryReader { geometry in
                    ZStack(alignment: Alignment(horizontal:.leading, vertical: .center)){
                        Rectangle()
                            .foregroundStyle(colorScheme == .light ? Color.init(red: 242.0/255, green: 242.0/255, blue: 247.0/255) : Color.black)
                            .padding(-20)
                        
                        ProgressView(
                            value: current / total * 100,
                            total: 100,
                            label: {
                                Text("Step \(Int(current)) of \(Int(total))")
                            },
                            currentValueLabel: {
                                Text("DCF").font(.subheadline)
                            })
                        .progressViewStyle(.linear)
                    }
                    .onAppear(perform: {
                        current = Double(viewModel.methods.filter{ navPath.contains($0.rawValue)
                        }.count)
                        total = Double(viewModel.methods.count)
                        //                        progress = current / total * 100
                    })
                }.padding(-12)
                
                Section(header: VStack(alignment:.leading) {
                    Text("Use most recent annual data for these fields")
                }) {
                    NumberInput(value: $viewModel.financialHistory[0].interestExpense,
                                title: "Interest Expense",
                                alertTitle: "Interest Expense",
                                alertMessage: "Amount of interest paid by the company to its debtors",
                                numberFormatter: numberInputFormatter())
                    
                    NumberInput(value: $viewModel.financialHistory[0].totalCash,
                                title: "Total Cash",
                                alertTitle: "Total Cash",
                                alertMessage: "Amount of cash and equivalents owned by the company. You can find this in the company balance sheet",
                                numberFormatter: numberInputFormatter())
                    
                    NumberInput(value: $viewModel.financialHistory[0].totalDebt,
                                title: "Total Debt",
                                alertTitle: "Total Debt",
                                alertMessage: "Sum of short-term and long-term debt owned by the company. Accounts payable is not included.",
                                numberFormatter: numberInputFormatter())
                    
                    NumberInput(value: $viewModel.financialHistory[0].totalEquity,
                                title: "Total Equity",
                                alertTitle: "Total Equity",
                                alertMessage: "Sum of shareholder's capital and company's net income throughout the years",
                                numberFormatter: numberInputFormatter())
                    
                    NumberInput(value: $viewModel.financialHistory[0].pretaxIncome,
                                title: "Pretax Income",
                                alertTitle: "Pretax Income",
                                alertMessage: "Pretax income, also known as earnings before tax (EBT), is a company's profit excluding income taxes. It reflects a company's overall operational profitability before accounting for government taxes.",
                                numberFormatter: numberInputFormatter())
                    
                    NumberInput(value: $viewModel.financialHistory[0].taxProvision,
                                title: "Tax Provision",
                                alertTitle: "Tax Provision",
                                alertMessage: "A tax provision is the estimated tax a company owes on its pretax income, setting aside funds to cover this future liability.",
                                numberFormatter: numberInputFormatter())
                }
                
                Section(header: Text("Use most recent data for these fields")) {
                    NumberInput(value: $viewModel.bondYield,
                                title: "Risk Free Rate",
                                alertTitle: "Risk Free Rate",
                                alertMessage: "The risk-free rate is the theoretical return on a risk-free investment, often approximated by the interest rate on short-term government debt like U.S. Treasury bills (typically 5 years).",
                                numberFormatter: numberInputFormatter(style: .percent))
                    
                    NumberInput(value: $viewModel.indexYield,
                                title: "Expected ROI",
                                alertTitle: "Expected Return of Investment",
                                alertMessage: "The expected return is the predicted profit from an investment, and while not guaranteed, historical data from broad market indexes like the S&P 500 can offer a rough estimate.",
                                numberFormatter: numberInputFormatter(style: .percent))
                    
                    NumberInput(value: $viewModel.company.beta,
                                title: "Beta",
                                alertTitle: "Beta",
                                alertMessage: "Beta measures how much a specific investment's price tends to move compared to the overall market (like the S&P 500). A beta of 1 means the investment moves exactly in line with the market, while a beta greater than 1 indicates it tends to be more volatile.",
                                numberFormatter: numberInputFormatter())
                }
                
                ForEach(0..<self.viewModel.financialHistory.count, id:\.self) { i in
                    DCFSection(viewModel: $viewModel, index: i)
                }
            }.scrollContentBackground(.hidden)
            
            Button(action: {
                let nextView = tempNavPath[(tempNavPath.firstIndex(of: navPath[navPath.count - 1]) ?? 0) + 1]
                navPath.append(nextView)
                
                viewModel.company.dcf = calculateDCF(company: viewModel.company, financialHistory: viewModel.financialHistory, bondYield: viewModel.bondYield, indexYield: viewModel.indexYield)
                if (nextView == "Result") {
                    context.insert(viewModel.company)
                }
            }, label: {
                Text(tempNavPath.count > 0 ? "Continue" : "Calculate").frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .foregroundStyle(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            })
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
        .background(colorScheme == .light ? Color.init(red: 242.0/255, green: 242.0/255, blue: 247.0/255) : Color.black)
        .navigationTitle("DCF")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            Menu(content: {
                Section {
                    Button(role:.destructive, action: {
                        // logout
                    }) {
                        Label("Logout", systemImage: "rectangle.portrait.and.arrow.forward")
                    }
                }
            }, label: {
                Button {} label: {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .aspectRatio(contentMode: .fit)
                }
            })
        }
        .navigationDestination(for: String.self) { value in
            switch(value) {
            case "DCF": DCFView(viewModel: $viewModel, navPath: $navPath, tempNavPath: $tempNavPath, total: $total, current: $current)
            case "PBV": PBVView(viewModel: $viewModel, navPath: $navPath, tempNavPath: $tempNavPath, total: $total, current: $current)
            case "PER": PERView(viewModel: $viewModel, navPath: $navPath, tempNavPath: $tempNavPath, total: $total, current: $current)
            case "EV/EBITDA": EvEbitdaView(viewModel: $viewModel, navPath: $navPath, tempNavPath: $tempNavPath, total: $total, current: $current)
            case "Result": ResultView(viewModel: $viewModel, navPath: $navPath, tempNavPath: $tempNavPath, total: $total, current: $current)
            default: ValuationView()
            }
        }
    }
}
