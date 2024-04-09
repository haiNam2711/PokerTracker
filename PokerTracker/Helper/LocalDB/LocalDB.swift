//
//  LocalDB.swift
//  PokerTracker
//
//  Created by Hai Nam on 9/4/24.
//

import Foundation
import SQLite

class LocalDB {
    static let shared = LocalDB()
    private var db: Connection!
    
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
        
        do {
            db = try Connection("\(path)/db.sqlite3")
            print(db)
            createPlayerTable()
            createGameTable()
            createGameRecordTable()
            createPlayerInGameTable()
        } catch {
            print("Lỗi khi kết nối đến cơ sở dữ liệu: \(error)")
        }
    }
    
    func getDB()->Connection {
        return db
    }
    
    func createGameTable() {
        let games = Table("Game")
        let id = Expression<Int>("GameID")
        let time = Expression<Date>("Time")
        let cashIn = Expression<Int>("CashIn")
        let chipOut = Expression<Int>("ChipOut")
        let fee = Expression<Int>("Fee")
        
        do {
            try db.run(games.create { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(time)
                table.column(cashIn)
                table.column(chipOut)
                table.column(fee)
            })
            print("Bảng Game được tạo mới.")
        } catch {
            print("Lỗi khi tạo bảng Game: \(error)")
        }
    }
    
    func createPlayerTable() {
        let players = Table("Player")
        let id = Expression<Int>("PlayerID")
        let name = Expression<String>("Name")

        do {
            try db.run(players.create { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(name)
            })
            print("Bảng Player đã được tạo thành công.")
        } catch {
            print("Lỗi khi tạo bảng Player: \(error)")
        }
    }
    
    func createGameRecordTable() {
        let gameRecords = Table("GameRecord")
        let gameID = Expression<Int>("GameID")
        let playerID = Expression<Int>("PlayerID")
        let time = Expression<Date>("Time")
        let cashIn = Expression<Int>("CashIn")
        let cashOut = Expression<Int>("CashOut")
        
        do {
            let gameTable = Table("Game")
            let playerTable = Table("Player")
            try db.run(gameRecords.create { table in
                table.column(gameID)
                table.column(playerID)
                table.column(time)
                table.column(cashIn)
                table.column(cashOut)
                
                table.foreignKey(gameID, references: gameTable, gameID)
                table.foreignKey(playerID, references: playerTable, playerID)
            })
            print("Bảng GameRecord đã được tạo thành công.")
        } catch {
            print("Lỗi khi tạo bảng GameRecord: \(error)")
        }
    }
    
    func createPlayerInGameTable() {
        let playerInGame = Table("PlayerInGame")
        let gameID = Expression<Int>("GameID")
        let playerID = Expression<Int>("PlayerID")
        let sumCashIn = Expression<Int>("SumCashIn")
        let sumCashOut = Expression<Int>("SumCashOut")
        
        do {
            let gameTable = Table("Game")
            let playerTable = Table("Player")
            try db.run(playerInGame.create { table in
                table.column(gameID)
                table.column(playerID)
                table.column(sumCashIn)
                table.column(sumCashOut)
                table.primaryKey(gameID, playerID)
                table.foreignKey(gameID, references: gameTable, gameID)
                table.foreignKey(playerID, references: playerTable, playerID)
            })
            print("Bảng PlayerInGame đã được tạo thành công.")
        } catch {
            print("Lỗi khi tạo bảng PlayerInGame: \(error)")
        }
    }
    
}

class DBError: Error {
    let message: String
    init(message: String) {
        self.message = message
    }
}
