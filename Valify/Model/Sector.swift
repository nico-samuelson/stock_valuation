//
//  Sectors.swift
//  Valify
//
//  Created by Nico Samuelson on 27/04/24.
//

import Foundation

struct Sector: Identifiable, Equatable, Hashable {
    var id : UUID
    var name : String
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
    
    static func == (lhs: Sector, rhs: Sector) -> Bool {
            lhs.id == rhs.id
        }
}
