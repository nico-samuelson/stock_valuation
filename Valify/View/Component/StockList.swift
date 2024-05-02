import SwiftUI
import Foundation

struct StockList: View {
    let company: Company
    
    init(company: Company) {
        self.company = company
    }
    
    var body: some View {
        HStack(){
            if (self.company.logo != "") {
                Image(self.company.logo)
                    .resizable()
                    .frame(width: 48, height: 48)
                    .aspectRatio(contentMode: .fit)
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
                Text("\(String(format:"%.02f", self.company.changes))%")
                    .foregroundStyle(.green)
            }
        }
        .padding(.vertical, 8)
    }
}


//#Preview {
//    StockList(company: Company(logo: "cafe-style-hot-coffee-recipe-1", ticker: "BBCA", name: "Bank Central Asia Tbk.", price: 9725, changes: 0.97, sharesOut: 0, dcf: 0, per: 0, pbv: 0, evEbitda: 0))
//        .modelContainer(for: Item.self, inMemory: true)
//}
