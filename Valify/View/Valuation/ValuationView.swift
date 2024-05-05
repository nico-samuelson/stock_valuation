//
//  ValuationView.swift
//  Valify
//
//  Created by Nico Samuelson on 27/04/24.
//

import Foundation
import SwiftUI
import Auth

enum Method: String, CaseIterable, Equatable {
    case None = "None"
    case DCF = "DCF"
    case EVEBITDA = "EV/EBITDA"
    case PER = "PER"
    case PBV = "PBV"
    
    static func ==(lhs: Method, rhs: Method) -> Bool {
        // Implement custom logic for equating methods
        // For example:
        return "\(lhs)" == "\(rhs)"
    }
}

struct ValuationView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    let sectors: [String] = [
        "Basic Materials",
        "Communication Services",
        "Consumer Cyclical",
        "Consumer Defensive",
        "Energy",
        "Financial",
        "Healthcare",
        "Industrials",
        "Real Estate",
        "Technology",
        "Utilities"
    ]
    
    @State var navPath: [String] = []
    @State var tempNavPath : [String] = ["DCF", "Result"]
    @State var total: Double = 0
    @State var current: Double = 0
    @State var viewModel = FormViewModel()
    
    var body: some View {
        NavigationStack(path: $navPath){
            VStack {
                Form {
                    Section{
                        Toggle("Public Traded Company", isOn: $viewModel.company.isPublic)
                            .onChange(of: viewModel.company.isPublic) { value in
                                if (!value) {
                                    viewModel.methods = [Method.DCF]
                                }
                            }
                    }
                    
                    Section(header: Text("Company")) {
                        HStack(spacing: 20){
                            Text("Company Name")
                            TextField("Apple Inc.", text: $viewModel.company.name)
                                .multilineTextAlignment(.trailing)
                        }
                        
                        HStack(spacing: 20){
                            Text("Ticker")
                            TextField("AAPL", text: $viewModel.company.symbol)
                                .multilineTextAlignment(.trailing)
                        }
                        
                        HStack(spacing: 20){
                            Picker("Sectors", selection: $viewModel.company.sector) {
                                ForEach(sectors, id:\.self) { sector in
                                    Text(sector).tag(sector)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                    }
                    
                    Section(header: Text("Shares")) {
                        if (viewModel.company.isPublic) {
                            NumberInput(value: $viewModel.company.price,
                                        title: "Current Price",
                                        alertTitle: "",
                                        alertMessage: "",
                                        numberFormatter: numberInputFormatter()
                            ).onChange(of: viewModel.company.price) { value in
                                print(value)
                            }
                        }
                        
                        NumberInput(value: $viewModel.company.sharesOut, 
                                    title: "Shares Outstanding",
                                    numberFormatter: numberInputFormatter()
                        )
                    }
                    
                    Section(header: Text("Duration")) {
                        Stepper("\(viewModel.duration)" + (viewModel.duration > 1 ? " Years" : " Year"), value: $viewModel.duration, in: 2...5)
                            .onChange(of: viewModel.duration) { value in
                                if value > viewModel.financialHistory.count {
                                    viewModel.financialHistory.append(CompanyFinancial())
                                }
                                else {
                                    viewModel.financialHistory.remove(at: viewModel.financialHistory.count - 1)
                                }
                            }
                    }
                    
                    if (viewModel.company.isPublic) {
                        Section(header: Text("Methods")) {
                            Toggle(isOn: binding(for: Method.DCF)) {
                                Text("DCF")
                            }
                            Toggle(isOn: binding(for: Method.PER)) {
                                Text("PER")
                            }
                            Toggle(isOn: binding(for: Method.PBV)) {
                                Text("PBV")
                            }
                            Toggle(isOn: binding(for: Method.EVEBITDA)) {
                                Text("EV/EBITDA")
                            }
                        }
                    }
                }.scrollContentBackground(.hidden)
                
                Button(action: {
                    if (navPath.isEmpty) {
                        navPath.append(tempNavPath[0])
                    }
                    else {
                        navPath.append(tempNavPath[(tempNavPath.firstIndex(of: navPath[navPath.count - 1]) ?? 0) + 1])
                    }
                    
                    print(navPath)
                }, label: {
                    Text("Continue").frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.blue)
                        .foregroundStyle(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                })
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }
            .background(colorScheme == .light ? Color.init(red: 242.0/255, green: 242.0/255, blue: 247.0/255) : Color.black)
            .navigationTitle("Valuation")
            .navigationBarTitleDisplayMode(.large)
            .toolbar{
                Menu(content: {
                    Section {
                        Button(role:.destructive, action: {
//                            currentUser = nil
                        }) {
                            Label("Logout", systemImage: "rectangle.portrait.and.arrow.forward")
                        }
                    }
                }, label: {
                    Button {
                        
                    } label: {
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
    
    private func binding(for method: Method) -> Binding<Bool> {
        Binding(
            get: { viewModel.methods.contains(method) },
            set: { newValue in
                if newValue {
                    viewModel.methods.append(method)
                    tempNavPath.insert(method.rawValue, at: tempNavPath.count - 1)
                } else {
                    viewModel.methods.removeAll { $0 == method }
                    tempNavPath.removeAll{ $0 == method.rawValue }
                }
            }
        )
    }
}



#Preview {
    ValuationView()
}
