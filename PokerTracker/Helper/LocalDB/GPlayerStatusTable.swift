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
    static let sumCashIn = Expression<Int>("SumCashIn") //k
    static let sumCashOut = Expression<Int>("SumCashOut") //k
    static let sumCashAfterFee = Expression<Int>("SumCashAfterFee") //k + fee
    static let sumChip = Expression<Int>("SumChip") //chip
    
    static func insert(item: GPlayerStatus) throws {
        let DB = LocalDB.shared.getDB()
        let insert = playerInGame.insert(gameID <- item.gameID, playerID <- item.playerID, playerActive <- false, sumCashIn <- 0, sumCashOut <- 0, sumChip <- 0, sumCashAfterFee <- 0)
        let rowId = try DB.run(insert)
        if rowId <= 0 {
            throw DBError(message: "error insert player status item")
        }
    }
    
    static func findAllWithDate() throws -> [GPlayerStatusDate] {
        let DB = LocalDB.shared.getDB()
        let games = Table("Game")
        let time = Expression<Date>("Time")
        let itemsWithDateQuery = playerInGame
            .join(games, on: playerInGame[gameID] == games[gameID])
            .select([playerInGame[*],games[time]])
        var res = [GPlayerStatusDate]()
        let items = try DB.prepare(itemsWithDateQuery)
        for item in items {
            res.append(GPlayerStatusDate(playerID: item[playerID], gameID: item[gameID], playerActive: item[playerActive], sumCashIn: item[sumCashIn], sumCashOut: item[sumCashOut], sumChip: item[sumChip], sumCashAfterFee: item[sumCashAfterFee], date: item[time]))
        }
        return res
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
//        if record.cashIn > 0 && record.cashOut > 0 {
//            throw DBError(message: "Cash in and cash out in the same time!!!!")
//        }
        let DB = LocalDB.shared.getDB()
        let query = playerInGame.filter(self.gameID == record.gameID && self.playerID == record.playerID)
        if try DB.pluck(query) == nil {
            try insert(item: GPlayerStatus(playerID: record.playerID, gameID: record.gameID, playerActive: false, sumCashIn: 0, sumCashOut: 0, sumChip: 0, sumCashAfterFee: 0))
        }
        let active = record.cashIn > 0 ? true : false
        guard let game = try GameTable.find(gameID: record.gameID) else {return}
        var addSumCashAfterFee: Int = 0
        let cashInF = Float(record.cashIn)
        let feeF = Float(game.fee)
        if record.cashIn > 0 {
            if game.feeTypeInValue == true {
                addSumCashAfterFee = record.cashIn + ((record.cashIn)/game.standardCashIn)*game.fee
            } else {
                addSumCashAfterFee = Int(cashInF + cashInF*(feeF/(100.0)))

            }
        }
        let update = playerInGame.filter(gameID == record.gameID && playerID == record.playerID).update(playerActive <- active, sumCashIn += record.cashIn, sumCashOut <- record.cashOut, sumCashAfterFee += addSumCashAfterFee)
        let rowId = try DB.run(update)
        if rowId <= 0 {
            print("error here2")
            throw DBError(message: "error update player status item")
        }
    }
    
    static func deleteARecord(gameRecord: GameRecord) throws {
        let DB = LocalDB.shared.getDB()
        // GET old status
        let object = try DB.pluck(playerInGame.filter(gameID == gameRecord.gameID && playerID == gameRecord.playerID))
        let gameID = Expression<Int>("GameID")
        let playerID = Expression<Int>("PlayerID")
        let playerActive = Expression<Bool>("PlayerActive")
        let sumCashIn = Expression<Int>("SumCashIn")
        let sumCashOut = Expression<Int>("SumCashOut")
        let sumCashAfterFee = Expression<Int>("SumCashAfterFee")
        let sumChip = Expression<Int>("SumChip")
        let oldGameStatus = GPlayerStatus(playerID: object![playerID], gameID: object![gameID], playerActive: object![playerActive], sumCashIn: object![sumCashIn], sumCashOut: object![sumCashOut], sumChip: object![sumChip], sumCashAfterFee: object![sumCashAfterFee])
        
        // Create new active
        var active: Bool = true
        if gameRecord.cashIn > 0 {
            if oldGameStatus.sumCashIn - gameRecord.cashIn > 0 {
                active = true
            } else {
                active = false
            }
        } else {
            active = true
        }
        // Create new sumcash
        guard let game = try GameTable.find(gameID: gameRecord.gameID) else {return}
        var addSumCashAfterFee = 0
        let cashInF = Float(gameRecord.cashIn)
        let feeF = Float(game.fee)
        if gameRecord.cashIn > 0 {
            if game.feeTypeInValue == true {
                addSumCashAfterFee = gameRecord.cashIn + ((gameRecord.cashIn)/game.standardCashIn)*game.fee
            } else {
                addSumCashAfterFee = Int(cashInF + cashInF*(feeF/(100.0)))
            }
        }
        // delete record
        let update = playerInGame.filter(gameID == gameRecord.gameID && playerID == gameRecord.playerID).update(playerActive <- active, sumCashIn -= gameRecord.cashIn, sumCashOut <- gameRecord.cashOut, sumCashAfterFee -= addSumCashAfterFee)
        _ = try DB.run(update)
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
    
    static func updatePlayer(idGame: Int, idPlayer: Int, cashIn: Int, cashOut: Int, cashFee: Int, chipOut: Int, active: Bool) throws -> GPlayerStatus {
        let DB = LocalDB.shared.getDB()
        let update = playerInGame.update(playerActive <- active, sumCashIn <- cashIn, sumCashOut <- cashOut, sumCashAfterFee <- cashFee, sumChip <- chipOut, gameID <- idGame, playerID <- idPlayer)
        _ = try DB.run(update)

        return GPlayerStatus(playerID: idPlayer, gameID: idGame, playerActive: active, sumCashIn: cashIn, sumCashOut: cashOut, sumChip: chipOut, sumCashAfterFee: cashFee)
    }
}
