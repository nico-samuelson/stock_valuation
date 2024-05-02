//import PlaygroundSupport

import Foundation


func callAPI(url: String) -> NSDictionary? {
    let url = URL(string: url)
    var request = URLRequest(url: url!)
    var result : NSDictionary = NSDictionary()

    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    let task = URLSession.shared.dataTask(with: url!) { data, response, error in
        guard error == nil else {
            print(error!)
            return
        }
        guard let data = data else {
            print("Data is empty")
            return
        }

        let json: NSArray = try! JSONSerialization.jsonObject(with: data, options: []) as! NSArray
        
        result = json[0] as! NSDictionary
    }
    task.resume()
    
    return result
}

func fetchCompanyInfo(symbol: String) {
    
}

func fetchCompanyData(symbol: String) {
    
}

func fetchCompanyFinancial(symbol: String) {
    
}
