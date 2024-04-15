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
    
    static func updateName(idPlayer: Int, newName: String) throws{
        let DB = LocalDB.shared.getDB()
        let query = players.filter(id == idPlayer)
        let update = query.update(name <- newName)
        let afterRow = try DB.run(update)
        if afterRow == 0 {
            throw DBError(message: "Không tìm thấy người chơi với id: \(idPlayer) để cập nhật tên")
        }        
    }
    
    static func getPlayersProfitOrLoss(from start: Date, to end: Date) throws -> [PlayerProfitOrLoss] {
        let DB = LocalDB.shared.getDB()
        var retArray = [PlayerProfitOrLoss]()
        let items = try DB.prepare(players)
        let allGameStatus = try GPlayerStatusTable.findAllWithDate()
        for item in items {
            let resItem = PlayerProfitOrLoss(ID: item[id], name: item[name], money: 0)
            for gameStatus in allGameStatus {
                if gameStatus.playerID == resItem.ID && gameStatus.date >= start && gameStatus.date <= end {
                    print("haha \(resItem.ID)")
                    resItem.money += gameStatus.sumCashOut - gameStatus.sumCashAfterFee
                }
            }
            retArray.append(resItem)
        }
        return retArray
    }
}
