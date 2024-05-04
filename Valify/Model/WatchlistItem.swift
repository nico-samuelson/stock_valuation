//
//  WatchlistItem.swift
//  Valify
//
//  Created by Nico Samuelson on 02/05/24.
//

import Foundation

struct WatchlistItem: Codable {
    var id: UUID
    var created_at: Date
    var watchlist_id: UUID
    var company_id: UUID
}
