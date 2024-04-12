//
//  GeneralService.swift
//  PokerTracker
//
//  Created by Hai Nam on 9/4/24.
//

import Foundation
class GeneralService {
}

//MARK: - Home Screen
extension GeneralService {
 
    static func createAGame(game: Game) throws -> Game? {
        return try GameTable.insert(item: game)
    }
    
    static func getAllGames() throws -> [Game]? {
        return try GameTable.findAll()
    }
    
}

//MARK: - Game Screen
extension GeneralService {
    
    static func getAllPlayers() throws -> [Player]? {
        return try PlayerTable.findAll()
    }
    
    static func createNewPlayer(player: Player) throws {
        try PlayerTable.insert(item: player)
    }
    
    static func addPlayerToAGame(playerID: Int, gameID: Int) throws {
        try GPlayerStatusTable.insert(item: GPlayerStatus(playerID: playerID, gameID: gameID, playerActive: false, sumCashIn: 0, sumCashOut: 0, sumChip: 0, sumCashAfterFee: 0))
    }
    
}

//MARK: - Player Screen
extension GeneralService {
    
    static func cashInOrCashOut(gameRecord: GameRecord) throws {
        try GameRecordTable.insert(item: gameRecord)
    }
    
    static func getPlayers(byGameID gameID: Int) throws -> [GetActivePlayerResult] {
        return try GPlayerStatusTable.getAllPlayer(gameID: gameID)
    }
    
}

//MARK: - History Screen
extension GeneralService {
    
    static func getRecordHistory(byGameID gameID: Int) throws -> [GetGameRecordResult] {
        return try GameRecordTable.findAll(byGameID: gameID)
    }
    
    static func updateARecord(gameRecord: GameRecord) throws {
        try GameRecordTable.update(item: gameRecord)
        try GPlayerStatusTable.deleteARecord(gameRecord: gameRecord)
        try GPlayerStatusTable.update(withNewMoneyRecord: gameRecord)
    }
    
}

//MARK: - Filter Screen
extension GeneralService {
    
}
