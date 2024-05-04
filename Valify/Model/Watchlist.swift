//
//  Watchlist.swift
//  Valify
//
//  Created by Nico Samuelson on 02/05/24.
//

import Foundation

class Watchlist: Codable, Identifiable {
    var id: UUID
    var created_at: Date
    var user_id: UUID
    var name: String
    
    init(id: UUID, created_at: Date, user_id: UUID, name: String) {
        self.id = id
        self.created_at = created_at
        self.user_id = user_id
        self.name = name
    }
}
