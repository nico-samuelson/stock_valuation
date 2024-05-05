//
//  CompanyDetailSheet.swift
//  Valify
//
//  Created by Nico Samuelson on 05/05/24.
//

import SwiftUI

struct Result: Hashable {
    let method: String
    let value: Double
}

struct CompanyDetailSheet: View {
    @Environment(\.dismiss) var dismiss
    let company: Company
    @State var avgFV : Double = 0
    @State var results: [Result] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                AsyncImage(url: URL(string: company.logo)) { image in
                    image.resizable().aspectRatio(contentMode: .fit)
                }
                placeholder: {
                    Circle().foregroundColor(.secondary)
                }
                .frame(width: 48, height: 48)
                .cornerRadius(50)
                
                VStack(alignment: .leading) {
                    Text(company.symbol)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.bottom, 1)
                    Text(company.name)
                        .frame(maxWidth:200)
                        .lineLimit(1)
                        .fixedSize()
                        .truncationMode(.tail)
                }
                
                Spacer(minLength: 20)
                
                VStack(alignment: .trailing) {
                    Text(String(self.company.price))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.bottom, 1)
                    Text("\(String(format:"%.02f", self.company.changes))%")
                        .foregroundStyle(self.company.changes >= 0 ? .green : .red)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
//            Divider().padding(.vertical, 0).padding(.leading, 20)
            
            List {
                ForEach(results, id:\.self) { result in
                    if (result.value > 0.0) {
//                        VStack {
                            HStack(alignment: .center) {
                                ValuationResult(
                                    method: result.method,
                                    fairValue: result.value,
                                    marginOfSafety: (Double(result.value) / Double(company.price)) - 1
                                )
                            }
//                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .listRowSpacing(16)
//            .scrollContentBackground(.hidden)
        }
        .onAppear(perform: {
            var fairValues: [Double] = [company.dcf, company.per, company.pbv, company.evEbitda]
            
            fairValues = fairValues.filter { $0 > 0 }
            
            self.avgFV = fairValues.reduce(0, +) / Double(fairValues.count)
            
            let methods = [
                "DCF": company.dcf,
                "PER": company.per,
                "PBV": company.pbv,
                "EV/EBITDA": company.evEbitda
            ]
            results = methods.map { Result(method: $0.key, value: $0.value)}
        })
        .presentationDetents([.fraction(0.9)])
    }
}

//#Preview {
//    CompanyDetailSheet()
//}
