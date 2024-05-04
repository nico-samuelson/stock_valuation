//
//  HistoryList.swift
//  Valify
//
//  Created by Nico Samuelson on 04/05/24.
//

import SwiftUI

struct HistoryList: View {
    @Environment(\.modelContext) var context
    let company: Company
    
    init(company: Company) {
        self.company = company
    }
    
    var body: some View {
        HStack(){
            if (self.company.logo != "") {
                AsyncImage(url: URL(string: self.company.logo)) { image in
                    image.resizable().aspectRatio(contentMode: .fit)
                }
                placeholder: {
                    Circle().foregroundColor(.secondary)
                }
                .frame(width: 48, height: 48)
                .cornerRadius(50)
            }
            
            VStack(alignment: .leading) {
                Text(self.company.symbol)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding(.bottom, 1)
                Text(self.company.name)
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
            }
            .padding(.vertical, 8)
        }
    }
}

//#Preview {
//    HistoryList()
//}
