//
//  EvEbitdaView.swift
//  Valify
//
//  Created by Nico Samuelson on 29/04/24.
//

import Foundation
import SwiftUI
import Auth

struct EvEbitdaView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.modelContext) var context
    @Binding var viewModel: FormViewModel
    @Binding var navPath: [String]
    @Binding var tempNavPath: [String]
    @Binding var total: Double
    @Binding var current: Double
    @Binding var profileSheet: Bool
    @Binding var isAuthenticated: Bool
    @Binding var currentUser: User?
    
    var body: some View {
//        NavigationStack {
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
                                      Text("EV/EBITDA").font(.subheadline)
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
                    
                    ForEach(0..<viewModel.financialHistory.count, id:\.self) { i in
                        Section(header: Text(i == 0 ? "Last Year" : "\(i+1) Years Ago")){
                            NumberInput(value: $viewModel.financialHistory[i].price,
                                        title: "Price",
                                        numberFormatter: numberInputFormatter()
                            )
                            
                            NumberInput(value: $viewModel.financialHistory[i].operatingIncome,
                                        title: "Operating Income",
                                        alertTitle: "Operating Income",
                                        alertMessage: "Test",
                                        numberFormatter: numberInputFormatter()
                            )
                            
                            NumberInput(value: $viewModel.financialHistory[i].depreciationAmortization,
                                        title: "Depreciation & Amortization",
                                        alertTitle: "Depreciation & Amortization",
                                        alertMessage: "Test",
                                        numberFormatter: numberInputFormatter()
                            )
                            
                            NumberInput(value: $viewModel.financialHistory[i].totalCash,
                                        title: "Total Cash",
                                        alertTitle: "Total Cash",
                                        alertMessage: "Test",
                                        numberFormatter: numberInputFormatter()
                            )
                            
                            NumberInput(value: $viewModel.financialHistory[i].totalDebt,
                                        title: "Total Debt",
                                        alertTitle: "Total Debt",
                                        alertMessage: "Test",
                                        numberFormatter: numberInputFormatter()
                            )
                        }
                    }
                }.scrollContentBackground(.hidden)
                
                Button(action: {
                    let nextView = tempNavPath[(tempNavPath.firstIndex(of: navPath[navPath.count - 1]) ?? 0) + 1]
                    navPath.append(nextView)
                    
                    viewModel.company.evEbitda = calculateEVEBITDA(company: viewModel.company, financialHistory: viewModel.financialHistory)
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
            .navigationTitle("EV EBITDA")
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
                case "DCF": DCFView(viewModel: $viewModel, navPath: $navPath, tempNavPath: $tempNavPath, total: $total, current: $current, profileSheet: $profileSheet, isAuthenticated: $isAuthenticated, currentUser: $currentUser)
                case "PBV": PBVView(viewModel: $viewModel, navPath: $navPath, tempNavPath: $tempNavPath, total: $total, current: $current, profileSheet: $profileSheet, isAuthenticated: $isAuthenticated, currentUser: $currentUser)
                case "PER": PERView(viewModel: $viewModel, navPath: $navPath, tempNavPath: $tempNavPath, total: $total, current: $current, profileSheet: $profileSheet, isAuthenticated: $isAuthenticated, currentUser: $currentUser)
                case "EV/EBITDA": EvEbitdaView(viewModel: $viewModel, navPath: $navPath, tempNavPath: $tempNavPath, total: $total, current: $current, profileSheet: $profileSheet, isAuthenticated: $isAuthenticated, currentUser: $currentUser)
                case "Result": ResultView(viewModel: $viewModel, navPath: $navPath, tempNavPath: $tempNavPath, total: $total, current: $current, profileSheet: $profileSheet, isAuthenticated: $isAuthenticated, currentUser: $currentUser)
                default: ValuationView(profileSheet: $profileSheet, isAuthenticated: $isAuthenticated, currentUser: $currentUser)
                }
           }
        }
    }

