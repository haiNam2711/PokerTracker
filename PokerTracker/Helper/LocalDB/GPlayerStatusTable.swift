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
    static let sumCashAfterFee = Expression<Int>("SumCashAfterFee")
    static let sumChip = Expression<Int>("SumChip")
    
    static func insert(item: GPlayerStatus) throws {
        let DB = LocalDB.shared.getDB()
        let insert = playerInGame.insert(gameID <- item.gameID, playerID <- item.playerID, playerActive <- false, sumCashIn <- 0, sumCashOut <- 0, sumChip <- 0, sumCashAfterFee <- 0)
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
            .select([playerInGame[*], players[name]])
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
        guard let game = try GameTable.find(gameID: record.gameID) else {return}
        var addSumCashAfterFee: Int = 0
        if record.cashIn > 0 {
            if game.feeTypeInValue == true {
                addSumCashAfterFee = record.cashIn - game.fee
            } else {
                addSumCashAfterFee = record.cashIn * (1 - game.fee)
            }
        }
        
        let update = playerInGame.filter(gameID == record.gameID && playerID == record.playerID).update(playerActive <- active, sumCashIn += record.cashIn, sumCashOut += record.cashOut, sumCashAfterFee += addSumCashAfterFee)
        let rowId = try DB.run(update)
        if rowId <= 0 {
            throw DBError(message: "error update player status item")
        }
    }
    
    static func getPlayerStatus(gameID: Int, playerID: Int) throws -> GPlayerStatus? {
        let DB = LocalDB.shared.getDB()
        let query = playerInGame.filter(self.gameID == gameID && self.playerID == playerID)
        if let row = try DB.pluck(query) {
            return GPlayerStatus(playerID: row[self.playerID], gameID: row[self.gameID], playerActive: row[playerActive], sumCashIn: row[sumCashIn], sumCashOut: row[sumCashOut], sumChip: row[sumChip], sumCashAfterFee: row[sumCashAfterFee])
        } else {
            return nil
        }
    }
    
}
