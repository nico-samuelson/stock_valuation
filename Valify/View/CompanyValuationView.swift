//
//  ResultView.swift
//  Valify
//
//  Created by Nico Samuelson on 29/04/24.
//

import SwiftUI



struct CompanyValuationView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State var avgFV : Double = 0
    let company: Company
    let results: [Result]
    
    init(company: Company) {
        self.company = company
        let methods = [
            "DCF": company.dcf,
            "PER": company.per,
            "PBV": company.pbv,
            "EV/EBITDA": company.evEbitda
        ]
        self.results = methods.map { Result(method: $0.key, value: $0.value)}
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Text("On average, \(company.name) has fair value of \(String(format: "%.2f", self.avgFV)), representing \(String(format: "%.0f", (self.avgFV > 0 ? ((self.avgFV / self.company.price - 1) * 100) : 0)))% margin of safety from current price")
                        .padding(.vertical, 8)
                    
                    ForEach(results, id:\.self) { result in
                        if (result.value > 0.0) {
                            VStack {
                                HStack(alignment: .center) {
                                    ValuationResult(
                                        method: result.method,
                                        fairValue: result.value,
                                        marginOfSafety: (Double(result.value) / Double(company.price)) - 1
                                    )
                                }
                            }
                        }
                    }
                }
            }
            .onAppear(perform: {
                var fairValues: [Double] = [company.dcf, company.per, company.pbv, company.evEbitda]
                
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
        }
    }
}

//#Preview {
//    ResultView(navPath: $navPath, tempNavPath: $tempNavPath)
//}
