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
    static let cashIn = Expression<Int>("CashIn")
    static let chipOut = Expression<Int>("ChipOut")
    static let fee = Expression<Int>("Fee")
    
    static func insert(item: Game) throws -> Game? {
        do {
            let DB = LocalDB.shared.getDB()
            let insert = games.insert(time <- item.time, cashIn <- item.standardCashIn, chipOut <- item.standardChipOut, fee <- item.fee)
            let rowId = try DB.run(insert)
            guard rowId > 0 else { return nil }
            return Game(id: Int(rowId), time: item.time, standardCashIn: item.standardCashIn, standardChipOut: item.standardChipOut, fee: item.fee)
        } catch {
            print("error insert game item: \(error)")
            return nil
        }
    }
    
    static func findAll() throws -> [Game]? {
        do {
            let DB = LocalDB.shared.getDB()
            var retArray = [Game]()
            let items = try DB.prepare(games)
            for item in items {
                retArray.append(Game(time: item[time], standardCashIn: item[cashIn], standardChipOut: item[chipOut], fee: item[fee]))
            }
            return retArray
        } catch {
            print("Error games: \(error)")
            return nil
        }
    }
    
}
