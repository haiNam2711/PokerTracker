//
//  GameTable.swift
//  PokerTracker
//
//  Created by Hai Nam on 9/4/24.
//

import Foundation
import SQLite

class GameTable {
    static let games = Table("Game")
    static let id = Expression<Int>("GameID")
    static let time = Expression<Date>("Time")
    static let cashIn = Expression<Int>("CashIn") //k
    static let chipOut = Expression<Int>("ChipOut") // chip
    static let feeTypeInValue = Expression<Bool>("FeeTypeInValue")
    static let fee = Expression<Int>("Fee")
    
    static func insert(item: Game) throws -> Game? {
        let DB = LocalDB.shared.getDB()
        let insert = games.insert(time <- item.time, cashIn <- item.standardCashIn, chipOut <- item.standardChipOut, feeTypeInValue <- item.feeTypeInValue, fee <- item.fee)
        let rowId = try DB.run(insert)
        guard rowId > 0 else { return nil }
        return Game(id: Int(rowId), time: item.time, standardCashIn: item.standardCashIn, standardChipOut: item.standardChipOut, feeTypeInValue: item.feeTypeInValue, fee: item.fee)
    }
    
    static func findAll() throws -> [Game]? {
        let DB = LocalDB.shared.getDB()
        var retArray = [Game]()
        let items = try DB.prepare(games)
        for item in items {
            retArray.append(Game(id:item[id], time: item[time], standardCashIn: item[cashIn], standardChipOut: item[chipOut], feeTypeInValue: item[feeTypeInValue], fee: item[fee]))
        }
        return retArray
    }
    
    static func find(gameID: Int) throws -> Game? {
        let DB = LocalDB.shared.getDB()
        let query = games.filter(id == gameID)
//        let items = try DB.prepare(games)
//        for item in items {
//            return Game(id:item[id], time: item[time], standardCashIn: item[cashIn], standardChipOut: item[chipOut], feeTypeInValue: item[feeTypeInValue], fee: item[fee])

        if let game = try DB.pluck(query) {
            return Game(id: game[id], time: game[time], standardCashIn: game[cashIn], standardChipOut: game[chipOut], feeTypeInValue: game[feeTypeInValue], fee: game[fee])
        }
        return nil
    }
}
