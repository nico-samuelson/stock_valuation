//
//  Stock.swift
//  Valify
//
//  Created by Nico Samuelson on 26/04/24.
//

import Foundation
import SwiftData
import CloudKit

@Model
class Company: Codable, Identifiable {
    var id: UUID = UUID.init()
    var created_at = Date()
    var logo: String = ""
    var symbol: String = ""
    var name: String = ""
    var sector: String = "Technology"
    var price: Double = 0
    var changes: Double = 0
    var sharesOut: Double = 0
    var dcf: Double = 0
    var per: Double = 0
    var pbv: Double = 0
    var evEbitda: Double = 0
    var isPublic: Bool = true
    var beta: Double = 0
    var saveLocal: Bool = true
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        created_at = try container.decode(Date.self, forKey: .created_at)
        logo = try container.decode(String.self, forKey: .logo)
        symbol = try container.decode(String.self, forKey: .symbol)
        name = try container.decode(String.self, forKey: .name)
        sector = try container.decode(String.self, forKey: .sector)
        price = try container.decode(Double.self, forKey: .price)
        changes = try container.decode(Double.self, forKey: .changes)
        sharesOut = try container.decode(Double.self, forKey: .sharesOut)
        dcf = try container.decode(Double.self, forKey: .dcf)
        per = try container.decode(Double.self, forKey: .per)
        pbv = try container.decode(Double.self, forKey: .pbv)
        evEbitda = try container.decode(Double.self, forKey: .evEbitda)
        isPublic = try container.decode(Bool.self, forKey: .isPublic)
        beta = try container.decode(Double.self, forKey: .beta)
        saveLocal = try container.decode(Bool.self, forKey: .saveLocal)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(created_at, forKey: .created_at)
        try container.encode(logo, forKey: .logo)
        try container.encode(symbol, forKey: .symbol)
        try container.encode(name, forKey: .name)
        try container.encode(sector, forKey: .sector)
        try container.encode(price, forKey: .price)
        try container.encode(changes, forKey: .changes)
        try container.encode(sharesOut, forKey: .sharesOut)
        try container.encode(dcf, forKey: .dcf)
        try container.encode(per, forKey: .per)
        try container.encode(pbv, forKey: .pbv)
        try container.encode(evEbitda, forKey: .evEbitda)
        try container.encode(isPublic, forKey: .isPublic)
        try container.encode(beta, forKey: .beta)
        try container.encode(saveLocal, forKey: .saveLocal)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, created_at, logo, symbol, name, sector, price, changes, sharesOut, dcf, per, pbv, evEbitda, isPublic, beta, saveLocal
    }
    
    init() {}
    
    init(id: UUID, logo: String, symbol: String, name: String, sector: String, price: Double, changes: Double, sharesOut: Double, dcf: Double, per: Double, pbv: Double, evEbitda: Double, isPublic: Bool, beta: Double, saveLocal: Bool) {
        self.id = id
        self.logo = logo
        self.symbol = symbol
        self.name = name
        self.sector = sector
        self.price = price
        self.changes = changes
        self.sharesOut = sharesOut
        self.dcf = dcf
        self.per = per
        self.pbv = pbv
        self.evEbitda = evEbitda
        self.isPublic = isPublic
        self.beta = beta
        self.saveLocal = saveLocal
    }
}
