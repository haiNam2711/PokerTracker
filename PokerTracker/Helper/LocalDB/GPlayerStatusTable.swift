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
    static let playerActive = Expression<Bool>("PlayerActive")
    static let sumCashIn = Expression<Int>("SumCashIn")
    static let sumCashOut = Expression<Int>("SumCashOut")
    
    static func insert(item: GPlayerStatus) throws {
        let DB = LocalDB.shared.getDB()
        let insert = playerInGame.insert(gameID <- item.gameID, playerID <- item.playerID, playerActive <- false, sumCashIn <- 0, sumCashOut <- 0)
        let rowId = try DB.run(insert)
        if rowId <= 0 {
            throw DBError(message: "error insert player status item")
        }
    }
    
    static func getAllPlayer(gameID: Int) throws -> [GetActivePlayerResult] {
        let DB = LocalDB.shared.getDB()
        let players = Table("Player")
        let name = Expression<String>("Name")
        let query = playerInGame
            .filter(self.gameID == gameID)
            .join(players, on: playerInGame[playerID] == players[playerID])
            .select([playerInGame[playerID], playerInGame[playerActive], playerInGame[sumCashIn], playerInGame[sumCashOut], players[name]])
        let rows = try DB.prepare(query)
        
        var res: [GetActivePlayerResult] = []
        for row in rows {
            res.append(GetActivePlayerResult(playerID: row[playerID], playerName: row[name], playerActive: row[playerActive], sumCashIn: row[sumCashIn], sumCashOut: row[sumCashOut]))
        }
        return res
    }
    
    static func update(withNewMoneyRecord record: GameRecord) throws {
        if record.cashIn > 0 && record.cashOut > 0 {
            throw DBError(message: "Cash in and cash out in the same time!!!!")
        }
        let DB = LocalDB.shared.getDB()
        let active = record.cashIn > 0 ? true : false
        
        let update = playerInGame.filter(gameID == record.gameID && playerID == record.playerID).update(playerActive <- active, sumCashIn += record.cashIn, sumCashOut += record.cashOut)
        let rowId = try DB.run(update)
        if rowId <= 0 {
            throw DBError(message: "error update player status item")
        }
    }
    
}
