//
//  ResultView.swift
//  Valify
//
//  Created by Nico Samuelson on 29/04/24.
//

import SwiftUI

struct ResultView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Binding var viewModel: FormViewModel
    @Binding var navPath: [String]
    @Binding var tempNavPath: [String]
    @Binding var total: Double
    @Binding var current: Double
    @State var avgFV : Double = 0
    
    var body: some View {
        VStack {
            List {
                Text("On average, \(viewModel.company.name) has fair value of \(String(format: "%.2f", self.avgFV)), representing \(String(format: "%.0f", (self.avgFV / self.viewModel.company.price - 1) * 100))% margin of safety from current price")
                    .padding(.vertical, 8)
                
                ForEach(0..<viewModel.methods.count, id:\.self) { i in
                    VStack {
                        HStack(alignment: .center) {                              
                            switch(viewModel.methods[i]) {
                            case .None:
                                ValuationResult(
                                    method: "",
                                    fairValue: viewModel.company.dcf / viewModel.company.sharesOut,
                                    marginOfSafety: (viewModel.company.dcf) - 1
                                )
                                
                            case .DCF:
                                ValuationResult(
                                    method: "DCF",
                                    fairValue: viewModel.company.dcf,
                                    marginOfSafety: (viewModel.company.dcf / viewModel.company.price) - 1
                                )
                            case .PER:
                                ValuationResult(
                                    method: "PER",
                                    fairValue: viewModel.company.per,
                                    marginOfSafety: (viewModel.company.per / viewModel.company.price) - 1
                                )
                            case .PBV:
                                ValuationResult(
                                    method: "PBV",
                                    fairValue: viewModel.company.pbv,
                                    marginOfSafety: (viewModel.company.pbv / viewModel.company.price) - 1
                                )
                            case .EVEBITDA:
                                ValuationResult(
                                    method: "EV/EBITDA",
                                    fairValue: viewModel.company.evEbitda,
                                    marginOfSafety: (viewModel.company.evEbitda / viewModel.company.price) - 1
                                )
                            }
                        }
                    }
                }
            }
            
            if (navPath.count > 0) {
                Button(action: {
                    viewModel = FormViewModel()
                    navPath.removeAll()
                    
                }, label: {
                    Text("Done").frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.blue)
                        .foregroundStyle(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                })
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }
        }
        .onAppear(perform: {
            var fairValues: [Double] = [viewModel.company.dcf, viewModel.company.per, viewModel.company.pbv, viewModel.company.evEbitda]
            
            fairValues = fairValues.filter { $0 > 0 }
            
            self.avgFV = fairValues.reduce(0, +) / Double(fairValues.count)
        })
        .background(colorScheme == .light ? Color.init(red: 242.0/255, green: 242.0/255, blue: 247.0/255) : Color.black)
        .listStyle(.insetGrouped)
        .listRowSpacing(16)
        .navigationTitle("Result")
        .navigationBarTitleDisplayMode(.large)
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

//#Preview {
//    ResultView(navPath: $navPath, tempNavPath: $tempNavPath)
//}
