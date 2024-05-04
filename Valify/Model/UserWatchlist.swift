//
//  UserWatchlist.swift
//  Valify
//
//  Created by Nico Samuelson on 02/05/24.
//

import Foundation

struct UserWatchlist: Codable {
    var id: UUID
    var created_at: Date
    var watchlist_id: UUID
}
