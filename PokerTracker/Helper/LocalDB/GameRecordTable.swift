//
//  GameRecord.swift
//  PokerTracker
//
//  Created by Hai Nam on 9/4/24.
//

import Foundation
import SQLite

class GameRecordTable {
    
    static let gameRecord = Table("GameRecord")
    static let gameID = Expression<Int>("GameID")
    static let playerID = Expression<Int>("PlayerID")
    static let time = Expression<Date>("Time")
    static let cashIn = Expression<Int>("CashIn")
    static let cashOut = Expression<Int>("CashOut")
    
    static func insert(item: GameRecord) throws {
        let DB = LocalDB.shared.getDB()
        let insert = gameRecord.insert(gameID <- item.gameID, playerID <- item.playerID, time <- item.time, cashIn <- item.cashIn, cashOut <- item.cashOut)
        let rowId = try DB.run(insert)
        if rowId <= 0 {
            print("error here")
            throw DBError(message: "error insert game record item")
        }
    }
    
    #warning("Can bug")
    static func update(item: GameRecord) throws {
        let DB = LocalDB.shared.getDB()
        let getGameRecordQuery = gameRecord.filter(self.gameID == item.gameID && self.playerID == item.playerID)
        let update = gameRecord.filter(gameID == item.gameID && playerID == item.playerID).update(time <- item.time, cashIn <- item.cashIn, cashOut <- item.cashOut)
        let rowId = try DB.run(update)
        if rowId <= 0 {
            throw DBError(message: "error update gamerecord item")
        }
    }
    
    static func findAll(byGameID gameID: Int) throws -> [GetGameRecordResult] {
        let DB = LocalDB.shared.getDB()
        let players = Table("Player")
        let name = Expression<String>("Name")
        let query = gameRecord
            .filter(self.gameID == gameID)
            .join(players, on: gameRecord[playerID] == players[playerID])
            .select([gameRecord[*], players[name]])
        
        let rows = try DB.prepare(query)
        
        var res: [GetGameRecordResult] = []
        for row in rows {
            res.append(GetGameRecordResult(playerName: row[name], gameID: row[self.gameID], time: row[time], playerID: row[playerID], cashIn: row[cashIn], cashOut: row[cashOut]))
        }
        return res
    }
    
}
