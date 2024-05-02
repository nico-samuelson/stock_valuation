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
class Company {
    var id: UUID = UUID.init()
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
