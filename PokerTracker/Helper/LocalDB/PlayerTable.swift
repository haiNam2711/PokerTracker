//
//  PlayerTable.swift
//  PokerTracker
//
//  Created by Hai Nam on 9/4/24.
//

import Foundation
import SQLite

class PlayerTable {
    static let players = Table("Player")
    static let id = Expression<Int>("PlayerID")
    static let name = Expression<String>("Name")
    
    static func insert(item: Player) throws -> Player {
        let DB = LocalDB.shared.getDB()
        let insert = players.insert(name <- item.name)
        let rowId = try DB.run(insert)
        if rowId <= 0 {
            throw DBError(message: "error insert game item")
        }
        return Player(id: Int(rowId), name: item.name)
    }
    
    static func findAll() throws -> [Player]? {
        let DB = LocalDB.shared.getDB()
        var retArray = [Player]()
        let items = try DB.prepare(players)
        for item in items {
            retArray.append(Player(id: item[id], name: item[name]))
        }
        return retArray
    }
    
}
