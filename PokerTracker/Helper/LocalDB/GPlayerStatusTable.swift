//
//  GPlayerStatusTable.swift
//  PokerTracker
//
//  Created by Hai Nam on 9/4/24.
//

import Foundation
import SQLite

class GPlayerStatusTable {
    
    static let playerInGame = Table("PlayerInGame")
    static let gameID = Expression<Int>("GameID")
    static let playerID = Expression<Int>("PlayerID")
    static let sumCashIn = Expression<Int>("SumCashIn")
    static let sumCashOut = Expression<Int>("SumCashOut")
    
    static func insert(item: GPlayerStatus) throws {
        let DB = LocalDB.shared.getDB()
        let insert = playerInGame.insert(gameID <- item.gameID, playerID <- item.playerID, sumCashIn <- 0, sumCashOut <- 0)
        let rowId = try DB.run(insert)
        if rowId <= 0 {
            throw DBError(message: "error insert player status item")
        }
    }
    
}
