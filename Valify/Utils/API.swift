//import PlaygroundSupport

import Foundation
//import Atomics

// DEFINE YOUR API KEY HERE
// let apiKey = ""

func callAPI(url: String, completion: @escaping (NSArray?, Error?) -> Void) {
    let url = URL(string: url)
    var request = URLRequest(url: url!)
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    let task = URLSession.shared.dataTask(with: url!) { data, response, error in
        completion(data != nil ? try? (JSONSerialization.jsonObject(with: data!, options: []) as! NSArray) : nil, error)
    }
    task.resume()
}

func getHistoricalPrice(company: Company, financials: [CompanyFinancial]) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-DD"
    var dateComponent = DateComponents()
    dateComponent.day = 7
    
    let group = DispatchGroup()
    
    for financial in financials {
        group.enter()
        let year = Calendar.current.component(.year, from: financial.date)
        print("\(year)-01-01")

        let url = URL(string: "https://financialmodelingprep.com/api/v3/historical-price-full/\(company.symbol)?from=\(year)-01-01&to=\(year)-01-07&apikey=\(apiKey)")
        
        var request = URLRequest(url: url!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            guard let response = response else { return }
            
            let json : NSDictionary? = try! JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
            let prices: NSArray? = json?["historical"] as? NSArray
            
            if (prices?.count ?? 0 > 0) {
                let price = prices?[0] as! NSDictionary
                financial.price = price["open"] as! Double
                
                print(financial.price)
            }
            group.leave()
        }
        task.resume()
    }
    
    group.wait()
    Task {
        print(financials.map{$0.price})
        let sortedFinancials = financials.sorted{$0.date >= $1.date}
        company.dcf = calculateDCF(company: company, financialHistory: sortedFinancials, bondYield: 0.046, indexYield: 0.1688)
        company.per = calculatePER(company: company, financialHistory: sortedFinancials)
        company.pbv = calculatePBV(company: company, financialHistory: sortedFinancials)
        company.evEbitda = calculateEVEBITDA(company: company, financialHistory: sortedFinancials)
        try await insertCompany(company: company)
        try await insertCompanyFinancial(financials: sortedFinancials)
    }
}

func fetchCompanyInfo(symbol: String, completion: @escaping (Company) -> Void) -> Company {
    let company = Company()
    
    callAPI(url: "https://financialmodelingprep.com/api/v3/profile/\(symbol)?apikey=\(apiKey)") { response, error in
        if let error = error {
            print(error)
            return
        }
        guard let response = response else { return }
        
        let responseDict: NSDictionary? = response[0] as? NSDictionary
        
        company.name = responseDict?["companyName"] as! String
        company.symbol = responseDict?["symbol"] as! String
        company.price = responseDict?["price"] as! Double
        company.changes = responseDict?["changes"] as! Double
        company.sector = responseDict?["sector"] as! String
        company.logo = responseDict?["image"] as! String
        company.isPublic = true
        company.saveLocal = false
        company.beta = responseDict?["beta"] as! Double
        
        completion(company)
    }
    
    return company
}

func fetchCompanyIncomeStatement(company: Company, completion: @escaping ([CompanyFinancial]) -> Void) {
    var financials : [CompanyFinancial] = []
    let formatter = DateFormatter()
    print(company.name)
    formatter.dateFormat = "yyyy-MM-DD"
    
    callAPI(url: "https://financialmodelingprep.com/api/v3/income-statement/\(company.symbol)?period=annual&limit=5&apikey=\(apiKey)") { response, error in
        //        DispatchQueue.main.async {
        for i in 0..<(response?.count ?? 0) {
            let financial = CompanyFinancial()
            let data: NSDictionary? = response?[i] as? NSDictionary
            
            if i == 0 {
                company.sharesOut = data?["weightedAverageShsOutDil"] as! Double
            }
            
            financial.company_id = company.id
            financial.date = formatter.date(from: data?["date"] as! String) ?? Date.now
            financial.revenue = data?["revenue"] as! Double
            financial.interestExpense = data?["interestExpense"] as! Double
            financial.operatingIncome = data?["operatingIncome"] as! Double
            financial.pretaxIncome = data?["incomeBeforeTax"] as! Double
            financial.taxProvision = data?["incomeTaxExpense"] as! Double
            financial.netIncome = data?["netIncome"] as! Double
            
            financials.append(financial)
        }
        completion(financials)
    }
}

func fetchCompanyBalanceSheet(financials: [CompanyFinancial], company: Company, completion: @escaping ([CompanyFinancial]) -> Void) {
    callAPI(url: "https://financialmodelingprep.com/api/v3/balance-sheet-statement/\(company.symbol)?period=annual&limit=5&apikey=\(apiKey)") { response, error in
        for i in 0..<(response?.count ?? 0) {
            let data: NSDictionary? = response?[i] as? NSDictionary
            
            financials[i].cashAndEquivalents = data?["cashAndCashEquivalents"] as! Double
            financials[i].totalCash = data?["cashAndCashEquivalents"] as! Double
            financials[i].totalDebt = data?["totalDebt"] as! Double
            financials[i].totalEquity = data?["totalEquity"] as! Double
        }
        
        completion(financials)
    }
}

func fetchCompanyCashFlow(company: Company, financials: [CompanyFinancial], completion: @escaping ([CompanyFinancial]) -> Void) {
    callAPI(url: "https://financialmodelingprep.com/api/v3/cash-flow-statement/\(company.symbol)?period=annual&limit=5&apikey=\(apiKey)") { response, error in
        for i in 0..<(response?.count ?? 0) {
            let data: NSDictionary? = response?[i] as? NSDictionary
            
            financials[i].operatingCashFlow = data?["operatingCashFlow"] as! Double
            financials[i].capEx = data?["capitalExpenditure"] as! Double * -1
            financials[i].depreciationAmortization = data?["depreciationAndAmortization"] as! Double
        }
        
        
        completion(financials)
    }
}

func fetchCompanyData(symbol: String) async {
    var company: Company = Company()
    var financials : [CompanyFinancial] = []
    
    await withCheckedContinuation { continuation in
        fetchCompanyInfo(symbol: symbol) { data in
            company = data
            continuation.resume()
        }
    }
    
    await withCheckedContinuation{ continuation in
        fetchCompanyIncomeStatement(company: company) { data in
            financials = data
            continuation.resume()
        }
        
//        print(financials.map{$0.netIncome})
    }
    
    await withCheckedContinuation{ continuation in
        fetchCompanyBalanceSheet(financials: financials, company: company) { data in
            financials = data
            continuation.resume()
        }
//        print(financials.map {$0.totalDebt})
    }
    
    await withCheckedContinuation { continuation in
        fetchCompanyCashFlow(company: company, financials: financials)
        { data in
            financials = data
            
            continuation.resume()
        }
    }
    
    await withCheckedContinuation { continuation in
       getHistoricalPrice(company: company, financials: financials)
//        print(financials.map { $0.depreciationAmortization })
//        print(financials.map {$0.netIncome})
//        print(financials.map{$0.totalCash})
        continuation.resume()
    }
}

func insertCompany(company: Company) async throws {
    do {
        try await supabase.database.from("Company").insert(company).execute()
    }
    catch {
        print(error.localizedDescription)
    }
    
}

func insertCompanyFinancial(financials: [CompanyFinancial]) async throws {
    do {
        for financial in financials {
            try await supabase.database.from("CompanyFinancial").insert(financial).execute()
        }
        
    }
    catch {
        print(error.localizedDescription)
    }
}
